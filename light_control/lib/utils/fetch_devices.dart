import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class FetchDevices {

  //FlutterBlue flutterBlue = FlutterBlue.instance;

  String lastData = "";

  List <Device> devices = [];

  WebSocketChannel channel;

  Device fetch(){

  }

  void update(){
    if(devices.length == 0){
      devices.add(new Device('ws://192.168.1.1:81/', "mac"));
    }
    connect();
  }

  void connect(){
    for(int i=0; i<devices.length; i++){
      devices[i].connect();
    }
  }

  List<Device> read() {
    return devices;
  }

  void write(String data){
    for(int i=0; i<devices.length; i++){
      devices[i].sendData(data);
    }
  }

}

class Device {
  bool active = false;
  final String ip;
  WebSocketChannel channel;
  String codename;
  final mac;
  Device(this.ip, this.mac, [this.codename]){
    if(this.codename == null){
      this.codename = "Unnamed";
    }
  }
  void toggleActive(){
    if(active){
      active = false;
      channel.sink.close();
    }
    else{
      active = true;
      connect();
    }
  }
  void connect(){
    if(active) {
      channel = IOWebSocketChannel.connect('ws://192.168.1.1:81/');
    }
  }
  void sendData(String data){
    if(active){
      channel.sink.add(data);
    }
  }
  void setCodename(codename){
    this.codename = codename;
  }
  String getCodename(){
    return codename;
  }
  void flash(){
    print(codename + " flashed");
  }

}

/*
class IPAddr{
  final octet1;
  final octet2;
  final octet3;
  final octet4;

  const IPAddr(this.octet1, this.octet2, this.octet3, this.octet4);

  String toString(){
    return octet1.toString() + "." +
        octet2.toString() + "." +
        octet3.toString() + "." +
        octet4.toString();
  }

  IPAddr next(){
    if(octet4 >= 255 && octet3 >= 255){
      return new IPAddr(octet1, octet2, IPAddr.home.next().octet3, IPAddr.home.next().octet4);
    }
    else if(octet4 >= 255 && octet3 < 255){
      return new IPAddr(octet1, octet2, octet3+1, 0);
    }
    else if(octet4 < 255){
      return new IPAddr(octet1, octet2, octet3, octet4 + 1);
    }
    return IPAddr.home.next();
  }
  static IPAddr home = new IPAddr(192,168,1,1);
}*/