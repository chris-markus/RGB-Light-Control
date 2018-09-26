import 'package:flutter/material.dart';
import 'package:light_control/utils/LColor.dart';

class ColorCircle extends StatelessWidget{
  @override

  final LColor color;
  final double circleSize;

  Widget build(BuildContext context) {
    return Container(
      child: new CustomPaint(
          painter: new ColorCirclePainter(
              color: this.color
          )
      ),
    );
  }

  ColorCircle({
    this.color = LColors.white,
    this.circleSize = 20.0,
  });
}

class ColorCirclePainter extends CustomPainter{
  @override

  final LColor color;
  final Paint circlePaint;
  final Paint strokePaint;
  final double circleSize;
  final Path circle = new Path();

  ColorCirclePainter({
    @required this.color,
    this.circleSize = 20.0
  }) : circlePaint = new Paint()
    ..color = color.toDartColor()
    ..style = PaintingStyle.fill,
    strokePaint = new Paint()
    ..color = Colors.white
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke;

  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(circleSize/2, -1*circleSize/2);
    circle.addOval(new Rect.fromCircle(center: center, radius: circleSize));
    canvas.drawShadow(circle, Colors.black45, 3.0, true);
    canvas.drawCircle(center, circleSize, circlePaint);
    canvas.drawCircle(center, circleSize, strokePaint);
  }

  @override
  bool shouldRepaint(ColorCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }

}