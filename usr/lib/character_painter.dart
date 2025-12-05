import 'package:flutter/material.dart';
import 'dart:math' as math;

class CharacterPainter extends CustomPainter {
  final double happiness;
  final double energy;
  final bool isSleeping;

  CharacterPainter({
    required this.happiness,
    required this.energy,
    required this.isSleeping,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFCCAA) // Skin tone
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // --- BODY (The "Prepucio" shape - slightly elongated blob) ---
    // Using a path to make it look organic/blobby
    final path = Path();
    path.moveTo(w * 0.2, h * 0.9); // Bottom left
    
    // Left side curve
    path.quadraticBezierTo(w * 0.05, h * 0.5, w * 0.2, h * 0.2);
    
    // Top "hood" curve (slightly wider/bulbous at top)
    path.quadraticBezierTo(w * 0.5, h * 0.0, w * 0.8, h * 0.2);
    
    // Right side curve
    path.quadraticBezierTo(w * 0.95, h * 0.5, w * 0.8, h * 0.9);
    
    // Bottom curve
    path.quadraticBezierTo(w * 0.5, h * 1.0, w * 0.2, h * 0.9);
    
    path.close();
    
    // Draw shadow
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.95), width: w * 0.8, height: h * 0.1),
      Paint()..color = Colors.black26,
    );

    // Draw Body
    canvas.drawPath(path, paint);
    
    // Outline
    final outlinePaint = Paint()
      ..color = Colors.brown.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawPath(path, outlinePaint);

    // --- BIKINI (The requested accessory) ---
    final bikiniPaint = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.fill;

    // Bikini Top (Two triangles/circles)
    canvas.drawCircle(Offset(w * 0.35, h * 0.55), w * 0.12, bikiniPaint);
    canvas.drawCircle(Offset(w * 0.65, h * 0.55), w * 0.12, bikiniPaint);
    
    // Bikini Strings
    final stringPaint = Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    
    // Top strings
    canvas.drawLine(Offset(w * 0.35, h * 0.55), Offset(w * 0.5, h * 0.3), stringPaint);
    canvas.drawLine(Offset(w * 0.65, h * 0.55), Offset(w * 0.5, h * 0.3), stringPaint);
    
    // Bikini Bottom
    final bottomPath = Path();
    bottomPath.moveTo(w * 0.25, h * 0.75);
    bottomPath.quadraticBezierTo(w * 0.5, h * 0.9, w * 0.75, h * 0.75); // Top edge of bottom
    bottomPath.lineTo(w * 0.5, h * 0.92); // Point down
    bottomPath.close();
    canvas.drawPath(bottomPath, bikiniPaint);


    // --- FACE ---
    _drawFace(canvas, size);
  }

  void _drawFace(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Eyes
    if (isSleeping) {
      // Closed eyes (lines)
      final eyePaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;
      
      canvas.drawLine(Offset(w * 0.35, h * 0.35), Offset(w * 0.45, h * 0.35), eyePaint);
      canvas.drawLine(Offset(w * 0.55, h * 0.35), Offset(w * 0.65, h * 0.35), eyePaint);
    } else {
      // Open eyes (white circles with pupils)
      final eyeWhitePaint = Paint()..color = Colors.white;
      final pupilPaint = Paint()..color = Colors.black;

      // Left Eye
      canvas.drawCircle(Offset(w * 0.4, h * 0.35), w * 0.08, eyeWhitePaint);
      canvas.drawCircle(Offset(w * 0.4, h * 0.35), w * 0.03, pupilPaint);

      // Right Eye
      canvas.drawCircle(Offset(w * 0.6, h * 0.35), w * 0.08, eyeWhitePaint);
      canvas.drawCircle(Offset(w * 0.6, h * 0.35), w * 0.03, pupilPaint);
    }

    // Mouth
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final mouthPath = Path();
    if (happiness > 0.5 && !isSleeping) {
      // Smile
      mouthPath.moveTo(w * 0.4, h * 0.45);
      mouthPath.quadraticBezierTo(w * 0.5, h * 0.55, w * 0.6, h * 0.45);
    } else if (happiness <= 0.5 && !isSleeping) {
      // Sad
      mouthPath.moveTo(w * 0.4, h * 0.5);
      mouthPath.quadraticBezierTo(w * 0.5, h * 0.45, w * 0.6, h * 0.5);
    } else {
      // Neutral/Sleeping (small circle or line)
      mouthPath.addOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.48), width: w * 0.05, height: w * 0.05));
    }
    
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CharacterPainter oldDelegate) {
    return oldDelegate.happiness != happiness ||
           oldDelegate.energy != energy ||
           oldDelegate.isSleeping != isSleeping;
  }
}
