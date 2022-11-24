// Includes the Servo library
#include <Servo.h>.

#define GO true
#define NO_GO false
// Defines Tirg and Echo pins of the Ultrasonic Sensor
const int TRIG_PIN = 10;
const int ECHO_PIN = 11;
const char VCC_MOTOR_PIN = 12;
const char VCC_SENSOR = 13;

// Variables for the duration and the distance
long duration; 
int distance;

bool flag = GO;

Servo servo; // Creates a servo object for controlling the servo motor

void setup() 
{
  pinMode(TRIG_PIN, OUTPUT); // Sets the trigPin as an Output
  pinMode(VCC_MOTOR_PIN, OUTPUT);
  pinMode(VCC_SENSOR, OUTPUT);

  digitalWrite(VCC_MOTOR_PIN,HIGH);
  digitalWrite(VCC_SENSOR, HIGH);

  pinMode(ECHO_PIN, INPUT); // Sets the echoPin as an Input

  Serial.begin(9600);
  servo.attach(12); // Defines on which pin is the servo motor attached

  //attachInterrupt(uint8_t interruptNum, void (*userFunc)(void), int mode)
}
void loop() {
  // rotates the servo motor from 15 to 165 degrees

  if(flag)
  {
    for(int i=15;(i<=165);i++)
    {  
      servo.write(i);

      delay(30);

      distance = calculateDistance();// Calls a function for calculating the distance measured by the Ultrasonic sensor for each degree

      Serial.print(i); // Sends the current degree into the Serial Port
      Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing

      Serial.print(distance); // Sends the distance value into the Serial Port
      Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
    }
  // Repeats the previous lines from 165 to 15 degrees
    for(int i=165;(i>15);i--)
    {  
      servo.write(i);
      
      delay(30);

      distance = calculateDistance();

      Serial.print(i);
      Serial.print(",");

      Serial.print(distance);
      Serial.print(".");
    }
  }
}
/*
void serialEvent()
{
  switch (Serial.read()) {
  case 'g':
    flag = GO;
    break;
  case 'e':
    flag = NO_GO;
    break;
  }
}*/
// Function for calculating the distance measured by the Ultrasonic sensor
int calculateDistance(){ 
  
  digitalWrite(TRIG_PIN, LOW); 
  delayMicroseconds(2);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(TRIG_PIN, HIGH); 
  //delayMicroseconds();
  delay(10);
  digitalWrite(TRIG_PIN, LOW);
  duration = pulseIn(ECHO_PIN, HIGH); // returns the sound wave travel time in ms
  distance= duration*0.034/2; // Calculation of the distanz
  return distance;
}
