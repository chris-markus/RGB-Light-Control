import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './pages/connect_page.dart';

void main() => runApp(new MainApp());

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }
}

class MainState extends State<MainApp> {
  @override
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget build(BuildContext context){
    return new MaterialApp(
      home: DefaultTabController(
       length: 2,
       child: Scaffold(
         key: _scaffoldKey,
         drawer: new Drawer(
           child: ListView(
             padding: EdgeInsets.zero,
             children: <Widget>[
               DrawerHeader(
                 child: Text('Devices'),
                 decoration: BoxDecoration(
                   color: Colors.blue,
                 ),
               ),
               ListTile(
                 title: Text('Item 1'),
                 onTap: () {
                   setState(() {
                   });
                 },
               ),
               ListTile(
                 title: Text('Item 2'),
                 onTap: () {
                   // Update the state of the app
                   // ...
                 },
               ),
             ],
           ),
         ),
         appBar: AppBar(
           leading: new IconButton(icon: new Icon(Icons.build),
               onPressed: () => _scaffoldKey.currentState.openDrawer()),
           bottom: TabBar(
             tabs: [
               Tab(icon: Icon(Icons.tonality)),
               Tab(icon: Icon(Icons.toll))
             ]
           ),
           title: Text("Lighting Control"),
         ),
         body: TabBarView(
           children: <Widget>[
             Icon(Icons.tonality),
             Icon(Icons.toll)
           ],
         )
       )
      )
    );
  }
}