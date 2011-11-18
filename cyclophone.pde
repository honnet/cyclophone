const int CHANNEL = 1;
const int LED_PIN = 11;
const int BIKE_N = 2;
const int DYNAMO_PIN[BIKE_N] = {13, 14};
const int CTRL[BIKE_N] = {14, 15};
int speed[BIKE_N] = {0};
bool state = HIGH;


void setup()
{
  pinMode(LED_PIN, OUTPUT);
}


void loop()
{
  for (int i=0; i<BIKE_N; i++)
  {
    speed[i] = getSpeed(i);
    if (speed[i] != 0)
      usbMIDI.sendControlChange(CTRL[i], speed[i], CHANNEL);
  }

  delay(30);
  digitalWrite(LED_PIN, state=!state);        // toggle LED state
}


int getSpeed(int bike_n)
{
  const int FILT_SIZE = 32;                   // simple average filter
  static int speeds[BIKE_N][FILT_SIZE+1]={0};
  int speed=0;

  speeds[bike_n][FILT_SIZE] = analogRead(DYNAMO_PIN[bike_n]); // 10bits value

  for (int i=0; i<FILT_SIZE; i++)
  {
    speeds[bike_n][i] = speeds[bike_n][i+1];  // shift register
    speed += speeds[bike_n][i];               // accumulate
  }
  speed /= 100;                               // experimental values
  return (speed>127) ? 127 : speed;           // saturation
}

