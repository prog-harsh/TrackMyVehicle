
#include <FirebaseArduino.h>
#include<ESP8266WiFi.h>
#include<DHT.h>
#include<SoftwareSerial.h>
#include<TinyGPS++.h>

//wifi credentials
const char* ssid="nish";
const char* pswd="40667794";

#define Firebase_HOST "mini-project-5afa0-default-rtdb.Firebaseio.com"      
#define Firebase_AUTH "jKyEIPB5t5wvBCNJwU4iduV7mdE0Mi7ClkqmcdYK"            



//initialize the espclient
WiFiClient wifiClient;

//Gps pin configuration- Neo_6M
static const int TX2_pin=D6;//R11
static const int RX2_pin=D5;//R12
static const uint32_t GPSBAUD= 9600;
String alt_str,locat,updatetime;
float lat_str,lng_str;
TinyGPSPlus gps;
SoftwareSerial ss(RX2_pin,TX2_pin);

long now=millis();
long lastmeasure =0;

void setup_wifi(){
  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.print(ssid);
  WiFi.begin(ssid,pswd);
  while(WiFi.status()!= WL_CONNECTED){
    Serial.print(".");
    delay(500);
  }
  Serial.println();
  Serial.print("Wifi connected to ");
  Serial.println(WiFi.localIP());
}
void displayInfo()
{
  Serial.print(F("Location: "));
   
  if (gps.location.isValid())
  {
    lat_str=float(gps.location.lat());
    lng_str=float(gps.location.lng());
    
    Serial.print(lat_str, 6);
    Serial.print(F(","));
    Serial.print(lng_str, 6);
    Firebase.setFloat("GPS_LAT",lat_str);
    Firebase.setFloat("GPS_LON",lng_str);
    locat="https://www.google.com/maps?q="+String(lat_str)+","+String(lng_str)+"&z=17&hl=en";
    Serial.println("\n"+locat);  
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F("  Date/Time: "));
  if (gps.date.isValid())
  {
    Serial.print(gps.date.month());
    Serial.print(F("/"));
    Serial.print(gps.date.day());
    Serial.print(F("/"));
    Serial.print(gps.date.year());
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.print(F(" "));
  if (gps.time.isValid())
  {
    if (gps.time.hour() < 10) Serial.print(F("0"));
    Serial.print(gps.time.hour());
    Serial.print(F(":"));
    if (gps.time.minute() < 10) Serial.print(F("0"));
    Serial.print(gps.time.minute());
    Serial.print(F(":"));
    if (gps.time.second() < 10) Serial.print(F("0"));
    Serial.print(gps.time.second());
    Serial.print(F("."));
    if (gps.time.centisecond() < 10) Serial.print(F("0"));
    Serial.print(gps.time.centisecond());
    
  }
  else
  {
    Serial.print(F("INVALID"));
  }

  Serial.println();
}


void setup() {
  // put your setup code here, to run once:
   Serial.begin(115200);
  ss.begin(GPSBAUD);
  setup_wifi();
  Firebase.begin(Firebase_HOST,Firebase_AUTH);
  Firebase.setFloat("GPS_LAT",0);
  Firebase.setFloat("GPS_LON",0);
  

}

void loop() {
  // put your main code here, to run repeatedly:
  while (ss.available() > 0)
    if (gps.encode(ss.read()))
      displayInfo();

  if (millis() > 5000 && gps.charsProcessed() < 10)
  {
    Serial.println(F("No GPS detected: check wiring."));
    while(true);
  }
  delay(5000);
}
