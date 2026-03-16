import 'dart:async';

import 'package:dropslab_call/helper/internet_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:matrix/matrix.dart';
import 'package:dropslab_call/component/message_bar.dart';
import 'package:dropslab_call/vivoka/vivoka_sdk.dart';
import 'package:dropslab_call/voip/voip_service.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../mixin/command_mixin.dart';
import '../component/floating_glass.dart';
import '../helper/matrix_text_helper.dart';
import '../main.dart';
import '../services/app_volume_service.dart';
import 'barcode_scanner.dart';
import 'call_screen.dart';
import 'login_screen.dart';

class ScanToProceedScreen extends StatefulWidget {
  static const route = '/scanToProceed';

  const ScanToProceedScreen({super.key});

  @override
  State<ScanToProceedScreen> createState() => _ScanToProceedScreenState();
}

class _ScanToProceedScreenState extends State<ScanToProceedScreen> with VivokaRouteCommands {
  final user = TextEditingController();
  final FocusNode userFocus = FocusNode();
  bool loading = false;
  void _setLoading(bool value) {
    if (!mounted) return;
    setState(() => loading = value);
  }

  @override
  bool get isCallScreen => false;

  @override
  void initState() {
    super.initState();

    user.addListener(() {
      final normalized = MatrixTextHelper.normalizeUsername(user.text);
      if (user.text != normalized) {
        user.value = user.value.copyWith(
          text: normalized,
          selection: TextSelection.collapsed(offset: normalized.length),
          composing: TextRange.empty,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await context.read<VoipService>().start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan to Proceed'),
        actions: [
          /*StreamBuilder(
            stream: InternetConnection().onStatusChange,
            builder: (_, status) {
              return status.data == InternetStatus.connected
                  ? SFIcon(SFIcons.sf_wifi, fontSize: 18)
                  : SFIcon(SFIcons.sf_wifi_slash, fontSize: 18);
            },
          ),*/

          FloatingGlassButton(sfIcon: SFIcons.sf_rectangle_portrait_and_arrow_forward, onTap: loading ? null : _logout),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Spacer(),
            MessageBar(
              controller: user,
              focusNode: userFocus,
              readOnly: loading,
              hint: 'Scan ID to Start Call',
              prefix: SFIcon(SFIcons.sf_at, fontSize: 16),
              suffixText: ':✱✱✱✱.dropslab.com',
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: loading ? null : () => startCall(user.text),
                  child: loading
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Continue'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: loading ? null : scanCode,
                  label: const Text('Scan'),
                  icon: SFIcon(SFIcons.sf_qrcode_viewfinder, fontSize: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    user.dispose();
    userFocus.dispose();
    super.dispose();
  }

  Future<void> scanCode() async {
    final nav = appNavigatorKey.currentState;
    if (nav == null) return;

    try {
      final String? code = await nav.pushNamed<String?>(BarcodeScanner.route, arguments: '<username>');
      if (code != null) {
        final username = MatrixTextHelper.normalizeUsername(code);
        user.text = username;
        await startCall(username);
      }
    } catch (_) {}
  }

  Future<void> startCall(String? code) async {
    if (code == null || code.trim().isEmpty) return;

    final username = MatrixTextHelper.normalizeUsername(code);

    if (!MatrixTextHelper.isValidUsername(username)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid username')));
      return;
    }

    final matrixId = MatrixTextHelper.buildMatrixId(username);

    if (!MatrixTextHelper.isValidMatrixId(matrixId)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid ID')));
      return;
    }

    _setLoading(true);
    try {
      final client = context.read<Client>();
      final Room room = client.rooms.firstWhere(
        (e) => e.directChatMatrixID == matrixId,
        orElse: () => Room(id: '-1', client: client),
      );

      if (room.id != '-1') {
        user.text = username;
        await _startVideoCall(room);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No direct chat found for $matrixId')));
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _startVideoCall(Room room) async {
    final other = room.directChatMatrixID;
    final nav = appNavigatorKey.currentState;

    if (!mounted) return;

    await context.read<VoipService>().callUser(roomId: room.id, userId: other ?? '', type: CallType.kVideo);

    if (!mounted || nav == null) return;
    await nav.pushNamed(CallScreen.route, arguments: room);
  }

  Future<void> _logout() async {
    if (loading) return;

    FocusManager.instance.primaryFocus?.unfocus();

    _setLoading(true);
    try {
      final client = context.read<Client>();
      await context.read<VoipService>().stop();
      await client.logout();

      if (!mounted) return;
      final nav = appNavigatorKey.currentState;
      if (nav != null) {
        nav.pushNamedAndRemoveUntil(LoginPage.route, (_) => false);
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  bool onVivokaCommand(String cmd) {
    if (loading) return true;

    if (cmd == 'scan') {
      scanCode();
      return true;
    }
    if (cmd == 'continue') {
      startCall(user.text);
      return true;
    }
    if (cmd == 'logout') {
      _logout();
      return true;
    }
    if (cmd == 'done') {
      FocusManager.instance.primaryFocus?.unfocus();
      return true;
    }
    if (cmd case 'flash on' || 'torch on' || 'light on') {
      VivokaSdkFlutter.toggleTorch(true);
      return true;
    }
    if (cmd case 'flash off' || 'torch off' || 'light off') {
      VivokaSdkFlutter.toggleTorch(false);
      return true;
    }
    if (cmd == 'refresh') {
      Restart.restartApp();
      return true;
    }

    if (cmd case 'volume up' || 'volume down') {
      AppVolumeService.instance.handleVoiceCommand(cmd, false);
      return true;
    }
    if (cmd.contains('set volume')) {
      AppVolumeService.instance.handleVoiceCommand(cmd, false);
      return true;
    }

    return false;
  }
}
