import 'package:flutter/material.dart';
import 'package:light_control/utils/LColor.dart';

class Preset extends StatelessWidget {

  final String presetName;
  final bool activated;
  final Color inactiveColor;
  final Color activeColor;
  final LColor color;
  final onTap;
  final onLongPress;
  final onDoubleTap;

  Preset({
    @required String this.presetName,
    this.inactiveColor = Colors.grey,
    this.activeColor = Colors.blue,
    this.activated = false,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.color = LColors.white
  });

  @override
  build(BuildContext context){
      return new Expanded(
          flex: 1,
            child: new Card(
                elevation: 3.0,
                child: Container(
                    child: ClipRRect(
                      borderRadius: new BorderRadius.all(Radius.circular(4.0)),
                      child: new CustomPaint(
                        painter: new CustomPresetPainter(
                          presetColor: color.toDartColor(),
                          indicatorColor: (activated? activeColor : inactiveColor)
                        ),
                        child: new InkWell(
                            child: new Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                                  child: new Text(presetName),
                                )
                            ),
                          onTap: (){
                              if(onTap != null) {
                                onTap(color);
                              }
                          },
                          /*onDoubleTap: (){
                              if(onDoubleTap !=null){
                                onDoubleTap();
                              }
                          },*/
                          onLongPress: (){
                              if(onLongPress != null) {
                                onLongPress();
                              }
                          },
                        )
                      ),
                    ),
                  ),
            ),
      );
  }
}

class CustomPresetPainter extends CustomPainter{
  Color indicatorColor;
  Color presetColor;
  final Paint indicatorPaint;
  final Paint presetPaint;
  final Path circle = new Path();

  CustomPresetPainter({
    @required this.indicatorColor,
    @required this.presetColor,
  }) : indicatorPaint = new Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill,
     presetPaint = new Paint()
      ..color = presetColor
      ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    Offset circleCenter = Offset(0.0,size.height);
    Rect bottomRect = Offset(0.0, 0.0) & const Size(double.infinity, 5.0);
    circle.addOval(new Rect.fromCircle(center: Offset(3.0,size.height), radius: size.height/2.0));
    canvas.drawShadow(circle, Colors.black45, 5.0, true);
    canvas.drawCircle(circleCenter, size.height/2.0, presetPaint);
    canvas.drawRect(bottomRect, indicatorPaint);
  }

  @override
  bool shouldRepaint(CustomPresetPainter oldDelegate) {
    return oldDelegate.indicatorColor != indicatorColor;
  }
}