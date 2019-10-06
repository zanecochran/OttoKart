// OttoKart - Autonomous Golf Cart
// Zane Cochran

/*  Command List
 *  q - Disable Accelerator     curAccelCommand = 0
 *  w - Accelerator In          curAccelCommand = 1
 *  e - Accelerator Out         curAccelCommand = 2
 *  a - Disable Brake           curBrakeCommand = 0
 *  s - Brake In                curBrakeCommand = 1
 *  d - Brake Out               curBrakeCommand = 2
 *  z - Disable Steering        curSteerCommand = 0
 *  x - Steer Left              curSteerCommand = 1
 *  c - Steer Right             curSteerCommand = 2
 *  1 - Accel 0%   (Stop)
 *  2 - Accel 25%  (Slow)
 *  3 - Accel 50%  (Walk)
 *  4 - Accel 75%  (Run)
 *  5 - Accel 100% (Ludicrous Speed)
 *  5 - Brake 0%
 *  6 - Brake 25%
 *  7 - Brake 50%
 *  8 - Brake 75%
 *  9 - Brake 100%
 *  [ - Release Accel Completely
 *  ] - Release Brake Completely
 *  0 - Zero Out Steering
 */
 
int accelEnable = 2; int accel1 = 3; int accel2 = 4;                        // Accelerator - Motor Controller
int brakeEnable = 5; int brake1 = 6; int brake2 = 7;                        // Brake - Motor Controller
int steerEnable = 8; int steer1 = 9; int steer2 = 10;                       // Steering - Motor Controller
int crtlAccel = 0; int crtlBrake = 1; int crtlLeft = 2; int crtlRight = 3;  // Manual Control Inputs

boolean isManual = false;                                    // Is in manual mode?
boolean lastManual = true;                                   // Last Mode
int readAccel; int readBrake; int readLeft; int readRight;   // AnalogRead Values
int readThresh = 500;                                        // Threshold for AnalogRead values
boolean debugManual = false;                                 // Show raw analog values for manual debugging

int curSteerCommand = 0;  // Current Steering Command        1 - Left , 2 - Right, 3 - Stop
int curAccelCommand = 0;  // Current Accelerating Command    1 - Go   , 2 - Stop
int curBrakeCommand = 0;  // Current Brake Command           1 - Retract   , 2 - Release

int lastSteerCommand = -1;  // Last Steering Command
int lastAccelCommand = -1;  // Last Accelerating Command
int lastBrakeCommand = -1;  // Last Brake Command

int accelCounter = 0;
int accelTargetSpeed = 0;
int accelSpeedVals[] = {0, 300, 400, 500, 600};
int accelDelay = 4;

int brakeCounter = 0;
int brakeTargetSpeed = 0;
int brakeSpeedVals[] = {0, 400, 500, 600, 700};
int brakeDelay = 4;

int steerSensor = A4;       // Steer Sensor is Connected to Pin A4
int steerCounter = 0;       // Tracks the Number of Ticks on the Speed Sensor

boolean showStatus = false; // Show status messages (False by default)


void setup() {
  pinMode(accelEnable, OUTPUT); pinMode(accel1, OUTPUT); pinMode(accel2, OUTPUT);  // Accelerator Controls
  pinMode(brakeEnable, OUTPUT); pinMode(brake1, OUTPUT); pinMode(brake2, OUTPUT);  // Brake Controls
  pinMode(steerEnable, OUTPUT); pinMode(steer1, OUTPUT); pinMode(steer2, OUTPUT);  // Steering Controls
  
  if(showStatus){Serial.begin(9600); delay(1000); Serial.println("System Ready!");}// Serial Communication
  else{Serial.begin(9600); delay(1000);}
}

