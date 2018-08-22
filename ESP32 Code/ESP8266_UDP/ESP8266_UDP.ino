#include <ESP8266WiFi.h>
#include <WiFiUdp.h>

#define MAX_SRV_CLIENTS 5

const char* ssid = "Voyager1";
const char* password = "lightbar";

IPAddress local_IP(192,168,1,1);
IPAddress gateway(192,168,1,1);
IPAddress subnet(255,255,255,0);

WiFiUDP Udp;
unsigned int localUdpPort = 4210;
char incomingPacket[255];
char replyPacket[] = "Received";



void setup()
{
  Serial.begin(9600);
  Serial.println();

  WiFi.mode(WIFI_AP);
  WiFi.begin();

  Serial.print("Setting soft-AP configuration ... ");
  Serial.println(WiFi.softAPConfig(local_IP, gateway, subnet) ? "Ready" : "Failed!");
  
  Serial.print("Setting soft-AP ... ");
  Serial.println(WiFi.softAP(ssid) ? "Ready" : "Failed!");

  Serial.print("Soft-AP IP address = ");
  Serial.println(WiFi.softAPIP());

  Udp.begin(localUdpPort);
}
 
void loop() {
  int packetSize = Udp.parsePacket();
  if(packetSize){
    int len = Udp.read(incomingPacket, 255);
    if(len > 0){
      incomingPacket[len] = 0;
    }
    Serial.println(incomingPacket);
    Udp.beginPacket(Udp.remoteIP(), Udp.remotePort());
    Udp.write(replyPacket);
    Udp.endPacket();
  }/*
  if(Serial.available()){
    size_t len = Serial.available();
    uint8_t sbuf[len];
    Serial.readBytes(sbuf, len);
    //bello is a broadcast to all clients
    for(i = 0; i < MAX_SRV_CLIENTS; i++){
      if (serverClients[i] && serverClients[i].connected()){
        serverClients[i].write(sbuf, len);
        delay(1);
      }
    }
  }*/
}
