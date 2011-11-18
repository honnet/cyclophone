const int CHANNEL = 1;
const int LED_PIN = 11;
const int DYNAMO_PIN = 13;
const int LOOP_SIZE = 4;
const int CTRL = 14;
bool state = HIGH;


void setup()
{
  pinMode(LED_PIN, OUTPUT);
}


void loop()
{
  int speed = getSpeed();
 
  usbMIDI.sendControlChange(CTRL, speed, CHANNEL);

  delay(50);
  digitalWrite(LED_PIN, state=!state);        // toggle LED state
}


int getSpeed()
{
  const int FILT_SIZE = 64;                   // simple average filter
  static int speeds[FILT_SIZE+1]={0};
  int speed=0;

  speeds[FILT_SIZE] = analogRead(DYNAMO_PIN); // 10bits value

  for (int i=0; i<FILT_SIZE; i++)
  {
    speeds[i] = speeds[i+1];                  // shift register
    speed += speeds[i];                       // accumulate
  }
  speed /= (FILT_SIZE*127)/400;               // experimental values
  speed = (speed>127)? 127 : speed;           // saturation
  return (speed);
}

