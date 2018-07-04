import 'package:flutter/material.dart';
import 'dart:io';

class FetchDevices {
  List <Device> devices = [];
  Device fetch(){
    return new Device("100", "fjsh", "hello");
  }

  void update(){
    devices = [
      new Device("1", "2", "device 1"),
      new Device("1", "2", "device 2")
    ];
  }

  List<Device> read() {
    return devices;
  }
}

class Device {
  final ip;
  String codename;
  final mac;
  Device(this.ip, this.mac, [this.codename]){
    if(this.codename == null){
      this.codename = "Unnamed";
    }
  }
  void setCodename(codename){
    this.codename = codename;
  }
  String getCodename(){
    return codename;
  }
}