void loop() {
  steerSense(); // Send Steering Position
  readSerial(); // Look for Serial Command

  if (isManual){
    // Test for Manual Override
    readAccel = analogRead(crtlAccel);
    readBrake = analogRead(crtlBrake);
    readLeft = analogRead(crtlLeft);
    readRight = analogRead(crtlRight);
  
    // If user inputs a manual command
    if (readAccel > 500) {curAccelCommand = 1;} else{curAccelCommand = 2;}
    if (readBrake  > 500) {curBrakeCommand = 1;} else{curBrakeCommand = 2;}
    if (readLeft  > 500 || readRight  > 500){
      if (readLeft  > 500)  {curSteerCommand = 1;}
      if (readRight  > 500) {curSteerCommand = 2;}
    }
    else {curSteerCommand = 0;}    
  }

  // Execute Control Commands if Changed
  if (lastAccelCommand != curAccelCommand) {if (curAccelCommand == 1) {accelIn();} else if (curAccelCommand == 2) {accelOut();} else {accelStop();}}
  if (lastBrakeCommand != curBrakeCommand) {if (curBrakeCommand == 1) {brakeIn();} else if (curBrakeCommand == 2) {brakeOut();} else {brakeStop();}}
  if (lastSteerCommand != curSteerCommand) {if (curSteerCommand == 1) {steerLeft();}else if (curSteerCommand == 2) {steerRight();} else {steerStop();}}

  // Print Current Command Status (If new command has been issued)
  if (lastManual != isManual || lastSteerCommand != curSteerCommand || lastAccelCommand != curAccelCommand || lastBrakeCommand != curBrakeCommand) {
    
    if(showStatus){
      if(isManual && debugManual){Serial.print(readAccel); Serial.print("\t"); Serial.print(readBrake); Serial.print("\t"); Serial.print(readLeft); Serial.print("\t"); Serial.print(readRight); Serial.print("\t");}
  
      Serial.print("System Status: \t Mode: ");
      if (isManual == true) {Serial.print("Manual");}
      else {Serial.print("Serial");}
  
      Serial.print("\t Speed: "); if (accelTargetSpeed == 0){Serial.print("NONE");}if (accelTargetSpeed == 1){Serial.print("SLOW");}if (accelTargetSpeed == 2){Serial.print("WALK");} if (accelTargetSpeed == 3){Serial.print("FAST");} 
      Serial.print("\t Accel: "); if (curAccelCommand == 0) {Serial.print("DIS");} if (curAccelCommand == 1) {Serial.print("IN!");} if (curAccelCommand == 2) {Serial.print("OUT");}
      Serial.print("\t Brake: "); if (curBrakeCommand == 0) {Serial.print("DIS");} if (curBrakeCommand == 1) {Serial.print("IN!");} if (curBrakeCommand == 2) {Serial.print("OUT");}
      Serial.print("\t Steer: "); if (curSteerCommand == 0) {Serial.print("DIS");} if (curSteerCommand == 1) {Serial.print("LEFT");} if (curSteerCommand == 2) {Serial.print("RIGHT");}
      Serial.println();
    }

    // Update Last Commands to Current Commands
    lastAccelCommand = curAccelCommand; lastBrakeCommand = curBrakeCommand; lastSteerCommand = curSteerCommand; lastManual = isManual;
  }

  // Accel Speed Commands
  if(accelCounter < accelSpeedVals[accelTargetSpeed]){accelCounter++; curAccelCommand = 1; delay(accelDelay);}       // Increase Accel
  else if(accelCounter > accelSpeedVals[accelTargetSpeed]){accelCounter--; curAccelCommand = 2; delay(accelDelay);}  // Decrease Accel
  else{curAccelCommand = 0;}                                                                                         // Hold Accel

  // Brake Speed Commands
  if(brakeCounter < brakeSpeedVals[brakeTargetSpeed]){brakeCounter++; curBrakeCommand = 1; delay(brakeDelay);}       // Increase Brake
  else if(brakeCounter > brakeSpeedVals[brakeTargetSpeed]){brakeCounter--; curBrakeCommand = 2; delay(brakeDelay);}  // Decrease Brake
  else{curBrakeCommand = 0;}                                                                                         // Hold Brake

}

