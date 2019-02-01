import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_control/utils/LColor.dart';

class IntensitySlider extends StatefulWidget {

  final double intensity;
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final onDrag;
  final multiplier;

  final int minDragDist;

  IntensitySlider({
    @required this.intensity,
    @required this.onDrag,
    @required this.width,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.minDragDist = 200,
    this.multiplier = 1.5,
  });

  @override
  State<StatefulWidget> createState() => IntensityWidgetState();

}

class IntensityWidgetState extends State<IntensitySlider>{
  @override
  double lastDragStart = 0.0;
  double lastIntensity = 0;
  static double height = 100;

  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails d) => _dragStart(d.globalPosition),
      onVerticalDragUpdate: (DragUpdateDetails d) => _drag(d.globalPosition),
      child: new Card(
        elevation: 3.0,
        child: Container(
          width: widget.width,
          child: ClipRRect(
            borderRadius: new BorderRadius.all(Radius.circular(4.0)),
            child: new CustomPaint(
                painter: new CustomIntensityPainter(
                    indicatorColor: widget.activeColor,
                    val: widget.intensity/LColor.COLORMAX,
                    setHeight: (newHeight){
                      height = newHeight;
                    }
                ),
                child: new Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 15.0),
                      child: new Text(
                          ((widget.intensity/LColor.COLORMAX) * 100).round().toString() + "%",
                          style: TextStyle(color: Colors.black54),
                      ),
                    )
                )
            ),
          ),
        ),
      ),
    );
  }

  void _drag(Offset pos) {
    //print(lastDragStart.toString() + " " + pos.dy.toString());
    double newIntensity = lastIntensity + (((lastDragStart - pos.dy))/height) *LColor.COLORMAX;
    if(newIntensity > LColor.COLORMAX)
      newIntensity = LColor.COLORMAX.toDouble();
    else if(newIntensity < 0){
      newIntensity = 0;
    }
    widget.onDrag(newIntensity);
  }

  void _dragStart(Offset pos) {
    lastDragStart = pos.dy;
    lastIntensity = widget.intensity;
  }
}

/*
class IntensityWidgetState extends State<IntensitySlider>{
  @override
  double lastDragStart = 0.0;
  double lastIntensity = 0;

  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (DragStartDetails d) => _dragStart(d.globalPosition),
      onVerticalDragUpdate: (DragUpdateDetails d) => _drag(d.globalPosition),
      child: new Card(
        elevation: 3.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              width: widget.width,
              child: ClipRRect(
                borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                child: new CustomPaint(
                    painter: new CustomIntensityPainter(
                        indicatorColor: (widget.on ? widget.activeColor : widget
                            .inactiveColor)
                    ),
                    child: new Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 15.0),
                          child: new Text(((widget.intensity/LColor.COLORMAX) * 100).round().toString() + "%"),
                        )
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _drag(Offset pos) {
    print(lastDragStart.toString() + " " + pos.dy.toString());
    double newIntensity = lastIntensity + (lastDragStart - pos.dy) * widget.multiplier;
    if(newIntensity > LColor.COLORMAX)
      newIntensity = LColor.COLORMAX.toDouble();
    else if(newIntensity < 0){
      newIntensity = 0;
    }
    widget.onDrag(newIntensity);
  }

  void _dragStart(Offset pos) {
    lastDragStart = pos.dy;
    lastIntensity = widget.intensity;
  }
}
 */

class CustomIntensityPainter extends CustomPainter{
  Color indicatorColor;
  final Paint indicatorPaint;
  final Paint levelPaint;
  final double val;
  final double indicatorHeight;
  final setHeight;

  CustomIntensityPainter({
    @required this.indicatorColor,
    @required this.val,
    this.setHeight,
    this.indicatorHeight = 5.0,
  }) : indicatorPaint = new Paint()
    ..color = indicatorColor
    ..style = PaintingStyle.fill,
    levelPaint = new Paint()
    ..color = indicatorColor.withAlpha(30)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    setHeight(size.height);
    double indicatorY = (1-val) * (size.height - indicatorHeight);
    if(indicatorY > size.height - indicatorHeight)
      indicatorY = size.height - indicatorHeight;
    else if(indicatorY < 0)
      indicatorY = 0;
    Offset indicatorOffset = Offset(0.0,indicatorY);
    Rect indicator = indicatorOffset & Size(size.width, indicatorHeight);
    canvas.drawRect(indicator, indicatorPaint);
    Rect fill = indicatorOffset & Size(size.width, size.height);
    canvas.drawRect(fill, levelPaint);
  }

  /*
  void paint(Canvas canvas, Size size) {
    Offset circleCenter = Offset(0.0,size.height);
    Rect bottomRect = Offset(0.0, 0.0) & const Size(double.infinity, 5.0);
    circle.addOval(new Rect.fromCircle(center: Offset(3.0,size.height), radius: size.height/2.0));
    canvas.drawShadow(circle, Colors.black45, 5.0, true);
    canvas.drawCircle(circleCenter, size.height/2.0, presetPaint);
    canvas.drawRect(bottomRect, indicatorPaint);
  }
   */

  @override
  bool shouldRepaint(CustomIntensityPainter oldDelegate) {
    return oldDelegate.indicatorColor != indicatorColor;
  }
}