import 'package:flutter/material.dart';
import 'package:light_control/utils/fetch_devices.dart';

class ConnectPage extends StatefulWidget {
  @override
  State createState() => new ConnectPageState();
}
class ConnectPageState extends State<ConnectPage> {
  @override
  Widget build(BuildContext context){
    return new Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
            new Card(
              child: new Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new Text("henlo"),
                ],
              )
            )
          ],
    );
  }
}