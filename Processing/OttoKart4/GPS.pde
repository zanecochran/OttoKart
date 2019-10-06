// GPS Decoder - Interprets the incoming GPS Codes from Serial GPS
// Zane Cochran


import processing.serial.*;
Serial gps;                    // Create object from Serial class
String gpsInput = "";          // Input from GPS Sensor
PImage berryMap;               // Image of Berry Campus

float lonMin = -85.195;        // Minimum Longitude   (X Coord)
float lonMax = -85.185;        // Maxiumum Longitude  (X Coord)
float latMin = 34.294;         // Minimum Latitude    (Y Coord)
float latMax = 34.284;         // Maxiumum Latitude   (Y Coord)

ArrayList<PVector> GPSCoords;  // ArrayList of Current 
ArrayList<PVector> waypointStraight;    // Straight Trail GPS Navigation
ArrayList<PVector> waypointCurved;      // Curved Trail GPS Navigation
ArrayList<PVector> waypointSingle;      // Single Point GPS Navigation
ArrayList<PVector> waypointMultiple;    // Multi Point GPS Navigation

int whichMap = 0;  // Show which set of waypoints to show. 0 - None, 1 - Straight, 2 - Curved, 3 - Single Point, 4 - Multipoint
int whichPos = 0;  // Show which set of positions to show. 0 - None, 1 - Current, 2 - Historical

// Load the GPS Sensor
void loadGPS(){
  //printArray(Serial.list());                                // Shows Serial Connection List
  gps = new Serial(this, Serial.list()[whichGPS], 9600);    // Connects to GPS Sensor
  
  berryMap = loadImage("berryMap.png");                     // Loads Map of Berry
  GPSCoords = new ArrayList<PVector>();                     // Initializes GPS Coord ArrayList
  initWaypoints();                                          // Initializes Waypoint ArrayLists
}

// Draw the Map with GPS Locations
void drawGPS(){  
  getGPSCoords();  // Gets GPS Coordinate Message from Sensor
  
  // Draws the GPS Data
  pushMatrix();
    translate(width/2, height/2);
    image(berryMap, 0, 0, width/2, height/2);
    
    if(GPSCoords.size() > 0){fill(0, 255, 0); ellipse(350, 50, 25, 25);}
    else{fill(255, 0, 0); ellipse(350, 50, 25, 25);}
    fill(255);

    switch(whichPos){
      case 0: break;                    // Show No Position
      case 1: drawPosCurrent(); break;  // Show Current Position Only
      case 2: drawPosHistory(); break;  // Show Historical Positions
    }
    
    switch(whichMap){
      case 0: break;                                   // Show No Waypoints
      case 1: drawWaypoints(waypointStraight); break;  // Show Straight Path Waypoints
      case 2: drawWaypoints(waypointCurved); break;    // Show Curved Path Waypoints
      case 3: drawWaypoints(waypointSingle); break;    // Show Single Point Waypoints
      case 4: drawWaypoints(waypointMultiple); break;  // Show Multipoint Waypoints
    }  
    
  popMatrix();  
}

// Clears Historical GPS Coordinates
void clearGPS(){GPSCoords = new ArrayList<PVector>();}

// Gets the latest GPS Coordinate Message, Decodes, and Saves to ArrayList
void getGPSCoords(){
  while (gps.available() > 0) {
    String inBuffer = gps.readString();   
    if (inBuffer != null) {
      String[] list = split(inBuffer, ',');
      if(list[0].equals("$GPRMC") && list.length > 5 && list[3].length() > 0 && list[5].length() > 0){
        float latDeg = float(list[3].substring(0, 2));
        float latDec = float(list[3].substring(2)) / 60;
        float finalLat = latDeg + latDec;
        if (list[4].equals("S")){finalLat = -finalLat;}

        float lonDeg = float(list[5].substring(0, 3));
        float lonDec = float(list[5].substring(3)) / 60;
        float finalLon = lonDeg + lonDec;
        if (list[6].equals("W")){finalLon = -finalLon;}

        //println(finalLon + ", " + finalLat);
        PVector p = new PVector(finalLon, finalLat);
        GPSCoords.add(p);
      }
    }
  }  
}

// Draws the Current Position
void drawPosCurrent(){
  if(GPSCoords.size() > 0){
    PVector p = GPSCoords.get(GPSCoords.size() - 1);
    fill(0, 255, 0);
    noStroke();
    float x = map(p.x, lonMin, lonMax, 0, width/2);
    float y = map(p.y, latMin, latMax, 0, height/2);
    ellipse(x, y, 5, 5);
  }
  else{println("No GPS Data...");}
}

