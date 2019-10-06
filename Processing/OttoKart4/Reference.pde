/*
    OttoKart Reference Guide
    List of Available Functions and Data Structures

    GPS 
      ArrayList<PVector> GPSCoords;           // ArrayList of Historical GPS Locations
        EXAMPLES:
          float curLat = GPSCoords.get(GPSCoords.size() - 1).y;  // Current Latitude Position
          float curLon = GPSCoords.get(GPSCoords.size() - 1).x;  // Current Longitude Position
          PVector p0 = GPSCoords.get(0);                         // PVector of 1st GPS Coordinate in ArrayList
          
      ArrayList<PVector> waypointStraight;    // Straight Trail GPS Navigation (Used for Objective B1 & B2)
      ArrayList<PVector> waypointCurved;      // Curved Trail GPS Navigation (Used for Objective B3)
      ArrayList<PVector> waypointSingle;      // Single Point GPS Navigation (Used for Objective C1)
      ArrayList<PVector> waypointMultiple;    // Multi Point GPS Navigation (Used for Objective C2)

      float bearing(PVector p1, PVector p2)   // Returns the bearing between two Points, p1 (Current Coordinate) and p2 (Previous coordinate)
      float distance(PVector p1, PVector p2)  // Returns the distance (in meters) between two Points, p1 and p2
      convertGPS(PVector p)                   // Returns a PVector with converted lat/lon coordinates into X/Y coordinates
    
    LIDAR
      ArrayList<PVector> lidarContacts;      // ArrayList of PVector contact points from LIDAR
        EXAMPLES:
          float x = lidarContacts.get(0).x   // X position of first LIDAR contact point
          float y = lidarContacts.get(0).y   // Y position of first LIDAR contact point
          float z = lidarContacts.get(0).z   // Distance of first LIDAR contact point (in millimeters)
       
    Webcam
      PImage cam                // Pixel array of raw camera input (640x360, 30FPS)
      PImage reducedVideo       // Reduced and squashed pixel array of raw camera input (80x80)
      PImage enhancedVideo      // Pixel array of enhanced video. Modified pixels should be stored here
    
      void colorViewer()        // Outputs the RGB values of the pixel located at mouseX and mouseY (Toggle with 'd' key)
    
      Screen Capture
        Press V to Start/Stop Screen Capture for Documentation
        This will create a folder of images inside the Processing sketch folder (Go to Sketch->Show Sketch Folder to locate)
        Use the Movie Maker Tool (Go to Tools->Movie Maker) to create a .mov file from the images. Select "Same Size as Originals" from Options
    
    Output to Arduino
      sendTurnLeft()     // Left Turn      - Begins turning wheel left
      sendTurnRight()    // Right Turn     - Begins turning wheel right
      sendTurnStop()     // Stop Turn      - Stops turning the wheel
      
      sendAccelStop()    // Accel Stop     - Moves Accelerator to 0% Position
      sendAccelSlow()    // Accel Slow     - Moves Accelerator to 25% Position
      sendAccelWalk()    // Accel Walk     - Moves Accelerator to 50% Position
      sendAccelRelease() // Accel Release  - Continually Moves Accelerator to 0% Position
      
      sendBrakeStop()    // Brake Stop     - Moves Brake to 0% Position
      sendBrakeSlow()    // Brake Slow     - Moves Brake to 25% Position
      sendBrakeWalk()    // Brake Walk     - Moves Brake to 50% Position
      sendBrakeRelease() // Brake Release  - Continually Moves Brake to 0% Position
      
      statusTurn         // 0 - Stop Turn     1 - Left Turn      2 - Right Turn
      statusAccel        // 0 - Accel Stop    1 - Accel Slow     2 - Accel Walk    3 - Accel Release
      statusBrake        // 0 - Brake Stop    1 - Brake Slow     2 - Brake Walk    3 - Brake Release    4 - Brake Full
      statusManual       // true - Manual On  false - Manual Off

*/
