// Keyboard Controls
// Use these commands to control the system

void keyPressed(){
  switch(key){
    // System Controls
    case 'q': exit(); break;                                                 // Quits the Program
    case '1': isAvoid = !isAvoid;   println("Avoid: " + isAvoid);            break; // Toggles the Avoid Function
    case '2': isLocal = !isLocal;   println("Local: " + isLocal);            break; // Toggles the Local Function
    case '3': isGlobal = !isGlobal; println("Global: " + isGlobal);          break; // Toggles the Global Function
    case '4': isInterface = !isInterface; println("Interface: " + isGlobal); break; // Toggles the Global Function
    
    // GPS Controls
    case 'w': clearGPS();  break;    // Clears Historical Positions
    
    case 'e': whichPos = 0;  break;  // Show No Position
    case 'r': whichPos = 1;  break;  // Show Current Position
    case 't': whichPos = 2;  break;  // Show Historical Positions
    
    case 'y': whichMap = 0;  break;  // Show No Waypoints
    case 'u': whichMap = 1;  break;  // Show Straight Path Waypoints
    case 'i': whichMap = 2;  break;  // Show Curved Path Waypoints
    case 'o': whichMap = 3;  break;  // Show Single Point Waypoints
    case 'p': whichMap = 4;  break;  // Show Multipoint Waypoints
    
    // LIDAR Controls
    
    
    // Output Controls
    case ',': sendAccelRelease(); delay(3000); sendBrakeRelease(); break; // Full Release
    case '.': sendAccelStop(); sendBrakeStop(); sendTurnStop(); break;    // Full Stop
    
    case 'z': sendTurnLeft();      break;  // Left Turn
    case 'x': sendTurnRight();     break;  // Right Turn
    case 'c': sendTurnStop();      break;  // Stop Turn
    case '=': sendTurnZero();      break;  // Zero Turn Sensor
    case '+': isSafeSteer = !isSafeSteer;  break;  // Toggle Safe Steer

    case 'v': sendAccelStop();     break;  // Accel Stop
    case 'b': sendAccelSlow();     break;  // Accel Slow
    case 'n': sendAccelWalk();     break;  // Accel Walk
    case 'm': sendAccelRelease();  break;  // Accel Release

    case 'l': sendBrakeStop();     break;  // Brake Stop
    case 'k': sendBrakeSlow();     break;  // Brake Slow
    case 'j': sendBrakeWalk();     break;  // Brake Walk
    case 'h': sendBrakeRelease();  break;  // Brake Release 
    case ';': sendBrakeFull();     break;  // Brake Full 

    case 'g': sendManual();        break;  // Toggle Manual Control
    
    // Web Cam & Video Recording
    case 'a': isScreenCapture = !isScreenCapture; if(isScreenCapture){println("Recording...");} else{println("Not Recording"); isScreenInit = false;} break;
    case 's': showEnhanced = !showEnhanced; break;  // Toggle Unprocessed Image vs. Processed Image
    case 'd': showPicker = !showPicker; break;    // Toggle Color Picker
    
    case CODED:
      if(keyCode == UP){}
      if(keyCode == DOWN){}
      if(keyCode == LEFT){}
      if(keyCode == RIGHT){}
      break;
  }
}
