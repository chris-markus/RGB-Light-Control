#include <SoftwareSerial.h>
#include <stdlib.h>

//color vars:
int r;
int g;
int b;

//pins:
const int R_PIN = 9;
const int G_PIN = 10;
const int B_PIN = 11;
const int V_PIN = A1;
const int RX_PIN = 8;
const int TX_PIN = 7;
const int led = LED_BUILTIN;
const int PACKET_LENGTH = 9;
const int BAUD_RATE = 9600;

bool returnBattery = false;

bool lowVolt = false;

int incomingByte = 0;

double cutoffVoltage = 6.3;

//char arrays
char rawData[9];
char color[6];
char fadeTime[3];

//setup software serial:
SoftwareSerial wifiInterface(RX_PIN, TX_PIN); // RX, TX

void setup() {
  
  //set pinmodes:
  pinMode(R_PIN, OUTPUT);
  pinMode(G_PIN, OUTPUT);
  pinMode(B_PIN, OUTPUT);
  pinMode(V_PIN, INPUT);
  pinMode(RX_PIN, INPUT);
  pinMode(TX_PIN, OUTPUT);
  pinMode(led, OUTPUT);

  //avoid LED flicker on video by raising PWM rate
  TCCR1B = (TCCR1B & 0b11111000 | 0x01);
  TCCR2B = (TCCR2B & 0b11111000 | 0x01);

  //start serial connections:
  Serial.begin(9600);
  wifiInterface.begin(BAUD_RATE);

  delay(20);
  wifiInterface.print("test");

  //let the user know we're ready
  startupAnim();
}

void loop() {
  // put your main code here, to run repeatedly:
  if(returnBattery){
    sendBatteryInfo(checkVoltage());
    returnBattery = false;
  }
  if(readColor()){
    int red, green, blue;
    double fadeTimeDouble = getFadeTime();
    if(hexToInts(&red, &green, &blue, color) && fadeTimeDouble == 0.0){
      snapTo(red, green, blue);
    }
    else{
      fadeTo(red, green, blue, (long)(fadeTimeDouble * 1000.0));
    }
  }
}

boolean readColor(){
  int dataCounter = 0;
  char incomingByte;
  bool stop = false;
  while(!stop){
    checkVoltage();
    if(wifiInterface.available()){
      incomingByte = wifiInterface.read();
      if(incomingByte == 10){
        if(((dataCounter - 1) == PACKET_LENGTH) && verifyColor()){
          for(int i=0; i<3; i++){
            fadeTime[i] = rawData[i];
          }
          for(int i=3; i<PACKET_LENGTH; i++){
            color[i-3] = rawData[i];
          }
          return true;
        }
        else{
          return false;
        }
      }
      else{
        rawData[dataCounter] = incomingByte;
        dataCounter ++;
        if(dataCounter > PACKET_LENGTH + 1){
          wifiInterface.flush();
          return false;
        }
      }
    }
  }
}

void sendBatteryInfo(double volt){
  wifiInterface.println(volt);
}

void startupAnim(){
  int del = 1;
  for(int o = 0; o < 2; o++){
    for(int i = 0; i<255; i++){
      analogWrite(G_PIN, i);
      delay(del);
    }
    for(int i=255;i>=0;i--){
      analogWrite(G_PIN, i);
      delay(del);
    }
  }
}

void errorAnim(){
  int del = 300;
  for(int i=0;i<3;i++){
    analogWrite(G_PIN, 0);
    analogWrite(B_PIN, 0);
    analogWrite(R_PIN, 255);
    delay(del);
    analogWrite(G_PIN, g);
    analogWrite(B_PIN, b);
    analogWrite(R_PIN, r);
    delay(del);
  }
}

void fadeTo(int red, int green, int blue, long duration){
  int steps = abs(r - red);
  int gSteps = green - g;
  int rSteps = red - r;
  int bSteps = blue - b;
  double rDub = (double)r;
  double gDub = (double)g;
  double bDub = (double)b;
  if(abs(gSteps) > steps){
    steps = abs(gSteps);
  }
  if(abs(bSteps) > steps){
    steps = abs(bSteps);
  }
  int del = abs(duration / steps);
  for(int i=0; i<steps; i++){
    checkVoltage();
    rDub += (((double)rSteps)/((double)steps));
    gDub += (((double)gSteps)/((double)steps));
    bDub += (((double)bSteps)/((double)steps));
    r = (int)(floor(rDub));
    g = (int)(floor(gDub));
    b = (int)(floor(bDub));
    writeColor();
    delay(del);
  }
  //make sure we actually got to the right color:
  r = red;
  g = green;
  b = blue;
  writeColor();
}

void writeColor(){
  if(!lowVolt){
    //Serial.print(r); Serial.print(", "); Serial.print(g); Serial.print(", "); Serial.println(b);
    analogWrite(R_PIN, r);
    analogWrite(G_PIN, g);
    analogWrite(B_PIN, b);
  }
  else{
    analogWrite(R_PIN, 0);
    analogWrite(G_PIN, 0);
    analogWrite(B_PIN, 0);
  }
}

void snapTo(int red, int green, int blue){
  r = red;
  g = green;
  b = blue;
  writeColor();
}

double getFadeTime(){
  int fadeTemp;
  double fadeSec = 0.0;
  sscanf(fadeTime, "%03x", &fadeTemp);
  fadeSec = fadeTemp / 10.0;
  //Serial.println(fadeSec);
  return fadeSec;
}

double checkVoltage(){
  double voltage = 2 * (5.0 / 1023.0) * analogRead(V_PIN);
  if(voltage < cutoffVoltage){
    lowVolt = true;
    r = 0;
    g = 0;
    b = 0;
    writeColor();
    digitalWrite(led, HIGH);
    //delay forever:
    delay(9999999999999999);
  }
  return voltage;
}

boolean verifyColor(){
  //Serial.print(rawData);
  char match[] = {'b','a','t','t','l','e','v','e','l'};
  boolean tf = true;
  for(int i=0; i<PACKET_LENGTH; i++){
    if(match[i] != rawData[i]){
      tf = false;
    }
  }
  if(tf){
    returnBattery = true;
    return false;
  }
  for(int i=0; i<PACKET_LENGTH; i++){
    if(!((rawData[i] >= '0' && rawData[i] <= '9') || (rawData[i] >= 'a' && rawData[i] <= 'f'))){
      return false;
    }
  }
  return true;
}

boolean hexToInts(int* redP, int* greenP, int* blueP, char* inColor){
  int tempR, tempG, tempB;
  sscanf(color, "%02x%02x%02x", &tempR, &tempG, &tempB);
  if(tempR >= 0 && tempR <= 255 &&
     tempG >= 0 && tempG <= 255 &&
     tempB >= 0 && tempB <= 255){ 
    *redP = tempR;
    *greenP = tempG;
    *blueP = tempB;
    return true;
  }
  else{
    return false;
  }
}
