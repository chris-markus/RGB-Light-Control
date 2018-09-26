import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:light_control/uipartials/color_circle.dart';
import 'package:light_control/utils/LColor.dart';
import 'package:light_control/utils/color_picker.dart';

class AnimationView extends StatefulWidget {

  AnimationView();

  @override
  createState() => AnimationViewState();
}

BuildContext _globalContext;
GlobalKey keyframeKey;

class AnimationViewState extends State<AnimationView> {

  List<Keyframe> keyframes = [];

  TextStyle headingStyle = new TextStyle(fontSize: 16.0, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    //animationList = new AnimationList(parentContext: context);
    _globalContext = context;
    return new Stack(
      //key: _masterKey,
      children: <Widget>[
        Container(
          height: 40.0,
          width: double.infinity,
          decoration: new BoxDecoration(color: Colors.white, boxShadow: [
            new BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 2.0),
                blurRadius: 2.0)
          ]),
          child: Material(
            type: MaterialType.transparency,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: IconButton(
                    icon: Icon(Icons.done_all, color: Colors.grey, size: 20.0),
                    onPressed: (){
                      bool newActive = false;
                      for (var item in keyframes) {
                        if (!item.checked) {
                          newActive = true;
                          break;
                        }
                      }
                      for (var item in keyframes) {
                        item.checked = newActive;
                        item.setChecked();
                      }
                    },
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      "Length",
                      style: headingStyle
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Color",
                      style: headingStyle
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Intensity",
                      style: headingStyle
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: new KeyframeList(
            key: keyframeKey,
            parentContext: context,
            keyframes: keyframes,
            onAdd: (Keyframe k){
              keyframes.add(k);
              setState(() {
              });
            }
          )
        ),
      ],
    );
  }
}


class KeyframeList extends StatelessWidget{

  final List<Keyframe> keyframes;
  final onAdd;
  final BuildContext parentContext;

  KeyframeList({
    Key key,
    @required this.keyframes,
    @required this.parentContext,
    @required this.onAdd}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView(
        padding: new EdgeInsets.all(0.0),
        children: _buildList()
    );
  }

  List<Widget> _buildList(){
    Widget newKeyframe = InkWell(
      onTap: () => _addKeyframe(),
      child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                  "+ New Keyframe",
                  style: new TextStyle(fontSize: 16.0, color: Colors.grey)),
            ),
          ]
      ),
    );

    List<Widget> keyframeWidgetList = [];

    for(int i=0; i<keyframes.length; i++){
      keyframeWidgetList.add(keyframes[i]);
      keyframeWidgetList.add(new Divider(height: 1.0),);
    }
    keyframeWidgetList.add(newKeyframe);

    return keyframeWidgetList;
  }

  void _addKeyframe(){
    showDialog(
      context: parentContext,
      builder: (BuildContext context){
        return new KeyframeDialogs(
          onComplete: (double t, int i, LColor c){
            onAdd(new Keyframe(time: t, intensity: i, color: c));
            Navigator.of(parentContext).pop();
          },
        );
      }
    );
  }

}

class KeyframeDialogs extends StatefulWidget{

  final onComplete;
  final double startTime;
  final LColor startColor;
  final int startIntensity;

  KeyframeDialogs({
    @required this.onComplete,
    this.startTime = 0.0,
    this.startColor = LColors.white,
    this.startIntensity = 0
  });

  @override
  createState() => KeyframeDialogsState();

}

class KeyframeDialogsState extends State<KeyframeDialogs>{

  int page = 1;

  int intensity;
  double time;
  LColor color;

  int tempIntensity = 0;
  double tempTime = 0.0;
  int tempMin = 0;
  int tempSec = 0;
  double tempMilis = 0.0;
  LColor tempColor = LColors.white;

  @override
  initState(){
    super.initState();
    tempIntensity = widget.startIntensity;
    tempTime = widget.startTime;
    tempColor = widget.startColor;
  }

