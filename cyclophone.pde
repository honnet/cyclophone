const int CHANNEL = 1;
const int LED_PIN = 11;
const int DYNAMO_PIN = 0; // TODO : find the real one !
const int DRUMS_N = 3;
const int DRUMS[DRUMS_N] = {42, 43, 44};
const bool TRACK[DRUMS_N][LOOP_SIZE] = 
{
  {1, 1, 1, 1}, // shirley
  {1, 0, 0, 0}, // kick
  {0, 0, 1, 0}  // hit hat
};
int speed, loop_cnt=0;
bool state = HIGH;


void setup()
{
  pinMode(LED_PIN, OUTPUT);
}


void loop()
{
  speed = analogRead(DYNAMO_PIN)<<1; // 0 => 511

  if (speed > 0)
  {
    for (int i=0; i<DRUMS_N; i++) // instrument loop
    {
      usbMIDI.sendNoteOff(DRUMS[i], 0, CHANNEL); // switch all off (TODO improve)

      if (TRACK[i][loop_cnt])
        usbMIDI.sendNoteOn(DRUMS[i], 127, CHANNEL);
    }

    if (loop_cnt < LOOP_SIZE)
      ++loop_cnt; // loop counter
    else 
      loop_cnt = 0;

    delay(571 - speed);
    // Explanation, here is what we want:
    //  - delay(60)  if speed = 511
    //  - delay(570) if speed = 1
    // ...the delay is thus: f(x) = -x + 571
  }
  else
    delay(5);
  
  digitalWrite(LED_PIN, state=!state); // toggle LED state
}

