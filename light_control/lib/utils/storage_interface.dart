import 'package:shared_preferences/shared_preferences.dart';

class GlobalDataHandler {
  static void storeData(String key, dynamic value, callback) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key.toString(), value.toString());
    callback(true);
  }
  static void retrieveData(String key, callback) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(key);
    callback(true, data);
  }
}