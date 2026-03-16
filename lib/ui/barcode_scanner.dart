/// Barcode/QR scanner screen.
/// Styling: Uses Sense theme colors via Theme.of(context) for AppBar and text.
/// Note: Uses transparent AppBar background for camera overlay, with
/// onInverseSurface color for text/icons to ensure readability on camera feed.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:dropslab_call/services/app_volume_service.dart';
import 'package:dropslab_call/vivoka/vivoka_sdk.dart';
import 'package:dropslab_call/theme/theme_extensions.dart';
import 'package:restart_app/restart_app.dart';

import '../mixin/command_mixin.dart';
import '../helper/device_info_plus.dart';
import '../main.dart';

class BarcodeScanner extends StatefulWidget {
  static const route = '/barcodeScanner';

  final String formatType;

  const BarcodeScanner({super.key, required this.formatType});

  @override
  State<BarcodeScanner> createState() => BarcodeScannerState();
}

class BarcodeScannerState extends State<BarcodeScanner> with VivokaRouteCommands {
  CameraController? cameraController;
  double currentZoom = 1.0;

  @override
  bool get isCallScreen => false;
  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final customColors = context.themeExt;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 3,
        // Use onInverseSurface for icons/text over camera preview
        iconTheme: IconThemeData(color: scheme.onInverseSurface),
        backgroundColor: Colors.transparent,
        actionsPadding: EdgeInsets.only(right: 20),
        title: Text(
          'Back',
          style: context.textTheme.titleMedium?.copyWith(color: scheme.onInverseSurface),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'QR format e.g. ',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: scheme.onInverseSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: widget.formatType,
                    // Use onHold (amber) for the format type highlight
                    style: context.textTheme.bodySmall?.copyWith(
                      color: customColors?.onHold ?? scheme.tertiary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RotatedBox(quarterTurns: DeviceProfile.instance.isARSpectra ? 3:0, child: _buildScanner()),
    );
  }

  Widget _buildScanner() {
    return ReaderWidget(
      onScan: onSuccess,
      onScanFailure: (c) => c.error?.isNotEmpty == true ? onError(c.error ?? 'Code is not detected') : null,
      onControllerCreated: _onControllerCreated,
      resolution: ResolutionPreset.high,
      lensDirection: CameraLensDirection.back,
      codeFormat: Format.any,
      showGallery: false,
      cropPercent: 0.7,
      showFlashlight: false,
      showToggleCamera: false,
      scanDelaySuccess: Duration(seconds: 8),
      toggleCameraIcon: const Icon(Icons.camera_alt),

      actionButtonsBackgroundBorderRadius: BorderRadius.circular(10),
    );
  }

  void _onControllerCreated(CameraController? c, Exception? error) {
    if (error != null) {
      onError('Error: $error');
    }
    setState(() {
      cameraController = c;
    });
  }

  void onError(String error) {
    final nav = appNavigatorKey.currentState;
    if (nav != null) {
      nav.pop(null);
    }
  }

  bool _handled = false;

  void onSuccess(Code result) async {
    if (_handled) return;

    if (result.isValid) {
      _handled = true;

      if (!kIsWeb) {
        await HapticFeedback.heavyImpact();
        await HapticFeedback.vibrate();
        await Future.delayed(const Duration(milliseconds: 80));
      }

      final nav = appNavigatorKey.currentState;
      if (nav != null) {
        nav.pop(result.text);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    cameraController = null;
  }

  @override
  bool onVivokaCommand(String cmd) {
    if (cmd == 'back') {
      appNavigatorKey.currentState?.pop();
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
    if (cmd == 'zoom in') {
      if (cameraController != null && cameraController!.value.isInitialized) {
        zoomIn();
      }
      return true;
    }
    if (cmd == 'zoom out') {
      if (cameraController != null && cameraController!.value.isInitialized) {
        zoomOut();
      }
      return true;
    }
    if (cmd == 'refresh') {
      Restart.restartApp();
      return true;
    }

    if(cmd case 'volume up' || 'volume down'){
      AppVolumeService.instance.handleVoiceCommand(cmd, false);
      return true;
    }
    if(cmd.contains('set volume')){
      AppVolumeService.instance.handleVoiceCommand(cmd, false);
      return true;
    }

    return false;
  }

  Future<void> zoomIn() async {
    final maxZoom = await cameraController!.getMaxZoomLevel();
    currentZoom = (currentZoom + 0.5).clamp(1.0, maxZoom);
    await cameraController!.setZoomLevel(currentZoom);
  }

  Future<void> zoomOut() async {
    final minZoom = await cameraController!.getMinZoomLevel();
    currentZoom = (currentZoom - 0.5).clamp(minZoom, 10.0);

    await cameraController!.setZoomLevel(currentZoom);
  }
}
