import 'package:flutter/material.dart';
import 'package:light_control/uipartials/color_circle.dart';
import 'package:light_control/utils/LColor.dart';
import 'package:light_control/utils/color_picker.dart';

class AnimationView extends StatefulWidget {

  AnimationView();

  @override
  createState() => AnimationViewState();
}

class AnimationViewState extends State<AnimationView> {

  List<Keyframe> keyframes = [];

  TextStyle headingStyle = new TextStyle(fontSize: 16.0, color: Colors.black54);

  @override
  Widget build(BuildContext context) {
    //animationList = new AnimationList(parentContext: context);
    return new Stack(
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
                    onPressed: (){},
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

  KeyframeDialogs({@required this.onComplete});

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
  LColor tempColor = LColors.white;

  @override
  Widget build(BuildContext context) {
    Widget currDialog;
    switch (page){
      case 3:
        //intensity
        currDialog = new AlertDialog(
            title: Text("Set Intensity"),
            content: Column(
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
              ],
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
          content: new ColorPicker(
              color: tempColor,
              onChanged: (LColor newColor){
                setState(() {
                  tempColor = newColor;
                });
              }
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
            title: Text("Set Duration"),
            content: Column(
              children: <Widget>[
                Center(
                  child: new Text(
                    tempTime.toString(),
                    style: new TextStyle(fontSize: 16.0, color: Colors.black54),
                  ),
                ),
                new Slider(
                    value: tempTime,
                    min: 0.0,
                    max: 60.0,
                    onChanged: (double newTime){
                      setState(() {
                        tempTime = newTime;
                      });
                    }
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


class Keyframe extends StatelessWidget{

  final LColor color;
  final int intensity;
  final double time;
  bool hasColor;
  bool hasIntensity;

  final TextStyle textStyle = new TextStyle(fontSize: 16.0, color: Colors.black54);

  Keyframe({@required this.time, this.intensity, this.color}){
    hasIntensity = false;
    hasColor = false;
    if(this.intensity != null){
      hasIntensity = true;
    }
    if(this.color != null){
      hasColor = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.check_circle_outline, color: Colors.grey, size: 20.0),
              onPressed: (){},
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                time.toString() + "s",
                style: textStyle,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: (color == null? new Text("-", style: textStyle):Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 12.0, right: 32.0),
                child: ColorCircle(
                  color: color,
                  circleSize: 16.0,
                ),
              )),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                (intensity == null ? "-" : intensity.toString()),
                style: textStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
