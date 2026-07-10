import 'dart:io';
import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Generate Logo PNG', (WidgetTester tester) async {
    const size = Size(512, 512);
    
    // The logo widget
    final widget = Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: size.width,
        height: size.height,
        color: const Color(0xFF131314), // AppColors.surface
        child: Center(
          child: Transform.scale(
            scale: 3.0,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Orbit Arc
                CustomPaint(
                  size: const Size(180, 180),
                  painter: _OrbitPainter(
                    progress: 2 * pi,
                    color: const Color(0xFFC9BFFF).withOpacity(0.1),
                  ),
                ),
                // Core Logo Shape
                Transform.rotate(
                  angle: pi / 2,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFC9BFFF),
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFC9BFFF),
                          const Color(0xFFC9BFFF).withOpacity(0.7)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
                // Inner Counter-Rotating Element
                Transform.rotate(
                  angle: -pi / 2,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Render the widget to an image
    final repaintBoundary = RepaintBoundary(child: widget);
    final renderView = tester.binding.renderView;
    
    await tester.pumpWidget(repaintBoundary);
    await tester.pumpAndSettle();

    final element = tester.element(find.byType(RepaintBoundary));
    final renderObject = element.renderObject as RenderRepaintBoundary;
    
    final image = await renderObject.toImage(pixelRatio: 1.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    // Save to file
    final file = File('assets/images/generated_logo.png');
    await file.writeAsBytes(buffer);
    print('Logo generated successfully!');
  });
}

class _OrbitPainter extends CustomPainter {
  final double progress;
  final Color color;

  _OrbitPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width,
      height: size.height,
    );

    if (progress > 0) {
      canvas.drawArc(rect, -pi / 2, progress, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
