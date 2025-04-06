import de.looksgood.ani.*;

// colors
final color bgColor = color( 16, 16, 16 ); //color( 10, 10, 10 );
final color fgColor = color( 239, 239, 239 ); //color( 245, 245, 245 );
final color highlightColor = color( 207, 48, 48 );

// fonts
float fontSize;
PFont hackRegular;
PFont hackBold;

// components
TitleCard titleCard;
ArrayList<SuperPattern> patterns;
Scanlines scanlines;

// settings
boolean hasBegun = false;
final float margin = 0; //0.05;
int activePatternIndex = 1;
float standardShowDelay = 0.65;
boolean doShowScanlines = false;
boolean doSimulateSize = false;

int simulatedWidth;
int simulatedHeight;
float scaleX = 1;
float scaleY = 1;

// graphics
PGraphics canvas;

// auto timer
float timerBarHeight = 0;
int autoDuration = 4000;
Timer autoTimer = new Timer( autoDuration );
boolean autoMode = false;


// Setup
void setup() {
  size( 1920, 1080 );
  //fullScreen();
  
  if( doSimulateSize ) {
    simulatedWidth = 1440;
    simulatedHeight = 1080;
    scaleX = width / float( simulatedWidth );
    scaleY = height / float( simulatedHeight );
  } else {
    simulatedWidth = width;
    simulatedHeight = height;
  }
  
  canvas = createGraphics( simulatedWidth, simulatedHeight );
  
  // animation
  Ani.init(this);
  timerBarHeight = floor( simulatedHeight / 250 );
  
  // fonts
  fontSize = ceil( simulatedHeight / 55 );
  hackRegular = createFont( "fonts/Hack-Regular.ttf", fontSize );
  hackBold = createFont( "fonts/Hack-Bold.ttf", fontSize );
  
  // draw settings
  strokeCap( SQUARE );
  strokeJoin( MITER );
  
  // graphics
  titleCard = new TitleCard( canvas, simulatedWidth, simulatedHeight, margin, this, hackRegular, highlightColor, bgColor );
  
  patterns = new ArrayList<SuperPattern>();
  float dotSize = ceil( simulatedHeight / 150 ); //4;
  float lineWeight = ceil( simulatedHeight / 400 ); //2;
  
  // color bars
  //patterns.add( new PatternColorSMPTE( margin ) );
  patterns.add( new PatternColorLabeled( canvas, simulatedWidth, simulatedHeight, margin, hackBold, fontSize, lineWeight ) );
  patterns.add( new PatternGraysacle( canvas, simulatedWidth, simulatedHeight, margin, hackBold, fontSize, lineWeight ) );
  
  // grid
  patterns.add( new PatternDotGrid( canvas, simulatedWidth, simulatedHeight, margin, 9, lineWeight, dotSize, fgColor, highlightColor ) );
  
  // crosshair
  patterns.add( new PatternCrosshair( canvas, simulatedWidth, simulatedHeight, margin, 27, lineWeight, fgColor, highlightColor ) );
  
  // hex
  patterns.add( new PatternHex( canvas, simulatedWidth, simulatedHeight, margin, 27, lineWeight, fgColor, highlightColor, hackRegular, hackBold, fontSize ) );
  
  
  // SCANLINES
  scanlines = new Scanlines( 6, 2, true, 0.25 );
  
  titleCard.show( standardShowDelay );
}

// Draw logic
void draw() {
  background( bgColor );
  
  canvas.beginDraw();
  
    if( hasBegun ) {
      // draw current pattern
      for( int i = 0; i < patterns.size(); i++ ) {
        SuperPattern thisPattern = patterns.get(i);
        if( thisPattern.isActive ) {
          thisPattern.draw();
        }
      }
      
      // auto mode
      if( autoMode ) {
        // timer logic
        autoTimer.draw();
        if( autoTimer.progress() >= 1 ) {
          onAutoTimerComplete();
        }
      }
    }
    
    if( titleCard.isActive ) {
      titleCard.draw();
    }
    
    // scanlines
    if( doShowScanlines ) {
      scanlines.draw();
    }
    
  canvas.endDraw();
  
  if( doSimulateSize ) {
    pushMatrix();
    scale( scaleX, scaleY );
  }
  
  image( canvas, simulatedWidth, simulatedHeight );
  
  if( doSimulateSize ) {
    popMatrix();
  }
}

void startAuto() {
  startAuto( activePatternIndex + 1, standardShowDelay );
}

void startAuto( int newIndex, float customDelay ) {
  if( !autoMode ) {
    changePattern( newIndex, customDelay );
    
    autoTimer.start();
    autoMode = true;
  }
}

void endAuto() {
  if( autoMode ) {
    autoMode = false;
    autoTimer.stop();
  }
}

// Event handlers

void changePattern( int index ) {
  changePattern( index, standardShowDelay );
}

void changePattern( int index, float customDelay ) {
  index = ( index < patterns.size() ) ? index : 0;
  if( index != activePatternIndex ) {
    patterns.get( activePatternIndex ).hide( 0 );
    activePatternIndex = index;
    patterns.get( activePatternIndex ).show( customDelay );
  }
}

void toggleScanlines() {
  doShowScanlines = !doShowScanlines;
  
  if( doShowScanlines) {
    scanlines.show();
  } else {
    scanlines.hide();
  }
}

void onAutoTimerComplete() {
  changePattern( activePatternIndex + 1 );
  autoTimer.start();
}

void mouseReleased() {
  noCursor();
}

void keyPressed() {
  println( "key pressed: " + keyCode );
  
  // key handling
  if( keyCode == 27 ) { // ESC
    exit();
  }
  if( keyCode == 83 ) {
    toggleScanlines();
  }
  if( !hasBegun ) {
    if( keyCode == 10 ) { // Enter
      hasBegun = true;
      titleCard.hide( 0 );
      // start
      startAuto( 0, 1.5 );
    }
  } else {
    if( keyCode == 10 ) { // Enter
      if( !autoMode ) {
        startAuto();
      } else {
        endAuto();
      }
    } else {
      endAuto();
    }
    if( keyCode == 32 ) { // Space
      changePattern( activePatternIndex + 1 );
    }
    if( keyCode > 48 && keyCode < 58 ) { // num keys
      int newIndex = keyCode - 49;
      changePattern( newIndex );
    }
  }
}
