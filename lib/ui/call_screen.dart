import 'dart:async';
import 'dart:math';
import 'package:dropslab_call/component/matrix_call_waveform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
import 'package:matrix/matrix.dart';
import 'package:dropslab_call/component/floating_glass.dart';
import 'package:provider/provider.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:restart_app/restart_app.dart';
import '../mixin/command_mixin.dart';
import '../services/app_volume_service.dart';
import '../voip/voip_service.dart';

class CallScreen extends StatefulWidget {
  final Room room;
  static const route = '/call';

  const CallScreen({super.key, required this.room});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> with VivokaRouteCommands {
  bool switchView = false;
  bool toggleFullScreen = false;
  Timer? _noCallTimer;

  @override
  bool get isCallScreen => true;

  @override
  void initState() {
    super.initState();
    _noCallTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      final voip = context.read<VoipService>();
      if (voip.active == null) {
        voip.clearActive();
      }
    });
  }

  @override
  void dispose() {
    _noCallTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final voip = context.watch<VoipService>();
    final call = voip.active;

    final localReady = voip.localRenderer.srcObject != null;
    final remoteReady = voip.remoteRenderer.srcObject != null;
    final remoteScreenReady = voip.remoteScreenRenderer.srcObject != null;

    final isIncoming = call?.direction == CallDirection.kIncoming;
    final isVideo = call?.type == CallType.kVideo;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Container(
                    color: Colors.black,
                    child: remoteScreenReady
                        ? RTCVideoView(
                            voip.remoteScreenRenderer,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                            mirror: false,
                          )
                        : !switchView
                        ? localView(localReady, voip)
                        : (call != null ? remoteView(remoteReady, voip, call) : localView(localReady, voip)),
                  ),
                ),
               if(!toggleFullScreen)...[
                 if (call != null)
                  Positioned(
                    right: 12,
                    top: 12,
                    width: 110,
                    height: 150,
                    child: FloatingGlassView(
                      borderRadius: 12,
                      backgroundColor: Colors.black,
                      child: !switchView ? remoteView(remoteReady, voip, call) : localView(localReady, voip),
                    ),
                  ),
                Positioned(
                  top: 12,
                  child: FloatingGlassView(
                    borderRadius: 12,
                    backdropFilter: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: call == null
                          ? const Text(
                              'Preparing call...',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            )
                          : _timer(voip.connectedAt),
                    ),
                  ),
                ),
                if (voip.connectionLostMessage != null)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.red.shade700.withValues(alpha: 0.92),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: SafeArea(
                        bottom: false,
                        child: Text(
                          voip.connectionLostMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: max(20, MediaQuery.of(context).viewPadding.bottom)),
                      child: FloatingGlassView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Row(
                            spacing: 5,
                            children: [
                              if (call == null) ...[
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: FloatingGlassButton(
                                    onTap: () => voip.clearActive(),
                                    iconColor: Colors.red,

                                    sfIcon: SFIcons.sf_xmark_circle_fill,
                                  ),
                                ),
                              ] else if (isIncoming == true && call.state == CallState.kRinging) ...[
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: FloatingGlassButton(
                                    iconColor: Colors.green,
                                    onTap: () => voip.answer(),
                                    sfIcon: SFIcons.sf_phone_fill,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: FloatingGlassButton(
                                    iconColor: Colors.red,
                                    onTap: () => voip.reject(),
                                    sfIcon: SFIcons.sf_phone_pause_fill,
                                  ),
                                ),
                              ] else ...[
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: FloatingGlassButton(
                                    onTap: () => voip.setLocalCameraZoomWithCMD('zoom in'),
                                    sfIcon: SFIcons.sf_plus_magnifyingglass,
                                    iconColor: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: FloatingGlassButton(
                                    onTap: () => voip.setLocalCameraZoomWithCMD('zoom out'),
                                    sfIcon: SFIcons.sf_minus_magnifyingglass,
                                    iconColor: Colors.white,
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: FloatingGlassButton(
                                    onTap: () => voip.toggleMic(),
                                    iconColor: Colors.white,
                                    sfIcon: voip.micMuted ? SFIcons.sf_microphone_slash_fill : SFIcons.sf_microphone_fill,
                                    subWidget: SizedBox(
                                      height: 20,
                                      width: 18,
                                      child: MatrixCallWaveform(
                                        audioLevel: voip.smoothedLocalAudioLevel,
                                        isMuted: voip.micMuted,
                                        options: const MatrixWaveformOptions(
                                          color: Colors.white,
                                          spacing: 1,
                                          barCount: 5,
                                          minHeight: 3,
                                          maxHeight: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (isVideo == true)
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: FloatingGlassButton(
                                      onTap: () => voip.toggleCam(),
                                      iconColor: Colors.white,
                                      sfIcon: voip.camMuted ? SFIcons.sf_video_slash_fill : SFIcons.sf_video_fill,
                                    ),
                                  ),

                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: FloatingGlassButton(
                                    onTap: () async {
                                      await voip.hangup();
                                    },
                                    iconColor: Colors.red,
                                    sfIcon: SFIcons.sf_phone_down_fill,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget remoteView(bool ready, VoipService voip, CallSession call) {
    return ready
        ? RTCVideoView(voip.remoteRenderer, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover, mirror: false)
        : Container(
            color: Colors.black,
            alignment: Alignment.center,
            child: Text(
              call.state == CallState.kRinging ? 'Ringing...' : 'Connecting video...',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white),
            ),
          );
  }

  Widget localView(bool ready, VoipService voip) {
    return ready
        ? RTCVideoView(voip.localRenderer, mirror: false, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
        : const Center(child: CircularProgressIndicator());
  }

  String _fmt(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? "${two(h)}:${two(m)}:${two(s)}" : "${two(m)}:${two(s)}";
  }

  Widget _timer(DateTime? connectedAt) {
    if (connectedAt == null) {
      return const Text('00:00', style: TextStyle(color: Colors.white));
    }
    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(seconds: 1), (i) => i),
      builder: (_, _) {
        final d = DateTime.now().difference(connectedAt);
        return Text(
          _fmt(d),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        );
      },
    );
  }

  @override
  bool onVivokaCommand(String cmd) {
    final voip = context.read<VoipService>();
    final call = voip.active;

    if (cmd case 'end call' || 'reject call') {
      if (call == null) {
        voip.clearActive();
        return true;
      }
      final isIncoming = call.direction == CallDirection.kIncoming;
      if (isIncoming && call.state == CallState.kRinging) {
        voip.reject();
      } else {
        voip.hangup();
      }
      return true;
    }

    if (cmd case 'start call' || 'accept call') {
      if (call != null && call.direction == CallDirection.kIncoming && call.state == CallState.kRinging) {
        voip.answer();
      }
      return true;
    }

    if (cmd == 'mute') {
      voip.muteMic(true);
      return true;
    }
    if (cmd == 'unmute') {
      voip.muteMic(false);
      return true;
    }

    if (cmd == 'switch') {
      if (call != null) {
        setState(() => switchView = !switchView);
      }
      return true;
    }

    if (cmd == 'zoom level one') {
      voip.setLocalCameraZoom(1.0);
      return true;
    }
    if (cmd == 'zoom level two') {
      voip.setLocalCameraZoom(2.0);
      return true;
    }
    if (cmd == 'zoom level three') {
      voip.setLocalCameraZoom(3.0);
      return true;
    }
    if (cmd == 'zoom level four') {
      voip.setLocalCameraZoom(4.0);
      return true;
    }
    if (cmd == 'zoom level five') {
      voip.setLocalCameraZoom(5.0);
      return true;
    }

    if (cmd case 'zoom in' || 'zoom out') {
      voip.setLocalCameraZoomWithCMD(cmd);
      return true;
    }

    if (cmd case 'flash on' || 'torch on' || 'light on') {
      voip.flash(true);
      return true;
    }

    if (cmd case 'flash off' || 'torch off' || 'light off') {
      voip.flash(false);
      return true;
    }
    if (cmd == 'refresh') {
      if (call == null) {
        voip.clearActive();
      } else {
        final isIncoming = call.direction == CallDirection.kIncoming;
        if (isIncoming && call.state == CallState.kRinging) {
          voip.reject();
        } else {
          voip.hangup();
        }
      }
      Future.wait([Restart.restartApp()]);
      return true;
    }
    if(cmd == 'toggle full screen'){
      setState(() => toggleFullScreen = !toggleFullScreen);
      return true;
    }
    if(cmd case 'volume up' || 'volume down'){
      AppVolumeService.instance.handleVoiceCommand(cmd, true);
      return true;
    }
    if(cmd.contains('set volume')){
      AppVolumeService.instance.handleVoiceCommand(cmd, true);
      return true;
    }

    return false;
  }
}
