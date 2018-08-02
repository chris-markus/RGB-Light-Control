import 'dart:math';

import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker(
      {Key key, this.red, this.green, this.blue, @required this.onChanged})
      : super(key: key);

  final int red;
  final int blue;
  final int green;

  final _listenerKey = null;

  final ValueChanged<List<double>> onChanged;

  createState() => ColorPickerState();
}

double left = 0.0;
double top = 0.0;

double _pickerWidth = 0.0;

bool hasInit = false;

const double _topPickerPadding = 5.0;
const double _leftPickerPadding = 40.0;
const double _cursorDiameter = 12.0;

const double _COLORMAX = 255.0;

class ColorPickerState extends State<ColorPicker>{

  var _stackKey;

  void _renderCircle(BuildContext context, DragStartDetails start){
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(start.globalPosition);
    left = local.dx;
    top = local.dy;
  }

  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: _leftPickerPadding, vertical: _topPickerPadding),
          child: new GestureDetector(
            onPanStart: (DragStartDetails start) => _onDragStart(context, start),
            onPanUpdate: (DragUpdateDetails update) => _onDragUpdate(context, update),
            child: Stack(
              key: _stackKey,
                children: <Widget>[
                Image.asset(
                  "lib/assets/colorWheel.png",
                  fit: BoxFit.fitWidth,
                ), //etc,
                new LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    _pickerWidth = constraints.maxWidth;
                    if(!hasInit){
                      left = _pickerWidth/2 - _cursorDiameter/2;
                      top = _pickerWidth/2 - 3.0;
                      hasInit = true;
                    }
                    return new Transform(
                        transform: new Matrix4.translationValues(left, top, 0.0),
                        child: new Container(
                            width: _cursorDiameter,
                            height: _cursorDiameter,
                            decoration: new BoxDecoration(
                              color: Color(0xBE2196F3),
                              shape: BoxShape.circle,
                            )
                        )
                    );
                  },
                ),

              ],
            ),
          ),
    );
  }

 List<double> _insidePicker(double x, double y){
    double centerX = _pickerWidth/2 - _cursorDiameter / 2;
    double centerY = _pickerWidth/2 - _cursorDiameter / 2;
    double r = _pickerWidth/2;
    double dist = pow(pow(x - centerX, 2.0) + pow(y - centerY, 2), 0.5);
    double newX = x;
    double newY = y;
    if(dist > _pickerWidth/2) {
      newX = centerX + r * ((x - centerX) / dist);
      newY = centerY + r * ((y - centerY) / dist);
    }
    return [newX, newY];
  }

  List<double> _getRGB(double x, double y){
    double center = _pickerWidth / 2 - _cursorDiameter / 2;
    double dist = pow(pow(x - center, 2.0) + pow(y - center, 2), 0.5);
    if(dist == 0){
      return [_COLORMAX,_COLORMAX,_COLORMAX];
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
    else if(angle >= 240 && angle < 270){
      RGB = [X, 0.0, C];
    }
    else{
      RGB = [C, 0.0, X];
    }

    for(int i=0; i<RGB.length; i++){
      RGB[i] = (RGB[i] + m) * _COLORMAX;
    }

    return RGB;
  }

  List<double> _getHSV(){

  }

  _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(start.globalPosition);
    double tempX = local.dx - _leftPickerPadding - _cursorDiameter/2;
    double tempY = local.dy - _topPickerPadding - _cursorDiameter/2;
    var temp = _insidePicker(tempX, tempY);
    left = temp[0];
    top = temp[1];
    var rgb = _getRGB(left, top);
    widget.onChanged(rgb);
    setState(() {});
  }

  _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox getBox = context.findRenderObject();
    var local = getBox.globalToLocal(update.globalPosition);
    double tempX = local.dx - _leftPickerPadding - _cursorDiameter/2;
    double tempY = local.dy - _topPickerPadding - _cursorDiameter/2;
    var temp = _insidePicker(tempX, tempY);
    left = temp[0];
    top = temp[1];
    var rgb = _getRGB(left, top);
    widget.onChanged(rgb);
    setState(() {});
  }

}

class HSColor {
  HSColor(this.hue, this.sat);
  final double hue;
  final double sat;
}

