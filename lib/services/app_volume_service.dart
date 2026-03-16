import 'dart:io';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';

class AppVolumeService {
  AppVolumeService._();
  static final AppVolumeService instance = AppVolumeService._();

  Future<void> init() async {
    await FlutterVolumeController.updateShowSystemUI(true);

    if (Platform.isAndroid) {
      await FlutterVolumeController.setAndroidAudioStream(
        stream: AudioStream.music,
      );
    }
  }

  Future<void> useNormalVolume() async {
    if (Platform.isAndroid) {
      await FlutterVolumeController.setAndroidAudioStream(
        stream: AudioStream.music,
      );
    }
  }

  Future<void> useCallVolume() async {
    if (Platform.isAndroid) {
      await FlutterVolumeController.setAndroidAudioStream(
        stream: AudioStream.voiceCall,
      );
    }
  }

  Future<void> setVolumePercent(int percent, bool inCall) async {
    final value = (percent.clamp(0, 100)) / 100.0;
    await FlutterVolumeController.setVolume(value, stream: inCall ? AudioStream.voiceCall : AudioStream.music);
  }

  Future<void> volumeUp(bool inCall, {double step = 0.15}) async {
    await FlutterVolumeController.raiseVolume(step, stream: inCall ? AudioStream.voiceCall : AudioStream.music);
  }

  Future<void> volumeDown(bool inCall, {double step = 0.15}) async {
    await FlutterVolumeController.lowerVolume(step, stream: inCall ? AudioStream.voiceCall : AudioStream.music);
  }


  Future<void> handleVoiceCommand(String command, bool inCall) async {
    final c = command.toLowerCase().trim();

    final match = RegExp(r'set volume (\d+)').firstMatch(c);
    if (match != null) {
      final percent = int.parse(match.group(1)!);
      await setVolumePercent(percent, inCall);
      return;
    }

    if (c == 'volume up') {
      await volumeUp(inCall);
      return;
    }

    if (c == 'volume down') {
      await volumeDown(inCall);
      return;
    }

  }


}