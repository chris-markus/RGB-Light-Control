#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! run 'make menuconfig to enable'
#endif

BluetoothSerial SerialBT;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  delay(5000);
  Serial.println("Starting..");
  SerialBT.begin("ESP32");
  Serial.println("Started");

}

void loop() {
  // put your main code here, to run repeatedly:
  if(Serial.available()){
    SerialBT.write(Serial.read());
  }
  if(SerialBT.available()){
    Serial.write(SerialBT.read());
  }
  delay(20);
}
