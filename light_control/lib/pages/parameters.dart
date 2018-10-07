import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:light_control/utils/LColor.dart';
import 'package:light_control/utils/preset.dart';

import '../utils/color_picker.dart';
import '../utils/storage_interface.dart';

LColor color = LColors.white;

List<LColor> presetColors = [LColors.white, LColors.white, LColors.white, LColors.white, LColors.red, LColors.green, LColors.blue, LColors.white];
List<bool> presetActive = [false, false, false, false, false, false, false, false];
List<String> presetNames = ["1","2","3","4"];

double _intensitySliderVal = 0.0;
double _prevIntensityVal = LColor.COLORMAX.toDouble();

bool _intensitySwitch = false;

class ParameterView extends StatefulWidget{
  final Widget parent;
  final onParameterChanged;
  final GlobalKey key;

  ParameterView(
    this.parent,
    {
    this.onParameterChanged,
    this.key,
  }):super(key: key);

  @override
  createState() => ParameterViewState();
}

ScrollPhysics noScroll = new NeverScrollableScrollPhysics();
ScrollPhysics scrollPhys = new ScrollPhysics();


class CustomScrollPhysics extends ScrollPhysics{

  bool scroll = true;

  void setScroll (bool inpt){
    scroll = inpt;
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    // TODO: implement applyPhysicsToUserOffset
      offset = 0.0;
    return super.applyPhysicsToUserOffset(position, offset);
  }
}

class ParameterViewState extends State<ParameterView>{
  final _colorPicker = null;
  final _intensitySlider = null;

  bool activeOne = false;

  Color inactiveColor = Colors.grey;

  ScrollPhysics _scrollPhysics = ScrollPhysics();

  bool scroll = true;

