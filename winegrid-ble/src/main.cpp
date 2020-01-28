#include <Arduino.h>
#include <picosha2.h>
/*
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleServer.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updates by chegewara
*/

#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>
#include <Update.h>
#include <iostream>
#include <vector>
#include <string.h>
#include <sstream>
#include <cstdio>
#include <ctime>
#include <random>
#include <math.h>


// See the following for generating UUIDs:
// https://www.uuidgenerator.net/
#define UART_UUID           "6E400001-B5A3-F393-E0A9-E50E24DCCA9E" // UART service UUID
#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"
#define CHARACTERISTIC_UUID2 "85964631-7217-4d04-86eb-a4372bf35320"
#define CHARACTERISTIC_UUID3 "e6749247-6351-4eec-ae67-a4645f8b9640"
#define CHARACTERISTIC_UUID4 "83288aaf-51d8-48ad-996a-ab9b512d0508"
#define SERVICE_UUID2 "1889ebd8-dbd1-48fe-a63f-99ad052c6696"
#define CHARACTERISTIC_UUID5 "5d968837-457b-4ac6-8ba7-72d2a217214a"
#define CHARACTERISTIC_UUID6 "4844bf70-5ccd-4006-a46a-e1f31e364033"
#define CHARACTERISTIC_UUID7 "65c7cfdf-ebdc-47d4-ad10-9328a61acf53"
#define CHARACTERISTIC_UUID8 "1cb409af-18b7-4783-b1e0-5b4bd71a33c8"
#define CHARACTERISTIC_UUID_RX "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define CHARACTERISTIC_UUID_TX "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"


//SECURITY PROTOCOL
long int secret;
long int P; //PRIME P
long int G; //PRIME G
long int privateKey;
long int publicKey;
long int publicServer;
long int publicClient;
bool _secret = false;
//primes pool
std::vector<unsigned long> primes;

//UART CHAR
BLECharacteristic *pRtx;
BLECharacteristic *pStx;

//definition of all Characteristics used
BLECharacteristic *pSensor;
BLECharacteristic *pSensor2;
BLECharacteristic *pTime;
BLECharacteristic *pCallBack;
//security service + Characteristics
BLEService *pSecurity;
BLECharacteristic *pPrime1;
BLECharacteristic *pPrime2;
BLECharacteristic *pPublicServer;
BLECharacteristic *pPublicClient;

//initialized random sensor values && [timestamp(not implemented so far)]
float sensor2 = 0.6789;
float sensor1 = 20.0000;
int64_t timestamp;
bool _ready = false;
int i;
std::clock_t start;
double duration;
bool deviceConnected = false;
bool oldDeviceConnected = false;
char secret_p[25];

using namespace std;

void get_primes(unsigned long max){

    char *sieve;
    sieve = new char[max/8+1];
    // Fill sieve with 1  
    memset(sieve, 0xFF, (max/8+1) * sizeof(char));
    for(unsigned long x = 2; x <= max; x++)
        if(sieve[x/8] & (0x01 << (x % 8))){
            primes.push_back(x);
            // Is prime. Mark multiplicates.
            for(unsigned long j = 2*x; j <= max; j += x)
                sieve[j/8] &= ~(0x01 << (j % 8));
        }
    delete[] sieve;
}
//power calculation
long long int power(long long int a,long long  int b, 
                                    long long int P) 
{  
    if (b == 1) 
        return a; 
  
    else
        return ((( long long int)pow(a, b)) % P); 
} 


class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
    deviceConnected = true;
    //generate all primes
    get_primes(30000);
    srand(time(NULL));
    int randomIndex = rand() % primes.size();
    int randomIndex2 = rand() % primes.size();
    P = primes[randomIndex];
    G = primes[randomIndex2];

    char result_p[25];
    int got_len1 = snprintf(result_p, 8, "%ld", P);
    Serial.print("A is: ");
    Serial.print(result_p);

    
    char result_g[25];
    got_len1 = snprintf(result_g, 8, "%ld", G);
    Serial.print("\n");
    Serial.print("B is: ");
    Serial.print(result_g);
    Serial.print("\n");
    pPrime1->setValue(result_p);
    pPrime2->setValue(result_g);

    privateKey =  rand()%4 +1;
    privateKey =  2;
    Serial.print("PRIVATE KEY: ");
    Serial.println(privateKey);
    publicServer = power(G, privateKey, P);
    char publicKey_s[25];
    got_len1 = snprintf(publicKey_s, 8, "%ld", publicServer);
    Serial.print("Public Server Key is: ");
    Serial.println(publicKey_s);
    pPublicServer->setValue(publicKey_s);
    std::vector<unsigned long>().swap(primes);
    
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
      pSensor->setValue("0");
      pSensor2->setValue("0");
      pTime->setValue("0");
      
    }
};

