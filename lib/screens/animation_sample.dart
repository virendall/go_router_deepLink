import 'dart:math' as math;
import 'dart:math';
import 'dart:ui' as UI;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnalogClock extends StatefulWidget {
  const AnalogClock({super.key});

  @override
  State<AnalogClock> createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: StreamBuilder(
        stream: Stream.periodic(const Duration(milliseconds: 16)),
        builder: (context, snapshot) {
          final now = DateTime.now();
          return CustomPaint(
            painter: ClockPainter(now),
            size: const Size(300, 300),
          );
        },
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  final DateTime dateTime;

  ClockPainter(this.dateTime);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    // Draw clock face
    final paint =
        Paint()
          ..color = Colors.black
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
    canvas.drawCircle(center, radius, paint);

    // Draw numbers
    TextPainter textPainter = TextPainter(textDirection: UI.TextDirection.ltr);
    double numberRadius = radius - 30;
    for (int i = 1; i <= 12; i++) {
      double angle = (i * pi / 6) - (pi / 2);
      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: i % 3 == 0 ? FontWeight.bold : FontWeight.w500,
        ),
      );
      textPainter.layout();
      double x = center.dx + cos(angle) * numberRadius;
      double y = center.dy + sin(angle) * numberRadius;
      double textOffsetX = textPainter.width / 2;
      double textOffsetY = textPainter.height / 2;
      textPainter.paint(canvas, Offset(x - textOffsetX, y - textOffsetY));
    }

    // Draw minute ticks
    for (int i = 0; i < 60; i++) {
      if (i % 5 != 0) {
        double angle = i * pi / 30;
        double tickLength = 5.0;
        double tickRadius = radius - 10;

        canvas.drawLine(
          Offset(
            center.dx + cos(angle) * tickRadius,
            center.dy + sin(angle) * tickRadius,
          ),
          Offset(
            center.dx + cos(angle) * (tickRadius - tickLength),
            center.dy + sin(angle) * (tickRadius - tickLength),
          ),
          Paint()
            ..color = Colors.black38
            ..strokeWidth = 1,
        );
      }
    }

    // Draw hour hand
    double hourAngle =
        (dateTime.hour % 12 + dateTime.minute / 60.0) * 2 * pi / 12;
    drawHand(canvas, center, hourAngle, radius * 0.5, 4.0, Colors.black);

    // Draw minute hand
    double minuteAngle =
        (dateTime.minute + dateTime.second / 60.0) * 2 * pi / 60;
    drawHand(canvas, center, minuteAngle, radius * 0.7, 3.0, Colors.black87);

    // Draw second hand with smooth movement
    double secondAngle =
        (dateTime.second + dateTime.millisecond / 1000.0) * 2 * pi / 60;
    drawHand(canvas, center, secondAngle, radius * 0.8, 1.5, Colors.red);

    // Draw center circle
    canvas.drawCircle(center, 4, Paint()..color = Colors.black);
  }

  void drawHand(
    Canvas canvas,
    Offset center,
    double angle,
    double length,
    double strokeWidth,
    Color color,
  ) {
    canvas.drawLine(
      center,
      Offset(
        center.dx + cos(angle - pi / 2) * length,
        center.dy + sin(angle - pi / 2) * length,
      ),
      Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// class RadarAnimation extends StatefulWidget {
//   final double size;
//   final Color baseColor;
//   final Duration rotationDuration;
//
//   const RadarAnimation({
//     super.key,
//     this.size = 300,
//     this.baseColor = Colors.green,
//     this.rotationDuration = const Duration(seconds: 3),
//   });
//
//   @override
//   State<RadarAnimation> createState() => _RadarAnimationState();
// }
//
// class _RadarAnimationState extends State<RadarAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: widget.rotationDuration,
//     )..repeat();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.size,
//       height: widget.size,
//       child: AnimatedBuilder(
//         animation: _controller,
//         builder: (context, child) {
//           return CustomPaint(
//             painter: RadarPainter(
//               progress: _controller.value,
//               baseColor: widget.baseColor,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RadarPainter extends CustomPainter {
//   final double progress;
//   final Color baseColor;
//
//   RadarPainter({
//     required this.progress,
//     required this.baseColor,
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = min(size.width, size.height) / 2;
//
//     // Draw background circles
//     final circlePaint = Paint()
//       ..color = baseColor.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     for (int i = 1; i <= 4; i++) {
//       canvas.drawCircle(
//         center,
//         radius * (i / 4),
//         circlePaint,
//       );
//     }
//
//     // Draw crossing lines
//     canvas.drawLine(
//       Offset(center.dx - radius, center.dy),
//       Offset(center.dx + radius, center.dy),
//       circlePaint,
//     );
//     canvas.drawLine(
//       Offset(center.dx, center.dy - radius),
//       Offset(center.dx, center.dy + radius),
//       circlePaint,
//     );
//
//     // Draw rotating gradient sweep
//     final sweepGradient = SweepGradient(
//       center: Alignment.center,
//       colors: [
//         baseColor.withOpacity(0.0),
//         baseColor.withOpacity(0.3),
//         baseColor.withOpacity(0.0),
//       ],
//       stops: const [0.0, 0.5, 1.0],
//       transform: GradientRotation(2 * pi * progress),
//     );
//
//     final gradientPaint = Paint()
//       ..shader = sweepGradient.createShader(
//         Rect.fromCircle(center: center, radius: radius),
//       )
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(center, radius, gradientPaint);
//
//     // Draw rotating line (radar needle)
//     final needlePaint = Paint()
//       ..color = baseColor
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;
//
//     final angle = 2 * pi * progress - (pi / 2);
//     canvas.drawLine(
//       center,
//       Offset(
//         center.dx + cos(angle) * radius,
//         center.dy + sin(angle) * radius,
//       ),
//       needlePaint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(RadarPainter oldDelegate) =>
//       progress != oldDelegate.progress || baseColor != oldDelegate.baseColor;
// }
//
// // Usage Example
// class RadarExample extends StatelessWidget {
//   const RadarExample({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: RadarAnimation(
//           size: 300,
//           baseColor: Colors.green,
//           rotationDuration: Duration(seconds: 3),
//         ),
//       ),
//     );
//   }
// }

// class RadarAnimation extends StatefulWidget {
//   final double size;
//   final Color baseColor;
//   final Duration rotationDuration;
//
//   const RadarAnimation({
//     Key? key,
//     this.size = 300,
//     this.baseColor = Colors.green,
//     this.rotationDuration = const Duration(seconds: 3),
//   }) : super(key: key);
//
//   @override
//   State<RadarAnimation> createState() => _RadarAnimationState();
// }
//
// class _RadarAnimationState extends State<RadarAnimation> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.size,
//       height: widget.size,
//       child: Stack(
//         children: [
//           // Background circles and grid
//           CustomPaint(
//             size: Size(widget.size, widget.size),
//             painter: RadarBackgroundPainter(baseColor: widget.baseColor),
//           ),
//
//           // Rotating gradient overlay
//           Transform.rotate(
//             angle: -pi / 2, // Start from top
//             child: CustomPaint(
//               size: Size(widget.size, widget.size),
//               painter: RadarSweepPainter(baseColor: widget.baseColor),
//             ),
//           )
//               .animate(
//                 onPlay: (controller) => controller.repeat(),
//               )
//               .rotate(
//                 duration: widget.rotationDuration,
//                 curve: Curves.linear,
//               ),
//
//           // Rotating needle
//           CustomPaint(
//             size: Size(widget.size, widget.size),
//             painter: RadarNeedlePainter(baseColor: widget.baseColor),
//           )
//               .animate(
//                 onPlay: (controller) => controller.repeat(),
//               )
//               .rotate(
//                 duration: widget.rotationDuration,
//                 curve: Curves.linear,
//               ),
//
//           // Center dot
//           Center(
//             child: Container(
//               width: 6,
//               height: 6,
//               decoration: BoxDecoration(
//                 color: widget.baseColor,
//                 shape: BoxShape.circle,
//                 boxShadow: [
//                   BoxShadow(
//                     color: widget.baseColor.withOpacity(0.5),
//                     blurRadius: 4,
//                     spreadRadius: 2,
//                   ),
//                 ],
//               ),
//             )
//                 .animate(
//                   onPlay: (controller) => controller.repeat(),
//                 )
//                 .scale(
//                   duration: 1.seconds,
//                   begin: const Offset(0.8, 0.8),
//                   end: const Offset(1.2, 1.2),
//                   curve: Curves.easeInOut,
//                 ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class RadarBackgroundPainter extends CustomPainter {
//   final Color baseColor;
//
//   RadarBackgroundPainter({required this.baseColor});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = min(size.width, size.height) / 2;
//
//     final paint = Paint()
//       ..color = baseColor.withOpacity(0.3)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0;
//
//     // Draw circles
//     for (int i = 1; i <= 4; i++) {
//       canvas.drawCircle(center, radius * (i / 4), paint);
//     }
//
//     // Draw grid lines
//     canvas.drawLine(
//       Offset(center.dx - radius, center.dy),
//       Offset(center.dx + radius, center.dy),
//       paint,
//     );
//     canvas.drawLine(
//       Offset(center.dx, center.dy - radius),
//       Offset(center.dx, center.dy + radius),
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(RadarBackgroundPainter oldDelegate) =>
//       baseColor != oldDelegate.baseColor;
// }
//
// class RadarSweepPainter extends CustomPainter {
//   final Color baseColor;
//
//   RadarSweepPainter({required this.baseColor});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = min(size.width, size.height) / 2;
//
//     final gradient = SweepGradient(
//       colors: [
//         baseColor.withOpacity(0.0),
//         baseColor.withOpacity(0.3),
//         baseColor.withOpacity(0.0),
//       ],
//       stops: const [0.0, 0.5, 1.0],
//     );
//
//     final paint = Paint()
//       ..shader = gradient.createShader(
//         Rect.fromCircle(center: center, radius: radius),
//       )
//       ..style = PaintingStyle.fill;
//
//     canvas.drawCircle(center, radius, paint);
//   }
//
//   @override
//   bool shouldRepaint(RadarSweepPainter oldDelegate) =>
//       baseColor != oldDelegate.baseColor;
// }
//
// class RadarNeedlePainter extends CustomPainter {
//   final Color baseColor;
//
//   RadarNeedlePainter({required this.baseColor});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = Offset(size.width / 2, size.height / 2);
//     final radius = min(size.width, size.height) / 2;
//
//     final paint = Paint()
//       ..color = baseColor
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;
//
//     canvas.drawLine(
//       center,
//       Offset(center.dx, center.dy - radius),
//       paint,
//     );
//   }
//
//   @override
//   bool shouldRepaint(RadarNeedlePainter oldDelegate) =>
//       baseColor != oldDelegate.baseColor;
// }
//
// // Usage Example
// class RadarExample extends StatelessWidget {
//   const RadarExample({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: RadarAnimation(
//           size: 300,
//           baseColor: Colors.green,
//           rotationDuration: Duration(seconds: 3),
//         ),
//       ),
//     );
//   }
// }
// Usage Example

class RadarPoint {
  final Offset position; // Actual x,y coordinates on screen
  final Color color;

  const RadarPoint({required this.position, this.color = Colors.red});
}

class RadarAnimation extends StatefulWidget {
  final double size;
  final Color baseColor;
  final Duration rotationDuration;

  const RadarAnimation({
    super.key,
    this.size = 300,
    this.baseColor = Colors.green,
    this.rotationDuration = const Duration(seconds: 3),
  });

  @override
  State<RadarAnimation> createState() => _RadarAnimationState();
}

class _RadarAnimationState extends State<RadarAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<RadarPoint> points;
  final Map<RadarPoint, bool> _activePoints = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    )..repeat();

    // Generate random points inside the circle
    points = _generateRandomPoints(15); // Generate 15 random points
    _controller.addListener(_updateActivePoints);
  }

  List<RadarPoint> _generateRandomPoints(int count) {
    final random = math.Random();
    final points = <RadarPoint>[];
    final radius = widget.size / 2;
    final center = radius;

    for (int i = 0; i < count; i++) {
      // Generate random angle and distance
      double angle = random.nextDouble() * 2 * math.pi;
      double distance =
          (random.nextDouble() + 0.1) * (radius - 20); // Leave some padding

      // Convert polar to Cartesian coordinates
      double x = center + distance * math.cos(angle);
      double y = center + distance * math.sin(angle);

      points.add(RadarPoint(position: Offset(x, y), color: Colors.red));
    }
    return points;
  }

  void _updateActivePoints() {
    final currentAngle = (_controller.value * 2 * math.pi) - (math.pi / 2);
    const detectionAngle = math.pi / 12; // 15 degrees detection area
    final center = widget.size / 2;

    setState(() {
      for (var point in points) {
        // Calculate angle of the point relative to center
        double dx = point.position.dx - center;
        double dy = point.position.dy - center;
        double pointAngle = math.atan2(dy, dx);
        if (pointAngle < 0) pointAngle += 2 * math.pi;

        // Normalize currentAngle to 0-2π range
        double normalizedCurrentAngle = currentAngle;
        if (normalizedCurrentAngle < 0) normalizedCurrentAngle += 2 * math.pi;

        // Check if point is within detection range
        bool isActive =
            (pointAngle - normalizedCurrentAngle).abs() < detectionAngle ||
            (2 * math.pi - (pointAngle - normalizedCurrentAngle).abs()) <
                detectionAngle;
        _activePoints[point] = isActive;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        children: [
          // Background circles and grid
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: RadarBackgroundPainter(baseColor: widget.baseColor),
          ),

          // Points
          ...points.map((point) {
            final isActive = _activePoints[point] ?? false;

            return Positioned(
              left: point.position.dx - 4, // Adjust for point size
              top: point.position.dy - 4, // Adjust for point size
              child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: point.color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: point.color.withValues(alpha: 0.5),
                          blurRadius: isActive ? 8 : 4,
                          spreadRadius: isActive ? 4 : 2,
                        ),
                      ],
                    ),
                  )
                  .animate(target: isActive ? 1 : 0)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.5, 1.5),
                    duration: 200.ms,
                    curve: Curves.easeOutBack,
                  ),
            );
          }),

          // Rotating gradient overlay
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi - math.pi / 2,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: RadarSweepPainter(baseColor: widget.baseColor),
                ),
              );
            },
          ),

          // Rotating needle
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: RadarNeedlePainter(baseColor: widget.baseColor),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Painters remain the same as before
class RadarBackgroundPainter extends CustomPainter {
  final Color baseColor;

  RadarBackgroundPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paint =
        Paint()
          ..color = baseColor.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), paint);
    }

    canvas.drawLine(
      Offset(center.dx - radius, center.dy),
      Offset(center.dx + radius, center.dy),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy - radius),
      Offset(center.dx, center.dy + radius),
      paint,
    );
  }

  @override
  bool shouldRepaint(RadarBackgroundPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor;
}

class RadarSweepPainter extends CustomPainter {
  final Color baseColor;

  RadarSweepPainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final gradient = SweepGradient(
      colors: [
        baseColor.withValues(alpha: 0.4),
        baseColor.withValues(alpha: 0.2),
        baseColor.withValues(alpha: 0.0),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromCircle(center: center, radius: radius),
          )
          ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RadarSweepPainter oldDelegate) =>
      baseColor != oldDelegate.baseColor;
}

class RadarNeedlePainter extends CustomPainter {
  final Color baseColor;

  RadarNeedlePainter({required this.baseColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final paint =
        Paint()
          ..color = baseColor
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke;

    canvas.drawLine(center, Offset(center.dx, center.dy - radius), paint);
  }

  @override
  bool shouldRepaint(RadarNeedlePainter oldDelegate) =>
      baseColor != oldDelegate.baseColor;
}

class AnimationScreen extends StatelessWidget {
  const AnimationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Animations")),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: AnalogClock()),
            Expanded(
              child: RadarAnimation(
                size: 300,
                baseColor: Colors.green,
                rotationDuration: Duration(seconds: 3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
