import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum MatrixWaveformState {
  idle,
  listening,
  speaking,
  muted,
}

class MatrixWaveformOptions {
  final int barCount;
  final double spacing;
  final double minHeight;
  final double maxHeight;
  final double cornerRadius;
  final Duration animationDuration;
  final Color? color;
  final double idleOpacity;
  final bool mirrored;

  const MatrixWaveformOptions({
    this.barCount = 7,
    this.spacing = 5,
    this.minHeight = 10,
    this.maxHeight = 72,
    this.cornerRadius = 999,
    this.animationDuration = const Duration(milliseconds: 140),
    this.color,
    this.idleOpacity = 0.20,
    this.mirrored = true,
  });

  Color resolveColor(BuildContext context) {
    return color ?? Theme.of(context).colorScheme.primary;
  }
}

class MatrixCallWaveform extends StatefulWidget {
  final double audioLevel;
  final bool isMuted;
  final bool isLocalUser;
  final MatrixWaveformOptions options;

  /// optional threshold for "speaking"
  final double speakingThreshold;

  const MatrixCallWaveform({
    super.key,
    required this.audioLevel,
    this.isMuted = false,
    this.isLocalUser = false,
    this.options = const MatrixWaveformOptions(),
    this.speakingThreshold = 0.06,
  });

  @override
  State<MatrixCallWaveform> createState() => _MatrixCallWaveformState();
}

class _MatrixCallWaveformState extends State<MatrixCallWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulse;
  late List<double> _displayedBars;

  @override
  void initState() {
    super.initState();
    _displayedBars = List.filled(widget.options.barCount, 0.0);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulse = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant MatrixCallWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    _displayedBars = _generateBars(
      level: widget.audioLevel.clamp(0.0, 1.0),
      state: _determineState(),
      count: widget.options.barCount,
      mirrored: widget.options.mirrored,
      pulseValue: _pulse.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  MatrixWaveformState _determineState() {
    if (widget.isMuted) return MatrixWaveformState.muted;
    if (widget.audioLevel >= widget.speakingThreshold) {
      return MatrixWaveformState.speaking;
    }
    return MatrixWaveformState.listening;
  }

  List<double> _generateBars({
    required double level,
    required MatrixWaveformState state,
    required int count,
    required bool mirrored,
    required double pulseValue,
  }) {
    switch (state) {
      case MatrixWaveformState.muted:
        return List.filled(count, 0.0);

      case MatrixWaveformState.idle:
      case MatrixWaveformState.listening:
        return List.generate(count, (i) {
          final center = (count - 1) / 2;
          final distance = (i - center).abs();
          final factor = 1 - (distance / (center + 0.001));
          final pulse = 0.12 + (0.18 * pulseValue);
          return (factor * pulse).clamp(0.0, 0.35);
        });

      case MatrixWaveformState.speaking:
        if (mirrored) {
          final center = (count - 1) / 2;
          return List.generate(count, (i) {
            final distance = (i - center).abs();
            final falloff = 1 - (distance / (center + 0.001));
            final value = (level * (0.45 + (falloff * 0.9)));
            return value.clamp(0.0, 1.0);
          });
        }

        return List.generate(count, (i) {
          final seed = ((i + 1) * 0.11);
          final value = level * (0.65 + seed);
          return value.clamp(0.0, 1.0);
        });
    }
  }

  double _barHeight(double normalizedValue) {
    final min = widget.options.minHeight;
    final max = widget.options.maxHeight;
    return min + ((max - min) * normalizedValue.clamp(0.0, 1.0));
  }

  Color _barColor(
      BuildContext context,
      int index,
      int count,
      MatrixWaveformState state,
      ) {
    final base = widget.options.resolveColor(context);

    switch (state) {
      case MatrixWaveformState.muted:
        return base.withValues(alpha: 0.12);

      case MatrixWaveformState.listening:
      case MatrixWaveformState.idle:
        final center = (count - 1) / 2;
        final distance = (index - center).abs();
        final factor = 1 - (distance / (center + 0.001));
        final alpha =
            widget.options.idleOpacity + (factor * 0.35 * _pulse.value);
        return base.withValues(alpha: alpha.clamp(0.12, 0.7));

      case MatrixWaveformState.speaking:
        return base;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, _) {
        final state = _determineState();

        final bars = _generateBars(
          level: widget.audioLevel.clamp(0.0, 1.0),
          state: state,
          count: widget.options.barCount,
          mirrored: widget.options.mirrored,
          pulseValue: _pulse.value,
        );

        return LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(bars.length, (index) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: widget.options.spacing / 2,
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: widget.options.animationDuration,
                        curve: Curves.easeOutCubic,
                        height: _barHeight(bars[index]),
                        decoration: BoxDecoration(
                          color: _barColor(context, index, bars.length, state),
                          borderRadius: BorderRadius.circular(
                            widget.options.cornerRadius,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}