// Draws the Historical Position
void drawPosHistory(){
  for (int i = 0; i < GPSCoords.size(); i++){
    PVector p = GPSCoords.get(i);
    fill(0, 0, 255);
    noStroke();
    float x = map(p.x, lonMin, lonMax, 0, width/2);
    float y = map(p.y, latMin, latMax, 0, height/2);
    ellipse(x, y, 5, 5);
  }
}
// Draw Waypoints of Given ArrayList
void drawWaypoints(ArrayList<PVector> wp){
  for (int i = 0; i <  wp.size(); i++){
    PVector p = wp.get(i);
    fill(255, 0, 0);
    noStroke();
    float x = map(p.x, lonMin, lonMax, 0, width/2);
    float y = map(p.y, latMin, latMax, 0, height/2);
    ellipse(x, y, 5, 5);
  }
}

// Initialize GPS Waypoints for Challenges
void initWaypoints(){
  waypointStraight = new ArrayList<PVector>();
  waypointCurved =   new ArrayList<PVector>();
  waypointSingle =   new ArrayList<PVector>();
  waypointMultiple = new ArrayList<PVector>();
  
  PVector t1 = new PVector(-85.193744, 34.290259); waypointCurved.add(t1);
  PVector t2 = new PVector(-85.190958, 34.289986); waypointCurved.add(t2);

  PVector c1 = new PVector(-85.191052, 34.291467); waypointStraight.add(c1);
  PVector c2 = new PVector(-85.191025, 34.292913); waypointStraight.add(c2);
  
  PVector s1 = new PVector(-85.192751, 34.288866); waypointSingle.add(s1);
  PVector s2 = new PVector(-85.192759, 34.287613); waypointSingle.add(s2);

  PVector m1 = new PVector(-85.193229, 34.288847); waypointMultiple.add(m1);
  PVector m2 = new PVector(-85.193154, 34.288609); waypointMultiple.add(m2);
  PVector m3 = new PVector(-85.193101, 34.288503); waypointMultiple.add(m3);
  PVector m4 = new PVector(-85.193067, 34.288377); waypointMultiple.add(m4);
  PVector m5 = new PVector(-85.193048, 34.288225); waypointMultiple.add(m5);
  PVector m6 = new PVector(-85.193049, 34.288064); waypointMultiple.add(m6);
  PVector m7 = new PVector(-85.192901, 34.288053); waypointMultiple.add(m7);
  PVector m8 = new PVector(-85.192774, 34.288055); waypointMultiple.add(m8);
  PVector m9 = new PVector(-85.192754, 34.287922); waypointMultiple.add(m9);
  PVector m10 = new PVector(-85.192759, 34.287758); waypointMultiple.add(m10);
  PVector m11 = new PVector(-85.192756, 34.287588); waypointMultiple.add(m11);
  PVector m12 = new PVector(-85.192666, 34.287523); waypointMultiple.add(m12);
  PVector m13 = new PVector(-85.192505, 34.287519); waypointMultiple.add(m13);
  PVector m14 = new PVector(-85.192756, 34.287588); waypointMultiple.add(m14);
  PVector m15 = new PVector(-85.192486, 34.287885); waypointMultiple.add(m15);
  PVector m16 = new PVector(-85.192492, 34.288330); waypointMultiple.add(m16);
  PVector m17 = new PVector(-85.192485, 34.288695); waypointMultiple.add(m17);
  PVector m18 = new PVector(-85.192495, 34.288840); waypointMultiple.add(m18);
  PVector m19 = new PVector(-85.192850, 34.288865); waypointMultiple.add(m19);
  PVector m20 = new PVector(-85.193222, 34.288860); waypointMultiple.add(m20);
}

// Returns the bearing between two Points, p1 and p2 (p1 - new coordinate, p2, old coordinate)
float bearing(PVector p1, PVector p2){
  float lat1 = p1.y; float lon1 = p1.x;
  float lat2 = p2.y; float lon2 = p2.x;
  
  float dLat = radians(lat2-lat1);
  float dLon = radians(lon2-lon1);
  
  float y = sin(dLon) * cos(radians(lat2));
  float x = cos(radians(lat1))*sin(radians(lat2)) - sin(radians(lat1))*cos(radians(lat2))*cos(dLon);
  float brng = degrees(atan2(y, x));
  float bearing = map(brng,-180,180,360,0);
  
  return bearing;
}

// Returns the distance between two Points, p1 and p2 in meters
float distance(PVector p1, PVector p2){
  float lat1 = radians(p1.y); float lon1 = radians(p1.x);
  float lat2 = radians(p2.y); float lon2 = radians(p2.x);
  float r = 6371000;
  float dlat = (lat2 - lat1)/2;
  float dlon = (lon2 - lon1)/2;
  float q = pow(sin(dlat), 2) + cos(lat1) * cos(lat2) * pow(sin(dlon), 2);
  float c = 2 * atan2(sqrt(q), sqrt(1 - q));
  float d = r * c;
  return d;
}

PVector convertGPS(PVector p){
  PVector t = new PVector();
  t.x = map(p.x, lonMin, lonMax, 0, width/2);
  t.y = map(p.y, latMin, latMax, 0, height/2);
  return t;
}