//callback protocol -->
//                  --> Client Write on pCallback "1234567890";
//                  --> Server getSensorValue() && set's Sensors Charactheristics ready to read && notify's Client;
//                  --> Client receives notification and read value from said Charactheristics

//Callback for pCallback
class MyCallbacks: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pCallBack) {
      //Get string wrote to Charactheristics
      start = std::clock();
      std::string value = pCallBack->getValue();
      Serial.print("Some keyword was wrote\n");
      char cstr[value.size() + 1];
	    strcpy(cstr, value.c_str());	// or pass &s[0]
      char pin[25] = {'1','2','3','4','5','6','7','8','9','0'};
      //Check if it's the correct string(Security Reasons)
      int x=10;
      int z=0;    
      do{
        pin[x] = secret_p[z];
        ++x;
        ++z;
      }while(pin[z] != '\0');
      //calculate sha256
      std::string pinStd = std::string(pin);
      std::string hash_hex_str = picosha2::hash256_hex_string(pinStd);
      char pinDebug[hash_hex_str.size() + 1];
	    strcpy(pinDebug, hash_hex_str.c_str());	// or pass &s[0]
    //int got_len1 = snprintf(pinDebug, 8, "%s", pinStd);
       Serial.print(pinDebug);
       Serial.print(cstr);
      //calculate sha256
      int i = 0;
      char pinHalf[19];
      memset( pinHalf, 0x0, 19 );
      for(i; i< 18; i++){
        pinHalf[i] = pinDebug[i];
      }
      Serial.print("\nHalf Pin: ");
      Serial.println(pinHalf);
      if (value == pinHalf){
        //Debug only serial.print
        Serial.println("\n*********\n");
        Serial.print("Correct KEY read\n");
        Serial.println();

        //READ FROM SENSOR 1
        //basically to_string(float sensor1)
        char buf1[25];
        int got_len1 = snprintf(buf1, 8, "%f", sensor1);
        // should never happen, but check nonetheless
        if (got_len1 > sizeof(buf1))
            throw std::invalid_argument("Float is longer than string buffer");
        //Set content of buf1 as value of Charactheristic from Sensor1
        pSensor->setValue(buf1);
        delay(3);
        //debug only
        Serial.printf("Density is %sg/cm^3\n", buf1);
        //READ FROM SENSOR 2
        //basically to_string(float sensor1)
        char buf2[25];
        int got_len2 = snprintf(buf2, 8, "%f", sensor2);
        // should never happen, but check nonetheless
        if (got_len2 > sizeof(buf2))
            throw std::invalid_argument("Float is longer than string buffer");
        //Set content of buf2 as value of Charactheristic from Sensor2
        pSensor2->setValue(buf2);
        delay(3);
        //debug only
        Serial.printf("Temperature is %sº\n", buf2);
        //notify client
        delay(3);
        pCallBack->setValue("XB642981Z");
        //Ready to notify client
        _ready = true;
        i=0;
        //pCallBack->notify(true);
        delay(3);
        //randomize sensor values for next read
        sensor2+=0.1001;
        sensor1-=0.1001;
      }
    }
};

//Reset ble charactheristic value to increase security
//Callback for Sensor 1(Density)
class MyCallbacksSensor1: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pSensor) {
      pSensor->setValue("0");
    }
};
//Reset ble charactheristic value to increase security
//Callback for Sensor 2(Temperature)
class MyCallbacksSensor2: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pSensor2) {
      pSensor2->setValue("0");
    }
};
//Reset ble charactheristic value to increase security
//Callback for TimeStamp
class MyCallbacksTime: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pTime) {
      pTime->setValue("0");
    }
};



//Reset ble charactheristic value to increase security
//Callback for Prime1
class MyCallbacksPrime1: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pPrime1) {
    }
};

//Reset ble charactheristic value to increase security
//Callback for Prime2
class MyCallbacksPrime2: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pPrime2) {
    }
};

//Reset ble charactheristic value to increase security
//Callback for PublicClient
class MyCallbacksPublicClient: public BLECharacteristicCallbacks {
    void onWrite(BLECharacteristic *pPublicClient) {
      publicClient = atol(pPublicClient->getValue().c_str());
      Serial.println(publicClient);
      secret = power(publicClient, privateKey, P);
      int got_len1 = snprintf(secret_p, 8, "%ld", secret);
      Serial.print("Secret is: ");
      Serial.println(secret_p);
    }
};

//Reset ble charactheristic value to increase security
//Callback for PublicServer
class MyCallbacksPublicServer: public BLECharacteristicCallbacks {
    void onRead(BLECharacteristic *pPublicServer) {
    }
};


//void to_String(char &dest, float num){
//  int got_len = snprintf(&dest, 8, "%f", sensor1);
//  // should never happen, but check nonetheless
//  if (got_len > sizeof(&dest))
//      throw std::invalid_argument("Float is longer than string buffer");

