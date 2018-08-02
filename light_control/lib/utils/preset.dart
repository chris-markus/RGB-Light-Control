import 'package:flutter/material.dart';

class Preset extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => PresetState();

  final String presetName;
  bool activated;
  final Color activeColor;
  final Color inactiveColor;
  final onTap;
  final onLongPress;

  Preset({
    @required String this.presetName,
    this.activated = false,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.onTap = null,
    this.onLongPress = null
  });

}

class PresetState extends State<Preset> {

  @override
  build(BuildContext context){
      return new Expanded(
        child: new Card(
            elevation: 3.0,
            child: Container(
                child: new CustomPaint(
                  painter: new CustomPresetPainter(
                    indicatorColor: (widget.activated? widget.activeColor:widget.inactiveColor),
                  ),
                  child: new InkWell(
                      child: new Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                            child: new Text(widget.presetName),
                          )
                      ),
                    onTap: (){
                        widget.activated = !widget.activated;
                        if(widget.onTap != null) {
                          widget.onTap(widget.activated);
                        }
                        setState(() {
                        });
                    },
                    onLongPress: (){
                        widget.activated = true;
                        if(widget.onLongPress != null) {
                          widget.onLongPress();
                        }
                        setState((){
                        });
                    },
                  )
                ),
              ),
        ),
      );
  }
}

class CustomPresetPainter extends CustomPainter{
  final Color indicatorColor;
  final Paint indicatorPaint;

  CustomPresetPainter({
    @required this.indicatorColor
  }) : indicatorPaint = new Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    Rect BottomRect = const Offset(0.0, 0.0) & const Size(double.infinity, 4.0);
    canvas.drawRect(BottomRect, indicatorPaint);
  }

  @override
  bool shouldRepaint(CustomPresetPainter oldDelegate) {
    return oldDelegate.indicatorColor != indicatorColor;
  }
}