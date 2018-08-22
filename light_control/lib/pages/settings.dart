import 'package:flutter/material.dart';

class Settings extends StatelessWidget {

  final parentContext;

  Settings({@required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: Text("Settings"),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: (){
            Navigator.of(parentContext).pop();
          },
        ),
      ),
      body: new ListView(
        children: <Widget>[
          ListTile(
            title: Text("Setting 1"),
          )
        ],
      ),
    );
  }

}