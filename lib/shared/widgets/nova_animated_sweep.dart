import 'package:flutter/material.dart';

class AnimatedSweepBorder extends StatefulWidget {
  final Widget child;
  final List<Color> colors;
  final double borderWidth;
  final BorderRadius borderRadius;
  final Duration duration;

  const AnimatedSweepBorder({
    super.key,
    required this.child,
    required this.colors,
    this.borderWidth = 2.0,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<AnimatedSweepBorder> createState() => _AnimatedSweepBorderState();
}

class _AnimatedSweepBorderState extends State<AnimatedSweepBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(widget.borderWidth),
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,
            gradient: SweepGradient(
              center: Alignment.center,
              colors: widget.colors,
              transform: GradientRotation(_controller.value * 2 * 3.14159),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(
                (widget.borderRadius.topLeft.x - widget.borderWidth).clamp(0.0, double.infinity),
              ),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class AnimatedSweepText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;
  final Duration duration;
  final bool isStroke;
  final double strokeWidth;

  const AnimatedSweepText({
    super.key,
    required this.text,
    required this.style,
    required this.colors,
    this.duration = const Duration(seconds: 3),
    this.isStroke = false,
    this.strokeWidth = 1.0,
  });

  @override
  State<AnimatedSweepText> createState() => _AnimatedSweepTextState();
}

class _AnimatedSweepTextState extends State<AnimatedSweepText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return SweepGradient(
              center: Alignment.center,
              colors: widget.colors,
              transform: GradientRotation(_controller.value * 2 * 3.14159),
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
    );
  }
}
