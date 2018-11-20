import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:light_control/utils/LColor.dart';
import 'package:light_control/utils/preset.dart';

import '../utils/color_picker.dart';
import '../utils/storage_interface.dart';

LColor color = LColors.white;

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

/*
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
}*/

class CustomScrollPhysics extends ScrollPhysics{

}

class ParameterViewState extends State<ParameterView>{
  final GlobalKey _colorPicker = null;
  final GlobalKey _intensitySlider = null;

  int numPresetRows = 4;
  int numPresets = 4;

  bool activeOne = false;

  Color inactiveColor = Colors.grey;

  ScrollPhysics _scrollPhysics = CustomScrollPhysics();

  bool scroll = true;


  List<PresetData> predefinedPresetData = [
    PresetData(name: "White", color: LColors.white),
    PresetData(name: "Red", color: LColors.red),
    PresetData(name: "Green", color: LColors.green),
    PresetData(name: "Blue", color: LColors.blue)
  ];

  List<PresetData> presetData = [];

  @override
  void initState() {

    for(int i=0; i<numPresets; i++){
      presetData.add(PresetData(name: i.toString()));
    }

    presetData = presetData + predefinedPresetData;

    GlobalDataHandler.retrieveData("presets", (bool success, String data){
      if(data == null){
        return;
      }
      List<String> parsedData = data.split(", ");
      for(int i=0; i<parsedData.length; i++){
        String item = parsedData[i].split(":")[1];
        String name = parsedData[i].split(":")[0];
        if(item != null){
          int r = int.parse(item.substring(0,2), radix: 16);
          int g = int.parse(item.substring(2,4), radix: 16);
          int b = int.parse(item.substring(4), radix: 16);
          print(item.substring(0,1) + ", " + item.substring(2,3) + ", " + item.substring(4));
          print(r.toString() + ", " + g.toString() + ", " + b.toString());
          presetData[i].color = LColor(r,g,b);
          presetData[i].name = name;
        }
      }
      checkPresets(color);
      redraw();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
      child: ListView(
        //controller: _scrollController,
        physics: scroll? new ScrollPhysics(parent: _scrollPhysics) : new NeverScrollableScrollPhysics(parent: _scrollPhysics),
        //physics: _scrollPhysics,
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
                      ScrollMetrics p = new FixedScrollMetrics(minScrollExtent: 0.0, maxScrollExtent: 0.0, pixels: 0.0, viewportDimension: 0.0, axisDirection: AxisDirection.down);
                      _scrollPhysics.shouldAcceptUserOffset(p);
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
            child: Builder(
              builder: (BuildContext context) {
                List<Widget> presets = [];
                for(int i = 0; i<presetData.length/numPresetRows; i++){
                  List<Widget> thisRow = [];
                  for(int j = 0; j<numPresetRows; j++){
                    int thisNum = i*numPresetRows + j;
                    if(thisNum >= presetData.length) {
                      break;
                    }
                    thisRow.add(new Preset(
                      presetName: presetData[thisNum].name,
                      color: presetData[thisNum].color,
                      activated: presetData[thisNum].active,
                      onTap: (LColor rgb) => presetTapped(rgb),
                      onLongPress: thisNum < numPresets? () => presetLongPress(thisNum): (){},
                    ));
                  }
                  presets.add(new Row(
                   children: thisRow,
                  ));
                }
                return new Column(
                  children: presets,
                );
              }
            ),
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
    presetData[prst].color = color;
    checkPresets(color);
    savePresets();
    setState(() {});
  }

  void savePresets(){
    GlobalDataHandler.storeData(
        "presets",
        presetData.toString().replaceAll(new RegExp("]|\\["), ""),
        (bool b){
          print("wrote");
        }
    );
  }

  void presetDoubleTap(int prst){
    if(prst > numPresets) return;
    String newName;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return new AlertDialog(
              title: Text("Rename \"" + presetData[prst].name + "\""),
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
                    presetData[prst].name = newName;
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
      if(rgb != presetData[i].color){
        presetData[i].active = false;
      }
      else{
        presetData[i].active = true;
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