import 'package:flutter/material.dart';

class ParameterView extends StatefulWidget{
  final Widget parent;
  ParameterView(this.parent);

  @override
  createState() => ParameterViewState();
}

class ParameterViewState extends State<ParameterView>{
  Widget build(BuildContext context){
    return Container(
      child: Column(
      children: <Widget>[
        Text("henlo")
      ],
      )
    );
  }
}

