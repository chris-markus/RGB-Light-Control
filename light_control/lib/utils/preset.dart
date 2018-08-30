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
                        onDoubleTap: (){
                            if(onDoubleTap !=null){
                              onDoubleTap();
                            }
                        },
                        onLongPress: (){
                            if(onLongPress != null) {
                              onLongPress();
                            }
                        },
                      )
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
    Rect bottomRect = const Offset(0.0, 0.0) & const Size(double.infinity, 4.0);
    canvas.drawCircle(Offset(0.0,size.height), size.height/2.0, presetPaint);
    canvas.drawRect(bottomRect, indicatorPaint);
  }

  @override
  bool shouldRepaint(CustomPresetPainter oldDelegate) {
    return oldDelegate.indicatorColor != indicatorColor;
  }
}