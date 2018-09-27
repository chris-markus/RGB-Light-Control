import 'dart:async';
import 'package:flutter/material.dart';
import 'package:light_control/pages/animations.dart';

import './pages/parameters.dart';
import './pages/settings.dart';
import './utils/fetch_devices.dart';

FetchDevices deviceManager = new FetchDevices();

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

BuildContext mainContext;

void main() => runApp(new MainApp());

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainState();
  }
}

class MainState extends State<MainApp> {
  PageController _pageController;
  int _page = 0;
  final tabKey = null;

  final connected = SnackBar(
      content: Text("Connected!"),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ));

  static const String routeName = '/material/modal-bottom-sheet';

  ThemeData theme = new ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    accentColor: Colors.cyan[600],
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        routes: <String, WidgetBuilder>{
          '/settings': (BuildContext context) =>
              new Settings(parentContext: context),
          '/animationList': (BuildContext context) =>
            new AnimationView(),
        },
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Builder(
          builder: (BuildContext context) {
            mainContext = context;
          return Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            /*floatingActionButton: FloatingActionButton(
                child: Icon(Icons.devices),
                elevation: 1000.0,
                onPressed: () => _scaffoldKey.currentState.openDrawer()),*/
            key: _scaffoldKey,
            body: new PageView(
                physics: new NeverScrollableScrollPhysics(),
                children: [
                  new Scaffold(
                    appBar: AppBar(
                        centerTitle: true,
                        title: Text("Live Control"),
                        leading: IconButton(
                            icon: Icon(Icons.devices),
                            onPressed: () => _scaffoldKey.currentState.openDrawer()
                        ),
                        actions: [
                          IconButton(
                            icon: Icon(Icons.settings),
                            onPressed: () {
                              //deviceManager.connect((){deviceManager.write("FFFFFF");});
                              Navigator.pushNamed(mainContext, "/settings");
                            },
                          )
                        ]
                    ),
                    body: ParameterView(
                      tabKey,
                      onParameterChanged: (String data) => deviceManager.write(data),
                    )
                  ),
                  new AnimationsFlow(),
                ],
                controller: _pageController,
                onPageChanged: (int page){
                  setState((){
                    _page = page;
                  });
                }
            ),
            bottomNavigationBar: new BottomNavigationBar(
              items: [
                new BottomNavigationBarItem(
                    title: Text("Control"), icon: Icon(Icons.tonality)),
                /*new BottomNavigationBarItem(
                  title: Text("Devices"),
                  icon: Text(""),
                ),*/
                new BottomNavigationBarItem(
                    title: Text("Animation"), icon: Icon(Icons.toll)),
              ],
              currentIndex: _page,
              onTap: naviTap,
            ),
            drawer: new Drawer(
              child: SafeArea(
                child: DeviceList()
              )
            ),
          );
        }));
  }

  void naviTap(int page) {
    _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    _pageController = new PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

class AnimationsFlow extends StatefulWidget {
  const AnimationsFlow({
    Key key,
  }) : super(key: key);

  @override
  AnimationsFlowState createState() {
    return new AnimationsFlowState();
  }
}

class AnimationsFlowState extends State<AnimationsFlow> {

  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return new AnimationList(parentContext: mainContext);
  }
}

//Device List
class DeviceList extends StatefulWidget {
  @override
  createState() => DeviceListState();
}

class DeviceListState extends State<DeviceList> {
  var _devices = <Device>[];
  var _listItems = <Widget>[];
  var _listKey;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _devicesRefresh,
        child: Stack(
          children: <Widget>[
            Container(
              height: 56.0,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: IconButton(
                            icon: Icon(Icons.done_all),
                            onPressed: () {
                              bool newActive = false;
                              for (int i = 0; i < _devices.length; i++) {
                                if (!_devices[i].active) {
                                  newActive = true;
                                  break;
                                }
                              }
                              for (int i = 0; i < _devices.length; i++) {
                                _devices[i].active = newActive;
                              }
                              setState(() {});
                            }),
                      ),
                      /*IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),*/
                      Text("Devices", // + tiles.length.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0)),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {
                            _refreshIndicatorKey.currentState.show();
                          },
                        ),
                      ),
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: new ListView(
                  padding: new EdgeInsets.all(0.0),
                  key: _listKey,
                  children: _buildList()),
            ),
          ],
        ));
  }

  Future<Null> _devicesRefresh() {
    deviceManager.update();
    setState(() {});
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(seconds: 3), () {
      completer.complete(null);
    });
    return completer.future.then((_) {
      _scaffoldKey.currentState?.showSnackBar(new SnackBar(
          content: const Text("Devices Refreshed"),
          action: new SnackBarAction(
              label: 'RETRY',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              })));
    });
  }

  List<Widget> _buildList() {
    _devices = deviceManager.devices;
    _listItems = [];
    if (_devices.length == 0) {
      _listItems.add(new ListTile(
          title:
              Text("No Devices.", style: new TextStyle(color: Colors.grey))));
      return _listItems;
    }
    for (var i = 0; i < _devices.length; i++) {
      _listItems.add(_buildRow(_devices[i]));
      //print(_listItems);
    }
    setState(() {});
    return _listItems;
  }

  Widget _buildRow(Device d) {
    String newCodename;
    return Column(children: [
      ListTile(
        onTap: () {
          d.toggleActive();
          setState(() {});
        },
        onLongPress: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                  title: Text("Rename \"" + d.codename + "\""),
                  content: new TextField(
                    decoration: new InputDecoration(labelText: "New Name"),
                    onChanged: (String text) {
                      newCodename = text;
                    },
                  ),
                  actions: [
                    new FlatButton(
                        onPressed: () => d.flash(), child: new Text("Flash")),
                    new FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: new Text("Cancel")),
                    new FlatButton(
                      onPressed: () {
                        d.codename = newCodename;
                        setState(() {});
                        Navigator.pop(context);
                      },
                      child: new Text("Save"),
                    )
                  ]);
            }),
        title: Text(
          d.getCodename(),
          style: new TextStyle(
            color: (d.active ? Colors.black54 : Colors.grey),
            fontSize: 18.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        leading: Icon(
            (d.active ? Icons.check_circle : Icons.check_circle_outline),
            color: (d.active ? Colors.blue : Colors.grey)),
      ),
      Divider(height: 1.0),
    ]);
  }
}
