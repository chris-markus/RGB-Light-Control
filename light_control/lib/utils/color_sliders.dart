import 'package:flutter/material.dart';

class ColorSliderView extends StatefulWidget {

  createState() => ColorSliderViewState();
}

class ColorSliderViewState extends State<ColorSliderView> {

  final _redSlider = null;
  final _blueSlider = null;
  final _greenSlider = null;

  double _redSliderVal = 0.0;
  double _greenSliderVal = 0.0;
  double _blueSliderVal = 0.0;

  @override
  Widget build(BuildContext context){
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text("Red: " + _redSliderVal.round().toString()),
        ),
        new Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Slider(
            min: 0.0,
            max: 255.0,
            key: _redSlider,
            value: _redSliderVal,
            onChanged: (double value){
              sliderChanged(value, "r");
              setState(() {
                _redSliderVal = value;
              });
            },
          ),
        ),
        Text("Green: " + _greenSliderVal.round().toString()),
        new Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Slider(
            min: 0.0,
            max: 255.0,
            key: _greenSlider,
            value: _greenSliderVal,
            onChanged: (double value){
              sliderChanged(value, "g");
              setState(() {
                _greenSliderVal = value;
              });
            },
          ),
        ),
        Text("Blue: " + _blueSliderVal.round().toString()),
        new Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Slider(
            min: 0.0,
            max: 255.0,
            key: _blueSlider,
            value: _blueSliderVal,
            onChanged: (double value){
              sliderChanged(value, "b");
              setState(() {
                _blueSliderVal = value;
              });
            },
          ),
        ),
      ],
    );
  }

  void sliderChanged(double value, slider){

  }
}