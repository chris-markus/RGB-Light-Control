import 'package:flutter/material.dart';

import '../utils/color_picker.dart';

class ParameterView extends StatefulWidget{
  final Widget parent;
  ParameterView(this.parent);

  @override
  createState() => ParameterViewState();
}

class ParameterViewState extends State<ParameterView>{
  final _colorPicker = null;
  final _redSlider = null;
  final _blueSlider = null;
  final _greenSlider = null;
  final _intensitySlider = null;

  double _redSliderVal = 0.0;
  double _greenSliderVal = 0.0;
  double _blueSliderVal = 0.0;
  double _intensitySliderVal = 0.0;
  double _prevIntensityVal = 100.0;

  bool _intensitySwitch = false;

  Color _masterColor = Colors.red;

  List<int> _colorRGB = [0,0,0];

  ScrollController _scrollController = new ScrollController();

  @override
  Widget build(BuildContext context){
    return Container(
      child: ListView(
        controller: _scrollController,
        children: <Widget>[
          new Card(
            key: _colorPicker,
            child: new Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4.0, color: Theme.of(context).dividerColor),
                ),
              ),
              child: Column(
                children: <Widget>[
                  ColorPicker(
                    red: 0,
                    blue: 0,
                    green: 0,
                    onChanged: (_colorRGB){},
                  ),
                  /*new Padding(
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
                  ),*/
                  new Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text("Intensity: " + _intensitySliderVal.round().toString()),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                    child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Flexible(
                            child: Slider(
                                min: 0.0,
                                max: 100.0,
                                key: _intensitySlider,
                                value: _intensitySliderVal,
                                onChanged: (double value){
                                  sliderChanged(value, "b");
                                  setState(() {
                                    _intensitySliderVal = value;
                                  });
                                },
                                onChangeEnd: (double value){
                                  if(!_intensitySwitch){
                                    _intensitySwitch = true;
                                  }
                                  if(value == 0){
                                    _intensitySwitch = false;
                                  }
                                  else {
                                    _prevIntensityVal = value;
                                  }
                                  setState(() {});
                                },
                              ),
                          ),
                          Switch(
                            onChanged: (bool value){
                              if(value){
                                _intensitySliderVal = _prevIntensityVal;
                              }
                              else{
                                _intensitySliderVal = 0.0;
                              }
                              setState(() {
                                _intensitySwitch = !_intensitySwitch;
                              });
                            },
                            value: _intensitySwitch,
                          ),
                        ]
                      ),
                  )
                ],
              ),
            ),
          )
        ],
      )
    );
  }

  void sliderChanged(double value, slider){

  }

  void intensityToggled(bool val){

  }
}
