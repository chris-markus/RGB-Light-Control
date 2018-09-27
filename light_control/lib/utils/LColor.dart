
import 'dart:ui';

class LColor{
  final int red;
  final int green;
  final int blue;

  static const int COLORMAX = 255;

  const LColor(this.red, this.green, this.blue);

  Color toDartColor(){
    int r = ((red / COLORMAX) * COLORMAX).floor();
    int b = ((blue / COLORMAX) * COLORMAX).floor();
    int g = ((green / COLORMAX) * COLORMAX).floor();
    return new Color.fromRGBO(r, g, b, 1.0);
  }

  String toHexColor(double intensity){
    intensity /= COLORMAX;
    int newRed = (red * intensity).round();
    int newGreen = (green * intensity).round();
    int newBlue = (blue * intensity).round();
    String rgb = newRed.toRadixString(16).padLeft(2,'0') +
        newGreen.toRadixString(16).padLeft(2,'0') +
        newBlue.toRadixString(16).padLeft(2,'0');
    return rgb;
  }
  String toExpHexColor(double intensity){
    intensity /= COLORMAX;
    int newRed = (red*red/COLORMAX * intensity).round();
    int newGreen = (green*green/COLORMAX * intensity).round();
    int newBlue = (blue*blue/COLORMAX * intensity).round();
    var rgb = newRed << 20 | newGreen << 10 | newBlue;
    var rgbstr = rgb.toRadixString(16);
    return rgbstr;
  }
}

class LColors{
  static const LColor white = LColor(
      LColor.COLORMAX,
      LColor.COLORMAX,
      LColor.COLORMAX
  );
  static const LColor red = LColor(
    LColor.COLORMAX,
    0,
    0
  );
  static const LColor green = LColor(
    0,
    LColor.COLORMAX,
    0
  );
  static const LColor blue = LColor(
    0,
    0,
    LColor.COLORMAX
  );
  static const LColor black = LColor(0,0,0);
}