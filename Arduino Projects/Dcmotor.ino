int motorpin1 = 2;
int motorpin2 = 3;
int ENApin = 6;
int speed = 50;
void setup() {
  // put your setup code here, to run once:
  pinMode(motorpin1,OUTPUT);
  pinMode(motorpin2,OUTPUT);
  pinMode(ENApin, OUTPUT);

}

void loop() {
  // put your main code here, to run repeatedly:
  digitalWrite(motorpin1,HIGH);
  digitalWrite(motorpin2,LOW);

  analogWrite(ENApin,speed);
  

}