  @override
  Widget build(BuildContext context) {
    Widget currDialog;
    switch (page){
      case 3:
        //intensity
        currDialog = new AlertDialog(
            title: Text("Set Intensity"),
            content: Flex(
              mainAxisSize: MainAxisSize.min,
              direction: Axis.vertical,
                children: <Widget>[
                  Center(
                    child: new Text(
                      tempIntensity.round().toString(),
                      style: new TextStyle(fontSize: 16.0, color: Colors.black54),
                    ),
                  ),
                  new Slider(
                      value: tempIntensity*1.0,
                      min: 0.0,
                      max: LColor.COLORMAX.toDouble(),
                      onChanged: (double intens){
                        setState(() {
                          tempIntensity = intens.round();
                        });
                      }
                  ),
                ]
              ),
            actions: [
              new FlatButton(
                  onPressed: (){
                    widget.onComplete(time, intensity, color);
                  },
                  child: new Text("Blank")),
              new FlatButton(
                onPressed: () {
                  setState(() {
                    intensity = tempIntensity;
                  });
                  widget.onComplete(time, intensity, color);
                },
                child: new Text("Done"),
              )
            ]
        );
        break;
      case 2:
        //color
        currDialog = new AlertDialog(
          contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
          title: Text("Pick a color"),
          content: Container(
            width: 0.0,
            child: new ColorPicker(
                color: tempColor,
                onChanged: (LColor newColor){
                  setState(() {
                    tempColor = newColor;
                  });
                }
            ),
          ),
          actions: [
            new FlatButton(
                onPressed: (){
                  setState(() {
                    page ++;
                  });
                },
                child: new Text("Blank")),
            new FlatButton(
              onPressed: () {
                setState(() {
                  page ++;
                  color = tempColor;
                });
              },
              child: new Text("Next"),
            )
          ]
        );
        break;
      case 1:
      default:
        //time
        currDialog = new AlertDialog(
            title: Text("Keyframe Duration"),
              content: Column(
                //direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Center(
                      child: new TimeSelector(
                        startTime: tempTime,
                        onTimeChange: ({min, sec, milis}){
                          if(min != null){
                            tempMin = min;
                          }
                          if(sec != null){
                            tempSec = sec;
                          }
                          if(milis != null){
                            tempMilis = milis;
                          }
                          tempTime = tempMin * 60.0 + tempSec + tempMilis;
                        }
                      )
                  ),
                ],
              ),
            actions: [
              new FlatButton(
                onPressed: () {
                  setState(() {
                    page ++;
                    time = tempTime;
                  });
                },
                child: new Text("Next"),
              )
            ]
        );
        break;
    }
    return currDialog;
  }
}

class TimeSelector extends StatelessWidget{
  List<Widget> minutes = [];
  List<Widget> seconds = [];
  List<Widget> milis = [];

  final double itemWidth;
  final double selectorHeight;
  final double itemExtent;
  final onTimeChange;
  final double startTime;

  static const int numMin = 100;

  FixedExtentScrollController _milisController;
  FixedExtentScrollController _secondsController;
  FixedExtentScrollController _minutesController;

  TextStyle numberStyle = new TextStyle(
      fontSize: 20.0
  );

  TextStyle labelStyle = new TextStyle(
    color: Colors.black45,
    fontSize: 13.0
  );

