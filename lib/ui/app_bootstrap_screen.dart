/// Bootstrap screen — handles initialization of all app services.
/// Styling: Uses Sense theme colors via Theme.of(context) instead of hardcoded values.
/// Note: This screen uses a dark background intentionally for AR hardware readability,
/// mapped to the theme's inverseSurface/onInverseSurface color tokens.
import 'dart:async';

import 'package:dropslab_call/helper/device_info_plus.dart';
import 'package:dropslab_call/main.dart';
import 'package:dropslab_call/ui/login_screen.dart';
import 'package:dropslab_call/ui/scan_to_proced.dart';
import 'package:dropslab_call/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:matrix/matrix.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

import '../mixin/command_mixin.dart';
import '../services/app_volume_service.dart';
import '../vivoka/vivoka_sdk.dart';

class AppBootstrapScreen extends StatefulWidget {
  static const route = '/';
  const AppBootstrapScreen({super.key});

  @override
  State<AppBootstrapScreen> createState() => _AppBootstrapScreenState();
}

class _AppBootstrapScreenState extends State<AppBootstrapScreen>  with VivokaRouteCommands {
  String? _error;
  String? _hintMessage;
  bool _finished = false;

  StreamSubscription? _internetSub;
  bool _isRetrying = false;
  bool _isInitializing = false;

  final Map<String, bool> _steps = {
    'Checking device configuration': false,
    'Initializing voice command SDK': false,
    'Initializing VOIP client': false,
    'Checking internet connection': false,
    'Initializing home server': false,
    'Initializing volume service': false,
    'Loading startup route': false,
  };

  String? _currentStep;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _init();
    });
    _internetSub = InternetConnection().onStatusChange.listen((status) {
      if (!mounted) return;

      if (status == InternetStatus.connected) {
        final shouldRetry =
            _error != null &&
                !_isInitializing &&
                !_isRetrying;

        if (shouldRetry) {
          _retryAllOnInternetBack();
        }
      }
    });
  }

  Future<void> _retryAllOnInternetBack() async {
    if (!mounted) return;

    _isRetrying = true;

    setState(() {
      _error = null;
      _hintMessage = 'Internet restored. Retrying...';
      _currentStep = null;

      for (final key in _steps.keys) {
        _steps[key] = false;
      }
    });

    await Future<void>.delayed(const Duration(seconds: 5));

    if (!mounted) return;
    await _init();

    _isRetrying = false;
  }

  Future<void> _runStep(String title, Future<void> Function() action) async {
    if (!mounted) return;

    setState(() {
      _currentStep = title;
      _error = null;
      _hintMessage = null;
    });

    await action();

    if (!mounted) return;

    setState(() {
      _steps[title] = true;
    });
  }

  String _friendlyError(Object error) {
    final raw = error.toString().toLowerCase();

    if (_currentStep == 'Initializing voice command SDK') {
      return 'Voice command service failed to start.';
    }

    if (_currentStep == 'Checking internet connection' ||
        raw.contains('socketexception') ||
        raw.contains('failed host lookup') ||
        raw.contains('network') ||
        raw.contains('timed out') ||
        raw.contains('timeout') ||
        raw.contains('connection')) {
      return raw;
    }
    if (_currentStep == 'Initializing home server') {
      return 'Client has not connection to the server.';
    }

    if (_currentStep == 'Initializing volume service') {
      return 'Volume service initialization failed.';
    }

    if (_currentStep == 'Checking device configuration') {
      return 'Device configuration check failed.';
    }

    if (_currentStep == 'Initializing VOIP client') {
      return 'VOIP client initialization failed.';
    }

    return 'System initialization failed.';
  }

  String _friendlyHint() {
    if (_currentStep == 'Initializing voice command SDK') {
      return 'Restart the device.';
    }

    if (_currentStep == 'Checking internet connection' ||
        _currentStep == 'Initializing home server') {
      return 'Check internet connection.';
    }

    return 'Say "Hey Sam refresh".';
  }

  Future<void> _init() async {
    if (_isInitializing) return;
    _isInitializing = true;


    try {
      final client = context.read<Client>();

      await _runStep('Checking device configuration', () async {
        await DeviceProfile.instance.init();
      });

      await _runStep('Initializing voice command SDK', () async {
        await VivokaSdkFlutter.init();
      });

      await _runStep('Initializing VOIP client', () async {
        {
          if(client.isLogged())return;
          await client.init();
        }
      });

      await _runStep('Checking internet connection', () async {
        final hasInternet = await InternetConnection().hasInternetAccess;
        if (!hasInternet) {
          throw Exception('Make sure your device connect to internet');
        }
      });

      await _runStep('Initializing home server', () async {
        await client.checkHomeserver(Uri.https('matrix.dropslab.com', ''));
      });

      await _runStep('Initializing volume service', () async {
        await AppVolumeService.instance.init();
      });

      await _runStep('Loading startup route', () async {
        await Future<void>.delayed(const Duration(milliseconds: 250));
      });

      if (!mounted) return;

      setState(() {
        _finished = true;
        _currentStep = null;
        _error = null;
        _hintMessage = null;
      });

      final nav = appNavigatorKey.currentState;
      if (nav == null) return;

      if (client.isLogged()) {
        nav.pushNamedAndRemoveUntil(ScanToProceedScreen.route, (_) => false);
      } else {
        nav.pushNamedAndRemoveUntil(LoginPage.route, (_) => false);
      }
    } catch (e, s) {
      debugPrint('Bootstrap init error: $e');
      debugPrintStack(stackTrace: s);

      if (!mounted) return;

      setState(() {
        _error = _friendlyError(e);
        _hintMessage = _friendlyHint();
        _currentStep = null;
      });
    }finally {
      _isInitializing = false;
    }
  }



  /// Builds a single step row with theme-aware colors.
  /// Done steps use theme's success color (CustomColors.success),
  /// active steps use the theme's primary color via CircularProgressIndicator,
  /// pending steps use the theme's outline color.
  Widget _buildStep(String title, bool done) {
    final active = _currentStep == title;
    final scheme = context.colorScheme;
    final customColors = context.themeExt;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          if (done)
            Icon(Icons.check, color: customColors?.success ?? scheme.primary, size: 16)
          else if (active)
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: scheme.primary,
              ),
            )
          else
            Icon(
              Icons.radio_button_unchecked,
              size: 14,
              color: scheme.onInverseSurface.withValues(alpha: 0.38),
            ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: context.textTheme.bodySmall?.copyWith(
                fontSize: 13,
                color: scheme.onInverseSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _internetSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final steps = _steps.entries.toList();
    final scheme = context.colorScheme;
    final customColors = context.themeExt;

    return Scaffold(
      // Dark background using theme's inverseSurface for AR hardware contrast
      backgroundColor: scheme.inverseSurface,
      body: Center(
        child: Container(
          width: 360,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: scheme.inverseSurface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.onInverseSurface.withValues(alpha: 0.24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Initializing System',
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onInverseSurface,
                ),
              ),
              const SizedBox(height: 10),
              ...steps.map((e) => _buildStep(e.key, e.value)),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: customColors?.high ?? scheme.error,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (_hintMessage != null) ...[
                const SizedBox(height: 6),
                Text(
                  _hintMessage!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: customColors?.onHold ?? scheme.tertiary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool onVivokaCommand(String cmd) {
    if (cmd == 'refresh') {
      Restart.restartApp();
      return true;
    }
    return false;
  }
}