//}

void setup() {
  Serial.begin(115200);
  Serial.println("Starting BLE work!");
    
  //device Name(ID)
  BLEDevice::init("d6cb27");
  Serial.println("Device Name: d6cb27");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  //SENSOR SERVICE
  BLEService *pService = pServer->createService(SERVICE_UUID);
  
  //Sensor 1
  pSensor = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID,
                                         BLECharacteristic::PROPERTY_READ
                                       );
  pSensor->setCallbacks(new MyCallbacksSensor1());
  //value initialized at 0 to increse security    
  pSensor->setValue("0");
  
  //Sensor 2
  pSensor2 = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID2,
                                         BLECharacteristic::PROPERTY_READ   
                                       );
  pSensor2->setCallbacks(new MyCallbacksSensor2());
  //value initialized at 0 to increse security    
  pSensor2->setValue("0");
  
  //Timestamp
  pTime = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID3,
                                         BLECharacteristic::PROPERTY_READ   
                                       );
  pTime->setCallbacks(new MyCallbacksTime()); 
  //value initialized at 0 to increse security                                    
  pTime->setValue("0");
  
  //Callback Characteristic to implement Protocol mentioned above(line 93)
  pCallBack = pService->createCharacteristic(
                                         CHARACTERISTIC_UUID4,
                                         BLECharacteristic::PROPERTY_WRITE |
                                         BLECharacteristic::PROPERTY_READ |
                                         BLECharacteristic::PROPERTY_NOTIFY     
                                       );
  pCallBack->setCallbacks(new MyCallbacks());
  pCallBack->addDescriptor(new BLE2902());

  //SECURITY SERVICE
  BLEService *pSecurity = pServer->createService(SERVICE_UUID2);
  //Prime1
  pPrime1 = pSecurity->createCharacteristic(
                                         CHARACTERISTIC_UUID5,
                                         BLECharacteristic::PROPERTY_READ
                                       );
  pPrime1->setCallbacks(new MyCallbacksPrime1());
  //value initialized at 0 to increse security    
  
  //Prime2
  pPrime2 = pSecurity->createCharacteristic(
                                         CHARACTERISTIC_UUID6,
                                         BLECharacteristic::PROPERTY_READ   
                                       );
  pPrime2->setCallbacks(new MyCallbacksPrime1);
  //value initialized at 0 to increse security    
  
  //PublicClient
  pPublicClient = pSecurity->createCharacteristic(
                                         CHARACTERISTIC_UUID7,
                                         BLECharacteristic::PROPERTY_WRITE   
                                       );
  pPublicClient->setCallbacks(new MyCallbacksPublicClient());                                    
 
  
  //PublicServer
  pPublicServer = pSecurity->createCharacteristic(
                                         CHARACTERISTIC_UUID8,
                                         BLECharacteristic::PROPERTY_READ    
                                       );
  pPublicServer->setCallbacks(new MyCallbacksPublicServer());

  //BLE Service Start
  pService->start();
  pSecurity->start();
  // BLEAdvertising *pAdvertising = pServer->getAdvertising();  // this still is working for backward compatibility
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  //BLE Device starts advertising
  BLEDevice::startAdvertising();

  //calculate timestamp(NOT WORKING!!!)
  
}

//implementation of Diffie-Hellman algorithm
void keyEx(){
  P = 23; //generate random prime number
  G = 9; //generate random prime number

  //chose private key
  privateKey = 4; //random number

  // b generated in client and client public key calculated and sent to server

  //server public key 
  publicKey = power(G, privateKey, P);
// Generating the secret key after the exchange of keys
  //secret = power(y, a, P); // Secret key for Alice 

}

void loop() {
  // No main code so far!!!
  if (deviceConnected) {
    Serial.println(_ready);
    Serial.print("Device is connected...\n");
    if(_ready){
      Serial.print("got in\n");
      duration = ( std::clock() - start ) / (double) CLOCKS_PER_SEC;
      char bufT[25];
          int got_len2 = snprintf(bufT, 8, "%f", duration*1000);
          // should never happen, but check nonetheless
          if (got_len2 > sizeof(bufT))
              throw std::invalid_argument("Float is longer than string buffer");
      Serial.print("decoded time to string\n");
      pTime->setValue(bufT);
      Serial.print("time set\n");
      i=2;
      for(;i>=0;i--){
        pCallBack->notify(true);
        if(i==0){_ready=false;}
        Serial.print("Notifying Client...\n");
      }
      Serial.print("end of for\n");
    }
    else{
      Serial.println("Not notifying");
    }
  }
  else{
    Serial.print("Device is NOT connected...\n");
  }
  
  
  delay(2000);
}