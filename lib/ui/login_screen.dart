/// Login screen — handles Matrix authentication.
/// Styling: Uses Sense theme via ThemeData — AppBar, buttons, and inputs
/// automatically inherit the global Sense theme. No hardcoded colors needed.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:matrix/matrix.dart';
import 'package:dropslab_call/ui/scan_to_proced.dart';
import 'package:dropslab_call/vivoka/vivoka_sdk.dart';
import 'package:dropslab_call/voip/voip_service.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../mixin/command_mixin.dart';
import '../component/custom_glass_icon.dart';
import '../component/floating_glass.dart';
import '../component/message_bar.dart';
import '../helper/matrix_text_helper.dart';
import '../main.dart';
import '../services/app_volume_service.dart';
import 'barcode_scanner.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';

  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with VivokaRouteCommands {
  StreamSubscription? _subscription;

  final user = TextEditingController();
  final pass = TextEditingController();

  FocusNode userFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool loading = false;

  Future<void> _login() async {
    setState(() => loading = true);
    try {
      final client = context.read<Client>();

      await client.login(
        LoginType.mLoginPassword,
        password: pass.text,
        identifier: AuthenticationUserIdentifier(user: user.text.trim()),
      );

      if (!mounted) return;
      await context.read<VoipService>().start();

      if (!mounted) return;
      final nav = appNavigatorKey.currentState;
      if (nav != null) {
        nav.pushNamedAndRemoveUntil(ScanToProceedScreen.route, (_) => false);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      setState(() => loading = false);
    }
  }

  @override
  bool get isCallScreen => false;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> scanToLogin() async {
    try {
      final nav = appNavigatorKey.currentState;
      if (nav == null) return;
      final String? code = await nav.pushNamed<String?>(BarcodeScanner.route, arguments: 'LOGIN:U:<user>;P:<password>;;');
      if (code != null) {
        final (username, password) = MatrixTextHelper.handleQR(code)!;
        user.text = username;
        pass.text = password;
        await _login();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    // All styling comes from the global Sense theme:
    // - AppBar inherits appBarTheme from buildTheme()
    // - ElevatedButton inherits elevatedButtonTheme from buildTheme()
    // - MessageBar uses inputDecorationTheme colors
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                MessageBar(
                  controller: user,
                  focusNode: userFocus,
                  readOnly: loading,
                  hint: 'Username',
                  suffix: CustomGlassButton(
                    sfIcon: SFIcons.sf_qrcode_viewfinder,
                    iconSize: 16,
                    onTap: () {
                      scanToLogin();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                MessageBar(controller: pass, readOnly: loading, focusNode: passwordFocus, obscureText: true, hint: 'Password'),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : _login,
                    child: loading ? const LinearProgressIndicator() : const Text('Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool onVivokaCommand(String cmd) {
    if (cmd == 'user name') {
      userFocus.requestFocus();
      return true;
    }
    if (cmd == 'password') {
      passwordFocus.requestFocus();
      return true;
    }
    if (cmd case 'login' || 'log in') {
      FocusManager.instance.primaryFocus?.unfocus();
      _login();
      return true;
    }
    if (cmd == 'done') {
      FocusManager.instance.primaryFocus?.unfocus();
      return true;
    }
    if (cmd  == 'scan') {
      scanToLogin();
      return true;
    }
    if (cmd case 'flash on' || 'torch on' || 'light on') {
      VivokaSdkFlutter.toggleTorch(true);
      return true;
    }  if (cmd case 'flash off' || 'torch off' || 'light off') {
      VivokaSdkFlutter.toggleTorch(false);
      return true;
    }  if (cmd == 'refresh') {
      Restart.restartApp();
      return true;
    }
    if(cmd case 'volume up' || 'volume down'){
      AppVolumeService.instance.handleVoiceCommand(cmd, false);
      return true;
    }
    if(cmd.contains('set volume')){
      AppVolumeService.instance.handleVoiceCommand(cmd, true);
      return true;
    }

    return false;
  }
}
