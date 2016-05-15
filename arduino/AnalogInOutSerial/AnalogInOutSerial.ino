
/*
  adapted for cress.space
*/

 #define COUNT_PINS 3 


const int analogInPin[COUNT_PINS]          = {A0, A1, A2 };
const char * chPinDescriptions[COUNT_PINS] = {"Photoresistor", "Photodiode", "Watermark"};

int sensorValue = 0;        // value read from the pot

int doutPin = 8;

void setup() {
  cat 
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);

  pinMode(doutPin, OUTPUT);

  
}

void loop() {
  int i;
  
  digitalWrite(doutPin, HIGH);
  delay(1);
  
  for (i=0; i<COUNT_PINS; i++)
  {
    // read the analog in value:
    sensorValue = analogRead(analogInPin[i]);

    // print the results to the serial monitor:
    Serial.print(chPinDescriptions[i]);
    Serial.print(" = ");
    Serial.print(sensorValue);
    Serial.print("\n");
  }

  Serial.print("\n");

  digitalWrite(doutPin, LOW);

  delay(10000);
}
