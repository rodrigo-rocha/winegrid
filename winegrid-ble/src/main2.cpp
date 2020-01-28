//#include <Arduino.h>
/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updates by chegewara
*/
/*
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <iostream>
#include <string>
#include <sstream>
#include <stdint.h>
#include <sys/time.h>

// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID2 "85964631-7217-4d04-86eb-a4372bf35320"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

BLECharacteristic *pSensor2;
BLECharacteristic *pSensor;
float sensor2 = 0.6789;
float sensor1 = 20.0000;
int64_t timestamp;
bool deviceConnected = false;
bool oldDeviceConnected = false;
class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");

  BLEDevice::init("d6cb27");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);
  //Sensor 1
  pSensor = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ
                                       );
  char buf[25];
  int got_len = snprintf(buf, 8, "%f", sensor1);
  // should never happen, but check nonetheless
  if (got_len > sizeof(buf))
      throw std::invalid_argument("Float is longer than string buffer");
  pSensor->setValue(buf);
  //Sensor 2
  pSensor2 = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID2,
                                         BLECharacteristic::PROPERTY_READ     
                                       );
  
  char buf2[25];
  int got_len2 = snprintf(buf2, 8, "%f", sensor2);
  // should never happen, but check nonetheless
  if (got_len2 > sizeof(buf2))
      throw std::invalid_argument("Float is longer than string buffer");
  pSensor2->setValue(buf2);
  
  pService->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  //pAdvertising->addServiceUUID(SERVICE2_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
  struct timeval tp;
  gettimeofday(&tp, NULL);
  int64_t ms = tp.tv_sec * 1000 + tp.tv_usec / 1000;
  Serial.println("Characteristic defined! Now you can read it in your phone!");
  
  Serial.println("Timestamp " + ms);
}

void loop() {
  if (deviceConnected) {
    Serial.print("\nDevice is connected...\n");
        }
  else{
    Serial.print("\nDevice is NOT connected...\n");
  }
  // put your main code here, to run repeatedly:
  char buf2[25];
  int got_len2 = snprintf(buf2, 8, "%f", sensor2);
  // should never happen, but check nonetheless
  if (got_len2 > sizeof(buf2))
      throw std::invalid_argument("Float is longer than string buffer");
  pSensor2->setValue(buf2);
  //Serial.printf("Temperature is %sº\n", buf2);
  char buf1[25];
  got_len2 = snprintf(buf1, 8, "%f", sensor1);
  // should never happen, but check nonetheless
  if (got_len2 > sizeof(buf1))
      throw std::invalid_argument("Float is longer than string buffer");
  pSensor->setValue(buf1);
  //Serial.printf("Density is %sg/cm^3\n", buf1);
  delay(1000);
  sensor2+=0.1001;
  sensor1-=0.1001;
}
*/
