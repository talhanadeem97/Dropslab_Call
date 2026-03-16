import 'package:just_audio/just_audio.dart';

class UserMediaManager {
  static final UserMediaManager _instance = UserMediaManager._internal();
  factory UserMediaManager() => _instance;

  UserMediaManager._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> startRingingTone() async {
    const path = 'assets/sounds/phone.ogg';

    await _player.setAsset(path);
    await _player.play();
  }

  Future<void> stopRingingTone() async {
     _player.stop();
  }
}