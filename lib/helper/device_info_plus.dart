import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceProfile {
  DeviceProfile._internal();

  static final DeviceProfile instance = DeviceProfile._internal();

  factory DeviceProfile() => instance;
  bool isARSpectra = false;
  bool isMobileCamera = true;

  String manufacturer = '';
  String model = '';
  String device = '';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    if (!Platform.isAndroid) {
      _initialized = true;
      return;
    }

    final info = DeviceInfoPlugin();
    final android = await info.androidInfo;

    manufacturer = android.manufacturer;
    model = android.model;
    device = android.device;

    final man = manufacturer.toLowerCase();

    if (man.contains("moziware") ||
        (man.contains("qualcomm") && model != "R36-S")) {
      isMobileCamera = false;
      isARSpectra = man.contains("qualcomm");
    } else {
      isARSpectra = false;
      isMobileCamera = true;
    }

    _initialized = true;
  }
}