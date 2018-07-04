import 'package:flutter/material.dart';
//import 'package:http/http.dart' as http;

import './pages/connect_page.dart';
import './pages/parameters.dart';

import './utils/fetch_devices.dart';

FetchDevices deviceManager = new FetchDevices();

void main() => runApp(new MainApp());

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }
}

class MainState extends State<MainApp> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController;
  int _page = 0;
  final tabKey;

  ThemeData theme = new ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue, //Changing this will change the color of the TabBar
    accentColor: Colors.cyan[600],
  );



  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      theme: theme,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
          FloatingActionButton(
          child: Icon(Icons.devices),
          elevation: 1000.0,
            onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
         key: _scaffoldKey,
         body: new PageView(
           children: [
             new Container(child: ParameterView(tabKey)),
             new Container(child: Icon(Icons.toll)),
           ],
           controller: _pageController,
           onPageChanged: onPageChanged
         ),
         bottomNavigationBar: new BottomNavigationBar(
           items: [
             new BottomNavigationBarItem(title: Text("Control"),icon: Icon(Icons.tonality)),
             new BottomNavigationBarItem(
               title: Text(""),
               icon: Text(""),
               backgroundColor: Colors.red
             ),
             new BottomNavigationBarItem(title: Text("Animation"),icon: Icon(Icons.toll)),
           ],
           currentIndex: _page,
           onTap: naviTap,
         ),
         drawer: new Drawer(
           child: DeviceList()
           ),
         )
    );
  }

  void naviTap(int page){
    if(page == 1){
      _scaffoldKey.currentState.openDrawer();
      return;
    }
    else if(page >= 1){
      page = 1;
    }
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }

  void onPageChanged(int page){
    if(page == 1){
      page = 2;
    }
    setState((){
      this._page = page;
    });
  }
}

class DeviceList extends StatefulWidget{
  @override
  createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {

  var _devices = <Device>[];
  var _listItems = <Widget>[];
  var _listKey;

  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new ListView(
      key: _listKey,
      children: _buildList()
    );
  }

  List<Widget> _buildList() {
    _devices = deviceManager.read();
    _listItems = [];
    _listItems.add(ListTile(
      leading: IconButton(
        icon: Icon(Icons.refresh),
        onPressed: (){
          deviceManager.update();
          setState((){
          });
        },
      ),
      trailing: IconButton(
        icon: Icon(Icons.close),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      title: Text("Devices",// + tiles.length.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
    ));
    if(_devices.length == 0){
      _listItems.add(new ListTile(title: Text("No Devices.", style: new TextStyle(color: Colors.grey))));
      return _listItems;
    }
    for(var i=0; i<_devices.length; i++){
      _listItems.add(_buildRow(_devices[i]));
      print(_listItems);
    }
    setState(() {
    });
    return _listItems;
  }

  Widget _buildRow(Device d){
    return ListTile(
      title: Text(
        d.getCodename(),
        style: _biggerFont,
      ),
    );
  }
}