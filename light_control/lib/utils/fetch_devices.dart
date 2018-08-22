import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

class FetchDevices {

  //FlutterBlue flutterBlue = FlutterBlue.instance;

  String lastData = "";

  List <Device> devices = [
    new Device(new InternetAddress("192.168.1.1"), "fjsh", "Device 1"),
    new Device(new InternetAddress("192.168.1.1"), "fjsh", "Device 2"),
    new Device(new InternetAddress("192.168.1.1"), "fjsh", "Device 3"),
    new Device(new InternetAddress("192.168.1.1"), "fjsh", "Device 4")
  ];

  Socket mainSocket;
  bool connected = false;

  Device fetch(){
    return new Device(new InternetAddress("192.168.1.1"), "fjsh", "hello");
  }


  //Highly experimental:
  void update(){
    /*BluetoothDevice newDevice;
    var scanSubscription = flutterBlue.scan().listen((scanResult) {
      newDevice = scanResult.device;
      // do something with scan result
    });
    Timer(new Duration(seconds: 5), (){
      var deviceConnection = flutterBlue.connect(newDevice).listen((s) {
        if(s == BluetoothDeviceState.connected) {
          scanSubscription.cancel();
          devices.add(Device(InternetAddress("192.168.1.1"), newDevice.toString()));
        }
      });
    });*/

    //devices.add(new Device(new InternetAddress("192.168.1.1"), "fjsh", "New Device"));

    print("test");
    var packet = "lt?";
    var codec = new Utf8Codec();
    List<int> encodedPacket = codec.encode(packet);
    var listeningAddresses = InternetAddress.anyIPv4;
    int listeningPort = 3996;
    RawDatagramSocket.bind(listeningAddresses, listeningPort)
    .then((RawDatagramSocket udpSocket) {
      udpSocket.listen((RawSocketEvent e){
        if(e == RawSocketEvent.read) {
          Datagram dg = udpSocket.receive();
          dg.data.forEach((x) => print(x));
        }
      });
      udpSocket.send(encodedPacket, new InternetAddress("192.168.1.1"), 4210);
      print("sentdata");
    });
  }

  List<Device> read() {
    return devices;
  }
  void connect(callback){
    Socket.connect("192.168.1.1", 21)
        .then((Socket socket){
          mainSocket = socket;
          socket.listen(dataHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false);
          callback();
    })
        .catchError((AsyncError e){
      print("Error: $e");
      connected = false;
    });
  }

  void write(String data){
    if(connected){
      if(lastData == data) return;
      lastData = data;
      //print(data);
      //mainSocket.write(data);
    }
    else{
      connect((){});
    }
  }

  void dataHandler(data){
    print(new String.fromCharCode(data).trim());
  }

  void errorHandler(error, StackTrace trace){
    print(error);
  }

  void doneHandler(){
    mainSocket.destroy();
    connected = false;
  }

}

class Device {
  bool active = false;
  final InternetAddress ip;
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