const int thermistorPin = A0;  // Pinul la care este conectat termistorul
const float BETA = 3950;       // Coeficientul Beta al termistorului
const int SERIES_RESISTOR = 10000; // Valoarea rezistorului în serie (10kΩ)
const int NOMINAL_TEMPERATURE = 25; // Temperatură nominală în °C
const int NOMINAL_RESISTANCE = 10000; // Rezistență nominală la 25°C
void setup() {
  Serial.begin(9600);
}

void loop() {
  int analogValue = analogRead(thermistorPin);
  float resistance = SERIES_RESISTOR / (1023.0 / analogValue - 1);
  float temperatureK = 1 / (1.0 / (NOMINAL_TEMPERATURE + 273.15) + 1.0 / BETA * log(resistance / NOMINAL_RESISTANCE));
  float temperatureC = temperatureK - 273.15;

  // Transmite timpul și temperatura prin Serial
  Serial.print(millis() / 1000.0); // Timpul în secunde
  Serial.print(",");
  Serial.println(temperatureC);

  delay(1000);
}
