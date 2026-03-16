import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sficon/flutter_sficon.dart';
enum NetworkStrength {
  none,
  weak,
  medium,
  strong,
}
class InternetIndicator extends StatefulWidget {
  const InternetIndicator({super.key});

  @override
  State<InternetIndicator> createState() => _InternetIndicatorState();
}

class _InternetIndicatorState extends State<InternetIndicator> {
  NetworkStrength _strength = NetworkStrength.none;

  Future<NetworkStrength> checkInternetStrength() async {
    try {
      final sw = Stopwatch()..start();

      final result = await InternetAddress.lookup('matrix.dropslab.com');

      sw.stop();

      if (result.isEmpty) {
        return NetworkStrength.none;
      }

      final latency = sw.elapsedMilliseconds;

      if (latency < 120) return NetworkStrength.strong;
      if (latency < 300) return NetworkStrength.medium;
      return NetworkStrength.weak;
    } catch (_) {
      return NetworkStrength.none;
    }
  }

  @override
  void initState() {
    super.initState();
    _check();

    Timer.periodic(const Duration(seconds: 8), (_) {
      _check();
    });
  }

  Future<void> _check() async {
    final s = await checkInternetStrength();

    if (!mounted) return;

    setState(() {
      _strength = s;
    });
  }

  Color _color() {
    switch (_strength) {
      case NetworkStrength.strong:
        return Colors.green;

      case NetworkStrength.medium:
        return Colors.orange;

      case NetworkStrength.weak:
        return Colors.redAccent;

      case NetworkStrength.none:
        return Colors.grey;
    }
  }

  IconData _icon() {
    if (_strength == NetworkStrength.none) {
      return SFIcons.sf_wifi_slash;
    }
    return SFIcons.sf_wifi;
  }

  @override
  Widget build(BuildContext context) {
    return SFIcon(
      _icon(),
      fontSize: 18,
      //color: _color(),
    );
  }
}