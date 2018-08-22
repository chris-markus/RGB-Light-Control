import 'package:flutter/material.dart';
import 'package:light_control/utils/LColor.dart';

class ColorCircle extends StatelessWidget{
  @override

  final LColor color;
  final double circleSize;

  Widget build(BuildContext context) {
    return Container(
      decoration: new ShapeDecoration(
          shape: CircleBorder(

          ),
          shadows: [
            BoxShadow(
                color: Colors.black,
                offset: new Offset(20.0, 20.0),
                blurRadius: 10.0
            )
          ]
      ),
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
  final double circleSize;

  ColorCirclePainter({
    @required this.color,
    this.circleSize = 20.0
  }) : circlePaint = new Paint()
    ..color = color.toDartColor()
    ..style = PaintingStyle.fill;

  void paint(Canvas canvas, Size size) {

    Offset center = new Offset(circleSize/2, -1*circleSize/2);
    canvas.drawCircle(center, circleSize, circlePaint);
  }

  @override
  bool shouldRepaint(ColorCirclePainter oldDelegate) {
    return oldDelegate.color != color;
  }

}