// Webcam - Image Processing Functions
// Zane Cochran

import processing.video.*;    // Video Library
Capture cam;                  // Live Camera Feed

PImage reducedVideo;          // Store raw video as smaller image (makes image processing faster)
PImage enhancedVideo;         // Store enhanced video for image processing
boolean showEnhanced = false; // True - Show enhanced video, False - Show original video
boolean showPicker = false;   // True - Show color picker, False - Don't show color picker

// Connect to Webcam
void loadCam() {
  // Load Video from Camera and Sample
  String[] cameras = Capture.list(); printArray(cameras);
  cam = new Capture(this, cameras[whichCam]);
  cam.start();   
  
  // Initializes Images for Reduced and Enhanced Video
  reducedVideo = new PImage(80, 80);
  enhancedVideo = new PImage(80, 80);
}

// Get an image from the webcam
void captureEvent(Capture c) {c.read();}

// Draw the Webcam Interface
void drawWebcam(){
  reduceResolution();   // Reduce Resolution of Raw Feed for Image Processing
  
  if(showEnhanced){enhancedFeed();}    // Show Enhanced Feed
  else{rawFeed();}                     // Show Raw Feed
  
  if(showPicker){colorViewer();}       // Show Color Viewer
  else{cursor();}                      // Return Cursor to Normal
  
  if(isScreenCapture){fill(255, 0, 0); noStroke(); ellipse(50, 50, 25, 25);}
  else{stroke(255, 0, 0); noFill(); ellipse(50, 50, 25, 25);}
}

void rawFeed(){image(cam, 0, 0, width/2, height/2); text("Raw Video", (width/4), 10); }                      // Shows the unmodified video
void enhancedFeed(){image(enhancedVideo, 0, 0, width/2, height/2); text("Enhanced Video", (width/4), 10);}   // Shows the modified video

// Reduced and compress raw image
void reduceResolution(){reducedVideo.copy(cam, 0, 0, 640, 480, 0, 0, 80, 80);}

// Shows the RGB values of a pixel wherever the mouse is located
void colorViewer(){
   cursor(CROSS);
   color c = get(mouseX, mouseY);
   println(red(c) + ", " + green(c) + ", " + blue(c));
}

// Save Video Output Functions
boolean isScreenCapture = false;  // Is it currently recording?
boolean isScreenInit = false;     // Is Capture Folder initialized?
String screenFolder = "";

void captureScreen(){
  if(!isScreenInit){screenFolder = "Capture_" + millis() + "/v_######.png"; isScreenInit = true;}
  else{saveFrame(screenFolder);}
}
