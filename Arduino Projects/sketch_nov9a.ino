#include <Stepper.h>
const int stepsPerRevolution = 2048;
Stepper myStepper(stepsPerRevolution,8,10,9,11);

long position = 0;
unsigned long previousMillis = 0;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  myStepper.setSpeed(5);
}

void loop() {
  // put your main code here, to run repeatedly:
  unsigned long currentMillis = millis();
  // Serial.print("Set speed to 5 RPM");
  myStepper.setSpeed(5);
  myStepper.step(stepsPerRevolution / 4);
  position += stepsPerRevolution / 4;
  Serial.print(currentMillis);
  Serial.print(",");
  Serial.println(position);
  delay(1000);

  //Serial.print("Increase speed to 15 RPM");
  myStepper.setSpeed(15);
  myStepper.step(stepsPerRevolution / 4);
  position += stepsPerRevolution / 4;
  Serial.print(currentMillis);
  Serial.print(",");
  Serial.println(position);
  delay(1000);
}