void readSerial() {
  while (Serial.available()) { // If data is available to read,
    char val = Serial.read(); // read it and store it in val
    
    if      (val == 'q'){ curAccelCommand = 0;}   // Disable Accel
    else if (val == 'w'){ curAccelCommand = 1;}   // Accel In
    else if (val == 'e'){ curAccelCommand = 2;}   // Accel Out

    else if (val == 'a'){ curBrakeCommand = 0;}   // Disable Brake
    else if (val == 's'){ curBrakeCommand = 1;}   // Brake In
    else if (val == 'd'){ curBrakeCommand = 2;}   // Brake Out
    
    else if (val == 'z'){ curSteerCommand = 0;}   // Disable Steer
    else if (val == 'x'){ curSteerCommand = 1;}   // Steer Left
    else if (val == 'c'){ curSteerCommand = 2;}   // Steer Right
    else if (val == '='){ steerCounter = 0;}      // Zero Out Steer Counter 
   
    else if (val == 'm'){isManual = !isManual;}         // Enable/Disable Manual Mode
    else if (val == 'n'){debugManual = !debugManual;}   // Enable/Disable Debug Manual Mode

    else if (val == '1'){accelTargetSpeed = 0;}   // Accel Speed 0%   (No Accel)
    else if (val == '2'){accelTargetSpeed = 1;}   // Accel Speed 25%  (Slow)
    else if (val == '3'){accelTargetSpeed = 2;}   // Accel Speed 50%  (Walk)
    else if (val == '4'){accelTargetSpeed = 3;}   // Accel Speed 75%  (Run)
    else if (val == '5'){accelTargetSpeed = 4;}   // Accel Speed 100% (Ludicrous Speed)

    else if (val == '6'){brakeTargetSpeed = 0;}   // Brake Speed 0% 
    else if (val == '7'){brakeTargetSpeed = 1;}   // Brake Speed 25% 
    else if (val == '8'){brakeTargetSpeed = 2;}   // Brake Speed 50% 
    else if (val == '9'){brakeTargetSpeed = 3;}   // Brake Speed 75%  
    else if (val == '0'){brakeTargetSpeed = 4;}   // Brake Speed 100% 

    else if (val == '['){accelOut();}   // Accel Release Override
    else if (val == ']'){brakeOut();}   // Brake Release Override 
    
  }
}

// Accellerator Commands
void accelIn(){ digitalWrite(accel1, LOW); digitalWrite(accel2, HIGH); digitalWrite(accelEnable, HIGH);}  // Enable Accellerator
void accelOut(){digitalWrite(accel1, HIGH);digitalWrite(accel2, LOW);  digitalWrite(accelEnable, HIGH);}  // Disable Accellerator
void accelStop(){digitalWrite(accel1, LOW);digitalWrite(accel2, LOW);  digitalWrite(accelEnable, LOW);}   // Disconnect Accellerator

// Brake Commands
void brakeIn(){ digitalWrite(brake1, HIGH); digitalWrite(brake2, LOW); digitalWrite(brakeEnable, HIGH);}  // Enable Brake
void brakeOut(){digitalWrite(brake1, LOW);digitalWrite(brake2, HIGH);  digitalWrite(brakeEnable, HIGH);}  // Disable Brake
void brakeStop(){digitalWrite(brake1, LOW);digitalWrite(brake2, LOW);  digitalWrite(brakeEnable, LOW);}   // Disconnect Brake

// Steering Commands
void steerLeft() { digitalWrite(steer1, LOW);  digitalWrite(steer2, HIGH); digitalWrite(steerEnable, HIGH);}  // Steer Left
void steerRight() {digitalWrite(steer1, HIGH); digitalWrite(steer2, LOW);  digitalWrite(steerEnable, HIGH);}  // Steer Right
void steerStop() { digitalWrite(steer1, LOW);  digitalWrite(steer2, LOW);  digitalWrite(steerEnable, LOW);}   // Disconnect Steering

// Steering Sensor
int lastSteer = 0;
int curSteer = 0;

void steerSense(){
  int steerRaw = analogRead(steerSensor);
  if(steerRaw > 512){curSteer = 0;}    // No Magnet
  else{curSteer = 1;}                  // Is Magnet

  if (curSteer != lastSteer){
    if (curSteerCommand == 1){steerCounter--;}  // Turning Left
    if (curSteerCommand == 2){steerCounter++;}  // Turning Right
    int adjustCounter = map(steerCounter, -10, 10, 60, 80);
    Serial.write(adjustCounter);
    lastSteer = curSteer;
  }
}
