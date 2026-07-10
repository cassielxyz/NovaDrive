import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_provider.dart';

class FluidSweepBorderPainter extends CustomPainter {
  final double borderWidth;
  final BorderRadius borderRadius;
  final BoxShape shape;
  final List<Color> colors;
  final Offset centerOffset;
  final Offset endOffset;

  FluidSweepBorderPainter({
    required this.borderWidth,
    required this.borderRadius,
    required this.shape,
    required this.colors,
    required this.centerOffset,
    required this.endOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment(centerOffset.dx, centerOffset.dy),
        end: Alignment(endOffset.dx, endOffset.dy),
      ).createShader(rect);

    if (shape == BoxShape.circle) {
      canvas.drawCircle(rect.center, min(rect.width, rect.height) / 2 - borderWidth / 2, paint);
    } else {
      final rrect = RRect.fromRectAndCorners(
        rect.deflate(borderWidth / 2),
        topLeft: borderRadius.topLeft,
        topRight: borderRadius.topRight,
        bottomLeft: borderRadius.bottomLeft,
        bottomRight: borderRadius.bottomRight,
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant FluidSweepBorderPainter oldDelegate) => true;
}

class FluidSweepBorder extends ConsumerStatefulWidget {
  final Widget child;
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;
  final BoxShape shape;

  const FluidSweepBorder({
    super.key,
    required this.child,
    required this.colors,
    this.borderWidth = 1.0,
    this.borderRadius = BorderRadius.zero,
    this.shape = BoxShape.rectangle,
  });

  @override
  ConsumerState<FluidSweepBorder> createState() => _FluidSweepBorderState();
}

class _FluidSweepBorderState extends ConsumerState<FluidSweepBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _phaseX;
  late double _phaseY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    final rand = Random();
    _phaseX = rand.nextDouble() * 2 * pi;
    _phaseY = rand.nextDouble() * 2 * pi;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = ref.watch(themeProvider).reduceMotion;

    if (reduceMotion) {
      return CustomPaint(
        painter: FluidSweepBorderPainter(
          borderWidth: widget.borderWidth,
          borderRadius: widget.borderRadius,
          shape: widget.shape,
          colors: widget.colors,
          centerOffset: const Offset(-0.8, -0.8),
          endOffset: const Offset(0.8, 0.8),
        ),
        child: Padding(
          padding: EdgeInsets.all(widget.borderWidth),
          child: widget.child,
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value * 2 * pi;
          
          final beginX = sin(t + _phaseX) * 0.8;
          final beginY = cos(t * 2 + _phaseY) * 0.8;
          final endX = sin(t * 3 + pi + _phaseX) * 0.8;
          final endY = cos(t + pi + _phaseY) * 0.8;

          return CustomPaint(
            painter: FluidSweepBorderPainter(
              borderWidth: widget.borderWidth,
              borderRadius: widget.borderRadius,
              shape: widget.shape,
              colors: widget.colors,
              centerOffset: Offset(beginX, beginY),
              endOffset: Offset(endX, endY),
            ),
            child: Padding(
              padding: EdgeInsets.all(widget.borderWidth),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}

class FluidSweepText extends ConsumerStatefulWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final bool isStroke;
  final double strokeWidth;

  const FluidSweepText({
    super.key,
    required this.text,
    required this.style,
    required this.colors,
    this.isStroke = false,
    this.strokeWidth = 1.0,
  });

  @override
  ConsumerState<FluidSweepText> createState() => _FluidSweepTextState();
}

class _FluidSweepTextState extends ConsumerState<FluidSweepText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _phaseX;
  late double _phaseY;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
    final rand = Random();
    _phaseX = rand.nextDouble() * 2 * pi;
    _phaseY = rand.nextDouble() * 2 * pi;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = ref.watch(themeProvider).reduceMotion;

    if (reduceMotion) {
      return ShaderMask(
        shaderCallback: (bounds) {
          return SweepGradient(
            colors: widget.colors,
            center: const Alignment(0, 0),
          ).createShader(bounds);
        },
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: widget.isStroke
              ? widget.style.copyWith(
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = widget.strokeWidth
                    ..color = Colors.white,
                )
              : widget.style.copyWith(color: Colors.white),
        ),
      );
    }

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value * 2 * pi;
          
          final rotation = t + _phaseX;
          final cx = sin(t + _phaseX) * 0.3;
          final cy = cos(t * 2 + _phaseY) * 0.3;

          return ShaderMask(
            shaderCallback: (bounds) {
              return SweepGradient(
                colors: widget.colors,
                transform: GradientRotation(rotation),
                center: Alignment(cx, cy),
              ).createShader(bounds);
            },
            child: Text(
              widget.text,
              textAlign: TextAlign.center,
              style: widget.isStroke
                  ? widget.style.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = widget.strokeWidth
                        ..color = Colors.white,
                    )
                  : widget.style.copyWith(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