  TimeSelector({
    this.itemWidth = 60.0,
    this.selectorHeight = 100.0,
    this.itemExtent = 30.0,
    this.onTimeChange,
    this.startTime = 0.0,
  }){
    for(int i = 0; i < numMin; i++){
      minutes.add(new Text(i.toString(), style: numberStyle));
    }
    for(int i = 0; i <= 59; i++){
      seconds.add(new Text(i.toString(), style: numberStyle));
    }
    for(double i = 0.0; i <= 0.75; i += 0.25){
      milis.add(new Text(i.toString().substring(2).padRight(2, "0"), style: numberStyle));
    }

    _milisController = new FixedExtentScrollController(initialItem: ((startTime - startTime.floor()) ~/ 0.25));
    _secondsController = new FixedExtentScrollController(initialItem: startTime.floor()%60);
    _minutesController = new FixedExtentScrollController(initialItem: (startTime/60).floor());

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: itemWidth + 5.0,
                  child: Center(child: Text("min", style: labelStyle))
                ),
                Container(
                    width: itemWidth + 5.0,
                    child: Center(child: Text("sec", style: labelStyle))
                ),
                Container(
                    width: itemWidth + 5.0,
                    child: Center(child: Text("ms", style: labelStyle))
                )
              ],
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              border: new Border(top: BorderSide(color: Colors.black12), bottom: BorderSide(color: Colors.black12))
            ),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: itemWidth,
                    height: selectorHeight,
                    child: ListWheelScrollView(
                      physics: new FixedExtentScrollPhysics(),
                      controller: _minutesController,
                      itemExtent: itemExtent,
                      children: minutes,
                      onSelectedItemChanged: (int min) {
                        onTimeChange(min:min%numMin);
                      }
                    ),
                  ),
                  Container(
                    height: selectorHeight,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(":", style: new TextStyle(color: Colors.black45, fontSize: 20.0)),
                      )
                    )
                  ),
                  Container(
                    width: itemWidth,
                    height: selectorHeight,
                    child: ListWheelScrollView(
                      physics: new FixedExtentScrollPhysics(),
                      controller: _secondsController,
                      itemExtent: itemExtent,
                      children: seconds,
                      onSelectedItemChanged: (int sec){
                        onTimeChange(sec:sec%60);
                      }
                    ),
                  ),
                  Container(
                      height: selectorHeight,
                      child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text(".", style: new TextStyle(color: Colors.black45, fontSize: 20.0)),
                          )
                      )
                  ),
                  Container(
                    width: itemWidth,
                    height: selectorHeight,
                    child: ListWheelScrollView(
                      physics: new FixedExtentScrollPhysics(),
                      controller: _milisController,
                      itemExtent: itemExtent,
                      children: milis,
                      onSelectedItemChanged: (int milis) {
                        //_milisController.animateToItem(milis, duration: Duration(milliseconds: 300), curve: Curves.ease);
                        onTimeChange(milis:(milis%4.toDouble() * 0.25));
                      }
                    ),
                  )
              ]
            ),
          ),
        ],
      ),
    );
  }

}

class Keyframe extends StatefulWidget{

  bool checked;
  LColor color;
  int intensity;
  double time;
  bool hasColor;
  bool hasIntensity;

  final TextStyle textStyle = new TextStyle(fontSize: 16.0, color: Colors.black54);

  Keyframe({@required this.time, this.intensity, this.color, this.checked = false}){
    hasIntensity = false;
    hasColor = false;
    if(this.intensity != null){
      hasIntensity = true;
    }
    if(this.color != null){
      hasColor = true;
    }
  }


  KeyframeState keyframeState;

  @override
  State<StatefulWidget> createState(){
    keyframeState = new KeyframeState();
    return keyframeState;
  }


  void edit({double time, int intensity, LColor color}){
      this.time = time;
      this.intensity = intensity;
      this.color = color;
  }

  void setChecked() => keyframeState.setChecked();
}

class KeyframeState extends State<Keyframe>{

  void setChecked(){
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => editKeyframe(widget),
      onTap: (){
        setState(() {
          widget.checked = !widget.checked;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 23.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Icon(
                  (widget.checked ? Icons.check_circle : Icons.check_circle_outline),
                  color: (widget.checked ? Colors.blue : Colors.grey), size: 20.0),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  (widget.time >= 60 ? (widget.time/60).round().toString() + "m " : "") +
                      (widget.time%60 != 0 || widget.time < 60? (widget.time%60).toString() + "s" : ""),
                  style: widget.textStyle,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: (widget.color == null? new Text("-", style: widget.textStyle):Padding(
                  padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 32.0),
                  child: ColorCircle(
                    color: widget.color,
                    circleSize: 16.0,
                  ),
                )),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Text(
                  (widget.intensity == null ? "-" : widget.intensity.toString()),
                  style: widget.textStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void editKeyframe(Keyframe k){
    showDialog(
        context: _globalContext,
        builder: (BuildContext context){
          return new KeyframeDialogs(
            startColor: (k.color == null ? LColors.white : k.color),
            startIntensity: (k.intensity == null ? 0 : k.intensity),
            startTime: k.time,
            onComplete: (double t, int i, LColor c){
              k.edit(time: t, intensity: i, color: c);
              Navigator.of(_globalContext).pop();
              setState(() {
              });
            },
          );
        }
    );
  }
}
