import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  ColorPicker(
      {Key key, this.red, this.green, this.blue, @required this.onChanged})
      : super(key: key);

  final int red;
  final int blue;
  final int green;

  final _listenerKey = null;

  final ValueChanged<List<int>> onChanged;

  createState() => ColorPickerState();
}

double left = 0.0;
double top = 0.0;

class ColorPickerState extends State<ColorPicker>{

  var _stackKey;

  void _renderCircle(Offset e){
    print(e.dx);
    left = e.dx - 55;
    top  = e.dy - 100;
    setState(() {
    });
  }

  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5.0),
          child: new Listener(
            onPointerDown: (e){
              _renderCircle(e.position);
            },
            onPointerMove: (e){
              _renderCircle(e.position);
            },
            onPointerUp: (e){
              _renderCircle(e.position);
            },
            child: Stack(
              key: _stackKey,
                children: <Widget>[
                Image.asset(
                  "lib/assets/colorWheel.png",
                  fit: BoxFit.fitWidth,
                ), //etc,
                Positioned(
                  left: left,
                  top: top,
                  child: Icon(
                    Icons.blur_circular,
                    color: Colors.grey
                  ),
                ),
              ],
            ),
          ),
    );
  }
}