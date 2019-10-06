// Output Commands to Arduino Controller
// Zane Cochran

Serial arduino;  // Create object from Serial class

int statusTurn = 0;    // 0 - Stop Turn,  1 - Left Turn,  2 - Right Turn
int statusAccel = 0;   // 0 - Stop Accel, 1 - Accel Slow, 2 - Accel Walk, 3 - Accel Release
int statusBrake = 0;   // 0 - Stop Brake, 1 - Brake Slow, 2 - Brake Walk, 4 - Brake Release
int statusManual = -1;  // 0 - Auto, 1 - Manual

void loadOutput(){
  String[] connections = Serial.list();
  printArray(connections);
  String portName = Serial.list()[whichArduino];
  arduino = new Serial(this, portName, 9600);
}

int steerCounter = 0;            // Counter to Keep Track of Steering

// Gets Serial Input Information from Arduino
void getInput(){
  if (arduino.available() > 0) {
    int val = arduino.read();
    steerCounter = (int)map(val, 60, 80, -10, 10);
  }
}

// Stops Turning if Exceeds Correct Amount
void steerSafety(){
  if (steerCounter > steerAmt || steerCounter < -steerAmt){
    println(steerCounter);
    if(statusManual == 1){sendManual();}  // Enable Computer Control
    sendTurnStop();                       // Stop Steering
  }
}

// Draws Text Output for Debugging
void drawOutput(){
  pushMatrix();
    translate(width/2, 0);  
    text("Turn: ", 50, 50);   if(statusTurn == 0) {text("None", 200, 50);}  if(statusTurn == 1) {text("Left", 200, 50);}  if(statusTurn == 2) {text("Right", 200, 50);}
    text("Accel: ", 50, 100); if(statusAccel == 0){text("None", 200, 100);} if(statusAccel == 1){text("Slow", 200, 100);} if(statusAccel == 2){text("Walk", 200, 100);} if(statusAccel == 3){text("Release", 200, 100);}
    text("Brake: ", 50, 150); if(statusBrake == 0){text("None", 200, 150);} if(statusBrake == 1){text("Slow", 200, 150);} if(statusBrake == 2){text("Walk", 200, 150);} if(statusBrake == 3){text("Release", 200, 150);} if(statusBrake == 4){text("Full", 200, 150);}
    text("Manual: ", 50, 200); if(statusManual == -1){text("Auto", 200, 200);} if(statusManual == 1){text("Manual", 200, 200);}
    text("Counter: ", 50, 250); {text(steerCounter, 200, 250);}
    text("Safe Steer: ", 50, 300); if(isSafeSteer){text("Enabled", 200, 300);} if(!isSafeSteer){text("Disabled", 200, 300);}
  popMatrix();
}

void sendTurnStop()   {arduino.write('z');   println("Sending Stop Turn");  statusTurn = 0;}     // Stop Turn
void sendTurnLeft()   {arduino.write('x');   println("Sending Left Turn");  statusTurn = 1;}     // Left Turn
void sendTurnRight()  {arduino.write('c');   println("Sending Right Turn"); statusTurn = 2;}     // Right Turn
void sendTurnZero()   {arduino.write('=');   println("Zeroing Turn Sensor"); steerCounter = 0;}  // Zero Turn Sensor

void sendAccelStop()    {arduino.write('1');   println("Sending Accel Stop");    statusAccel = 0;}   // Accel Stop
void sendAccelSlow()    {arduino.write('2');   println("Sending Accel Slow");    statusAccel = 1;}   // Accel Slow
void sendAccelWalk()    {arduino.write('3');   println("Sending Accel Walk");    statusAccel = 2;}   // Accel Walk
void sendAccelRelease() {arduino.write('[');   println("Sending Accel Release"); statusAccel = 3;}   // Accel Release

void sendBrakeStop()    {arduino.write('6');   println("Sending Brake Stop");    statusBrake = 0;}    // Brake Stop
void sendBrakeSlow()    {arduino.write('7');   println("Sending Brake Slow");    statusBrake = 1;}    // Brake Slow
void sendBrakeWalk()    {arduino.write('8');   println("Sending Brake Walk");    statusBrake = 2;}    // Brake Walk
void sendBrakeRelease() {arduino.write(']');   println("Sending Brake Release"); statusBrake = 3;}    // Brake Release
void sendBrakeFull()    {arduino.write('0');   println("Sending Brake Full");    statusBrake = 4;}    // Brake Full Brake

void sendManual()       {arduino.write('m');   println("Sending Manual Control"); statusManual = -statusManual;} // Manual Toggle
