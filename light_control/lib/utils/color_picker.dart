import 'dart:math';

import 'package:flutter/material.dart';
import 'package:light_control/uipartials/color_circle.dart';
import 'package:light_control/utils/LColor.dart';


double left = 0.0;
double top = 0.0;

double _pickerWidth = 0.0;

const double _topPickerPadding = 5.0;
const double _leftPickerPadding = 3.0;
const double _cursorDiameter = 12.0;

class ColorPicker extends StatefulWidget {
  ColorPicker({Key key,
    @required this.color,
    @required this.onChanged,
    this.onPointerDown,
    this.onPointerUp})
      : super(key: key);

  final LColor color;

  final onPointerDown;
  final onPointerUp;

  final ValueChanged<LColor> onChanged;

  createState() {
    return ColorPickerState();
  }
}

class ColorPickerState extends State<ColorPicker>{

  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: _leftPickerPadding, vertical: _topPickerPadding),
          child: new Listener(
            onPointerDown: (PointerDownEvent start) {
              if(widget.onPointerDown != null) {
                widget.onPointerDown();
              }
              _onDragUpdate(context, start);
            },
            onPointerMove: (PointerMoveEvent update){
              if(widget.onPointerDown != null) {
                widget.onPointerDown();
              }
              _onDragUpdate(context, update);
            },
            onPointerCancel: (PointerEvent e){
              if(widget.onPointerUp != null) {
                widget.onPointerUp();
              }
            },
            onPointerUp: (PointerEvent e){
              if(widget.onPointerUp != null) {
                widget.onPointerUp();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints){
                _pickerWidth = constraints.maxWidth;
                var tempPos = getPos(widget.color);
                left = tempPos[0];
                top = tempPos[1];
                return new CustomPaint(
                  painter: new CustomPickerPainter(),
                  child: Stack(
                    key: widget.key,
                    children: <Widget>[
                      Image.asset(
                        "lib/assets/colorWheel.png",
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        bottom: 0.0,
                        child: new ColorCircle(
                          color: widget.color,
                        ),
                      ),
                      new CustomPaint(
                          painter: new CustomPointerPainter(
                              xPos: left,
                              yPos: top,
                              diameter: _cursorDiameter
                          )
                      )
                    ],
                  ),
                );
              }
              )
            ),
          );
  }

 List<double> _insidePicker(double x, double y){
    double centerX = _pickerWidth/2 - _cursorDiameter / 2;
    double centerY = _pickerWidth/2 - _cursorDiameter / 2;
    double r = _pickerWidth/2;
    double dist = pow(pow(x - centerX, 2.0) + pow(y - centerY, 2), 0.5);
    if(dist == 0){
      return [0.0,0.0];
    }
    double newX = x;
    double newY = y;
    if(dist > _pickerWidth/2) {
      newX = centerX + r * ((x - centerX) / dist);
      newY = centerY + r * ((y - centerY) / dist);
    }
    return [newX, newY];
  }

  LColor _getRGB(double x, double y){
    double center = _pickerWidth / 2 - _cursorDiameter / 2;
    double dist = pow(pow(x - center, 2.0) + pow(y - center, 2), 0.5);
    if(dist <= 0){
      return LColors.white;
    }
    double angle = (atan2((y - center),(x - center)) + pi - pi/2)%(2 * pi);

    angle = angle*180/pi;

    double C = dist / (center + _cursorDiameter/2);

    double L = 1 - 0.5*(dist / (center + _cursorDiameter/2));

    double temp = (angle / 60) % 2 - 1;
    temp = temp.abs();

    double X = C * (1 - temp);

    double m = L - C/2;

    List<double> RGB = [0.0,0.0,0.0];

    if(angle >= 0 && angle < 60){
      RGB = [C, X, 0.0];
    }
    else if(angle >= 60 && angle < 120){
      RGB = [X, C, 0.0];
    }
    else if(angle >= 120 && angle < 180){
      RGB = [0.0, C, X];
    }
    else if(angle >= 180 && angle < 240){
      RGB = [0.0, X, C];
    }
    else if(angle >= 240 && angle < 300){
      RGB = [X, 0.0, C];
    }
    else{
      RGB = [C, 0.0, X];
    }

    for(int i=0; i<RGB.length; i++){
      RGB[i] = (RGB[i] + m) * LColor.COLORMAX;
    }

    return new LColor(RGB[0].round(), RGB[1].round(), RGB[2].round());
  }

  List<double> getPos(LColor c){

    double R = c.red / LColor.COLORMAX;
    double G = c.green / LColor.COLORMAX;
    double B = c.blue / LColor.COLORMAX;

    double maxRGB = max(max(R, G), B);
    double minRGB = min(min(R, G), B);
    double h;
    double s;

    if (maxRGB == minRGB) {
      h = 0.0;
      s = 0.0;
    }
    else {
      double d = maxRGB - minRGB;
      s = d/maxRGB;

      if(R == maxRGB) {
        h = ((G - B) / d)%6;
      }
      if(G == maxRGB) {
        h = (B - R) / d + 2;
      }
      if(B == maxRGB) {
        h = (R - G) / d + 4;
      }
      h /= 6;
    }

    double centerX = _pickerWidth/2 - _cursorDiameter / 2;
    double centerY = _pickerWidth/2 - _cursorDiameter / 2;

    double angle = (h*2*pi - pi/2)%(2*pi);

    double d = s*(_pickerWidth/2);

    double x = d*cos(angle);
    double y = d*sin(angle);

    x = x + centerX;
    y = y + centerY;

    return [x, y];
  }

  _onDragUpdate(BuildContext context, PointerEvent update) {
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(update.position);
    double tempX = local.dx - _leftPickerPadding - _cursorDiameter/2;
    double tempY = local.dy - _topPickerPadding - _cursorDiameter/2;
    _locationChange(tempX, tempY);
  }

  _locationChange(double x, double y){
    var temp = _insidePicker(x, y);
    left = temp[0];
    top = temp[1];
    var rgb = _getRGB(temp[0], temp[1]);
    widget.onChanged(rgb);
  }

}

class CustomPointerPainter extends CustomPainter{

  final Paint pointerPaint;
  double xPos;
  double yPos;
  final double diameter;
  final Color pointerColor;

  CustomPointerPainter({
    this.xPos,
    this.yPos,
    @required this.diameter,
    this.pointerColor = Colors.blue
  }) : pointerPaint = new Paint()
    ..color = pointerColor
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(Offset(xPos +diameter/2,yPos + diameter/2), diameter/2, pointerPaint);
  }

  @override
  bool shouldRepaint(CustomPointerPainter oldDelegate) {
    return oldDelegate.xPos != xPos || oldDelegate.yPos != yPos;
  }

}

class CustomPickerPainter extends CustomPainter{

  final Paint pickerPaint;
  final bool shadow;
  final Color borderColor;
  final Path circle = new Path();

  CustomPickerPainter({
    this.shadow,
    this.borderColor = Colors.white,
  }) : pickerPaint = new Paint()
    ..color = borderColor
    ..strokeWidth = 3.0
    ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = new Offset(size.width/2, size.width/2);
    circle.addOval(new Rect.fromCircle(center: center, radius: size.width/2));
    canvas.drawShadow(circle, Colors.black45, 3.0, true);
    canvas.drawCircle(center, size.width/2, pickerPaint);
  }

  @override
  bool shouldRepaint(CustomPickerPainter oldDelegate) {
    return borderColor != oldDelegate.borderColor || shadow != oldDelegate.shadow;
  }


}


