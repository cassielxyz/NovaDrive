import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

import 'dart:math' as math;

class NovaSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final bool readOnly;
  final String hintText;

  const NovaSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onTap,
    this.readOnly = false,
    this.hintText = 'Search in Drive',
  });

  @override
  State<NovaSearchBar> createState() => _NovaSearchBarState();
}

class _NovaSearchBarState extends State<NovaSearchBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500));
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelColor = Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5);
    final borderColor = Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _GradientBorderPainter(
            rotation: _controller.value,
            isFocused: _focusNode.hasFocus,
            borderColor: borderColor,
            primaryColor: primaryColor,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: panelColor,
              borderRadius: AppRadius.radiusFull,
            ),
            child: TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              style: Theme.of(context).textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final double rotation;
  final bool isFocused;
  final Color borderColor;
  final Color primaryColor;

  _GradientBorderPainter({required this.rotation, required this.isFocused, required this.borderColor, required this.primaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(100));

    if (isFocused) {
      final hsl = HSLColor.fromColor(primaryColor);
      final darkColor = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
      final lightColor = hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
      final adjacentColor = hsl.withHue((hsl.hue + 30) % 360).toColor();

      final paint = Paint()
        ..shader = SweepGradient(
          colors: [
            darkColor,
            lightColor,
            adjacentColor,
            primaryColor,
            darkColor,
          ],
          transform: GradientRotation(rotation * 2 * math.pi),
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawRRect(rrect, paint);
    } else {
      final paint = Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(_GradientBorderPainter oldDelegate) => 
    rotation != oldDelegate.rotation || 
    isFocused != oldDelegate.isFocused || 
    borderColor != oldDelegate.borderColor ||
    primaryColor != oldDelegate.primaryColor;
}
