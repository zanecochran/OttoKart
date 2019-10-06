// Customizable Settings
// Update these settings to get your computer connected to the system

boolean activeLIDAR = false;  // Is LIDAR plugged in?
boolean activeVideo = false;  // Is webcam plugged in?
boolean activeOutput = true; // Is Arduino plugged in?
boolean activeGPS = false;    // Is GPS plugged in?

// COM Port Settings
int whichCam = 18;      // Which camera to connect to (default 3, active 18) Resolution 640x360, 30FPS
int whichArduino = 7;   // Serial Connection Port for Arduino (usually 9)
int whichGPS = 7;      // Which Serial Connection Port for GPS (Usually 9)
String lidarPort = "/dev/cu.SLAB_USBtoUART"; // Name of LIDAR port on computer

int controlOffset = 0;       // Delay between commands (lower sends more often)
int steerAmt = 5;            // Amount to allow the OttoKart to steer (Max is 7 before physical damage occurs)
boolean isSafeSteer = true;  // Enable Safety Steer




