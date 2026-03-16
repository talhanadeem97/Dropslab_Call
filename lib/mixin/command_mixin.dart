import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:dropslab_call/services/app_volume_service.dart';

import '../../main.dart';
import '../dispatccher/command_dispatcher.dart';

mixin VivokaRouteCommands<T extends StatefulWidget> on State<T>
implements RouteAware {
  Object? _token;

  /// screen-specific handler implement karo
  bool onVivokaCommand(String cmd);

  /// call screen ho to override kar dena
  bool get isCallScreen => false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  Future<void> _updateAudioStream() async {
    if (!Platform.isAndroid) return;

    print('volume stream type ${isCallScreen}');

    if(isCallScreen) {
      AppVolumeService.instance.useCallVolume();
    } else {
      AppVolumeService.instance.useNormalVolume();
    }
  }

  Future<void> _enable() async {
    if (_token != null) return;

    _token = VivokaCommandDispatcher.I.register(
      onVivokaCommand,
      debugName: T.toString(),
    );

    await _updateAudioStream();
  }

  Future<void> _disable() async {
    final t = _token;
    if (t != null) {
      VivokaCommandDispatcher.I.unregister(t);
      _token = null;
    }

    AppVolumeService.instance.useNormalVolume();
  }

  @override
  void didPush() {
    _enable();
  }

  @override
  void didPop() {
    _disable();
  }

  @override
  void didPushNext() {
    _disable(); // another screen on top
  }

  @override
  void didPopNext() {
    _enable(); // back to this screen
  }

  @override
  void dispose() {
    _disable();
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}