  @override
  void initState() {

    if(presetColors !=null && presetColors.length == 0){
      for(int i=0; i<8; i++){
        presetColors.add(LColors.white);
      }
    }

    GlobalDataHandler.retrieveData("presets", (bool success, String data){
      if(data == null){
        return;
      }
      List<String> parsedData = data.split(";");
      for(int i=0; i<parsedData.length; i++){
        String item = parsedData[i].split(":")[1];
        String name = parsedData[i].split(":")[0];
        if(item != null){
          int r = int.parse(item.substring(0,2), radix: 16);
          int g = int.parse(item.substring(2,4), radix: 16);
          int b = int.parse(item.substring(4), radix: 16);
          print(item.substring(0,1) + ", " + item.substring(2,3) + ", " + item.substring(4));
          print(r.toString() + ", " + g.toString() + ", " + b.toString());
          presetColors[i] = LColor(r,g,b);
          presetNames[i] = name;
        }
      }
      checkPresets(color);
      redraw();
    });

    super.initState();
    checkPresets(color);
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: ListView(
        //controller: _scrollController,
        physics: scroll? new ScrollPhysics(parent: _scrollPhysics) : new NeverScrollableScrollPhysics(parent: _scrollPhysics),
        children: <Widget>[
          new Card(
            key: _colorPicker,
            child: new Container(
              child: Column(
                children: <Widget>[
                  ColorPicker(
                    color: color,
                    onPointerDown: (){
                      //print("down");
                      //_scrollPhysics.setScroll(false);
                      setState(() {
                        scroll = false;
                      });
                    },
                    onPointerUp: (){
                      //_scrollPhysics.setScroll(false);
                      setState(() {
                        scroll = true;
                      });
                    },
                    onChanged: (_colorRGB){
                      checkPresets(_colorRGB);
                      color = _colorRGB;
                      dataChanged();
                      setState(() {
                      });
                    },
                  ),
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
                                max: LColor.COLORMAX.toDouble(),
                                key: _intensitySlider,
                                value: _intensitySliderVal,
                                onChanged: (double value){
                                  _intensitySliderVal = value;
                                  setState((){});
                                  dataChanged();
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
                                  setState((){});
                                  dataChanged();
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
                              _intensitySwitch = !_intensitySwitch;
                              setState(() {
                              });
                              dataChanged();
                            },
                            value: _intensitySwitch,
                          ),
                        ]
                      ),
                  )
                ],
              ),
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Preset(
                      presetName: presetNames[0],
                      color: presetColors[0],
                      activated: presetActive[0],
                      onDoubleTap: () => presetDoubleTap(0),
                      onTap: (LColor rgb) => presetTapped(rgb),
                      onLongPress: () => presetLongPress(0),
                    ),
                    new Preset(
                      presetName: presetNames[1],
                      color: presetColors[1],
                      activated: presetActive[1],
                      onDoubleTap: () => presetDoubleTap(1),
                      onTap: (LColor rgb) => presetTapped(rgb),
                      onLongPress: () => presetLongPress(1),
                    ),
                    new Preset(
                      presetName: presetNames[2],
                      color: presetColors[2],
                      activated: presetActive[2],
                      onDoubleTap: () => presetDoubleTap(2),
                      onTap: (LColor rgb) => presetTapped(rgb),
                      onLongPress: () => presetLongPress(2),
                    ),
                    new Preset(
                      presetName: presetNames[3],
                      color: presetColors[3],
                      activated: presetActive[3],
                      onDoubleTap: () => presetDoubleTap(3),
                      onTap: (LColor rgb) => presetTapped(rgb),
                      onLongPress: () => presetLongPress(3),
                    )
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    new Preset(
                      presetName: "Red",
                      color: LColors.red,
                      activated: presetActive[4],
                      onTap: (LColor rgb) => presetTapped(rgb),
                    ),
                    new Preset(
                      presetName: "Green",
                      color: LColors.green,
                      activated: presetActive[5],
                      onTap: (LColor rgb) => presetTapped(rgb),
                    ),
                    new Preset(
                      presetName: "Blue",
                      color: LColors.blue,
                      activated: presetActive[6],
                      onTap: (LColor rgb) => presetTapped(rgb),
                    ),
                    new Preset(
                      presetName: "White",
                      color: LColors.white,
                      activated: presetActive[7],
                      onTap: (LColor rgb) => presetTapped(rgb),
                    )
                  ],
                ),
              ],
            )
          )
        ],
      )
    );
  }

  void redraw(){
    setState(() {
    });
  }

  void presetTapped(LColor rgb) {
    color = rgb;
    checkPresets(rgb);
    setState(() {});
    dataChanged();
  }

  void presetLongPress(int prst){
    presetColors[prst] = color;
    checkPresets(color);
    savePresets();
    setState(() {});
  }

  void savePresets(){
    String presetString = "";
    for(int i=0; i<presetNames.length; i++){
      presetString += presetNames[i] + ":";
      presetString += presetColors[i].toHexColor(255.0);
      if(i != presetNames.length - 1){
        presetString += ";";
      }
    }
    print(presetString);
    GlobalDataHandler.storeData("presets", presetString,(bool b){print("wrote");});
  }

  void presetDoubleTap(int prst){
    if(prst > presetNames.length) return;
    String newName;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return new AlertDialog(
              title: Text("Rename \"" + presetNames[prst] + "\""),
              content: new TextField(
                decoration: new InputDecoration(
                    labelText: "New Name"
                ),
                onChanged: (String text){
                  newName = text;
                },
              ),
              actions: [
                new FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: new Text("Cancel")
                ),
                new FlatButton(
                  onPressed: (){
                    presetNames[prst] = newName;
                    setState(() {
                    });
                    Navigator.pop(context);
                  },
                  child: new Text("Save"),
                )
              ]
          );
        }
    );
  }

  void checkPresets(LColor rgb){
    for(int i=0; i<8; i++){
      if(rgb != presetColors[i]){
        presetActive[i] = false;
      }
      else{
        presetActive[i] = true;
      }
    }
  }

  void dataChanged(){
    //widget.onParameterChanged("000" + color.toHexColor(_intensitySliderVal));
    widget.onParameterChanged("#" + color.toExpHexColor(_intensitySliderVal));
  }
}





class IntensitySwitch extends StatefulWidget {

  final int intensity;
  final bool on;
  final Color activeColor;
  final Color inactiveColor;
  final onTap;

  final int minDragDist;

  IntensitySwitch({
    @required this.intensity,
    @required this.on,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.onTap,
    this.minDragDist = 200
  });

  @override
  State<StatefulWidget> createState() => IntensityWidgetState();

  void _onDragStart(DragStartDetails d){

  }
}

class IntensityWidgetState extends State<IntensitySwitch>{
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      flex: 1,
      child: GestureDetector(
        onVerticalDragStart: (DragStartDetails d) =>widget._onDragStart(d),
        child: new Card(
          elevation: 3.0,
          child: Container(
            child: ClipRRect(
              borderRadius: new BorderRadius.all(Radius.circular(4.0)),
              child: new CustomPaint(
                  painter: new CustomPresetPainter(
                      presetColor: color.toDartColor(),
                      indicatorColor: (widget.on? widget.activeColor : widget.inactiveColor)
                  ),
                  child: new InkWell(
                    child: new Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                          child: new Text(widget.intensity.toString()),
                        )
                    ),
                    onTap: (){
                      if(widget.onTap != null) {
                        widget.onTap(widget.intensity);
                      }
                    },
                    /*onDoubleTap: (){
                                if(onDoubleTap !=null){
                                  onDoubleTap();
                                }
                            },
                    onLongPress: (){
                      if(onLongPress != null) {
                        onLongPress();
                      }
                    },*/
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}