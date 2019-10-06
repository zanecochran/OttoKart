// OttoKart - Autonomous Golf Kart Algorithm and Interface
// Zane Cochran


void setup(){
  
  size(800, 800);
  textAlign(CENTER, CENTER);
  textSize(18);

  if(activeVideo){loadCam();}        // Initialize the Camera
  if(activeLIDAR){loadLIDAR();}      // Initialize the LIDAR 
  if(activeOutput){loadOutput();}    // Initialize the Arduino
  if(activeGPS){loadGPS();}          // Initialize the GPS
  
}

void draw(){
  
  background(0);  
  
  if(activeGPS){drawGPS();}        // Show the GPS Screen
  if(activeLIDAR){drawLIDAR();}    // Show the LIDAR Screen
  if(activeVideo){drawWebcam();}   // Show the Camera Screen
  
  if(activeOutput){
    if(isInterface){userInterface();}  // Show the User Inteface 
    else{drawOutput();}                // Show the Raw Output
    getInput();                        // Get Serial Input from Arduino
  }

  drawGrid();
  
  if(isAvoid){avoid();}            // Run the Avoid (LIDAR) Program
  if(isLocal){local();}            // Run the Local (Camera) Program
  if(isGlobal){global();}          // Run the Global (GPS) Program
  
  if(isScreenCapture){captureScreen();}  // Screen Record the Run
  if(isSafeSteer){steerSafety();}        // Stops Steering if Angle is Exceeded
}



// Draws background and screen dividers
void drawGrid(){
   stroke(128);
   line(width/2, 0, width/2, height);
   line(0, height/2, width, height/2);
}

