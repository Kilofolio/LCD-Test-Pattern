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
boolean doShowBloom = false;

boolean doScaleGraphics = false;

int graphicsWidth;
int graphicsHeight;
float scaleX = 1;
float scaleY = 1;

// graphics
PGraphics canvas;

// shaders
PGraphics brightPass;
PGraphics horizontalBlurPass;
PGraphics verticalBlurPass;

PShader bloomFilter;
PShader blurFilter;

float luminanceFilter = 0.25;
float blurSize = 12;
float sigma = 4;

// auto timer
float timerBarHeight = 0;
int autoDuration = 4000;
Timer autoTimer = new Timer( autoDuration );
boolean autoMode = false;


// Setup
void setup() {
  size( 1920, 1080, P2D );
  //fullScreen();
  
  if( doScaleGraphics ) {
    graphicsWidth = 1440;
    graphicsHeight = 1080;
    scaleX = width / float( graphicsWidth );
    scaleY = height / float( graphicsHeight );
  } else {
    graphicsWidth = width;
    graphicsHeight = height;
  }
  
  // graphics
  canvas = createGraphics( graphicsWidth, graphicsHeight );
  
  brightPass = createGraphics( graphicsWidth, graphicsHeight, P2D );
  brightPass.noSmooth();

  horizontalBlurPass = createGraphics( graphicsWidth, graphicsHeight, P2D );
  horizontalBlurPass.noSmooth(); 

  verticalBlurPass = createGraphics( graphicsWidth, graphicsHeight, P2D );
  verticalBlurPass.noSmooth(); 

  bloomFilter = loadShader("shaders/bloomFrag.glsl");
  bloomFilter.set("brightPassThreshold", luminanceFilter);
  
  blurFilter = loadShader("shaders/blurFrag.glsl");
  blurFilter.set("blurSize", (int)blurSize);
  blurFilter.set("sigma", sigma);
  
  
  // animation
  Ani.init(this);
  timerBarHeight = floor( graphicsHeight / 250 );
  
  // fonts
  fontSize = ceil( graphicsHeight / 55 );
  hackRegular = createFont( "fonts/Hack-Regular.ttf", fontSize );
  hackBold = createFont( "fonts/Hack-Bold.ttf", fontSize );
  
  // draw settings
  strokeCap( SQUARE );
  strokeJoin( MITER );
  
  // graphics
  titleCard = new TitleCard( canvas, graphicsWidth, graphicsHeight, margin, this, hackRegular, highlightColor, bgColor );
  
  patterns = new ArrayList<SuperPattern>();
  float dotSize = ceil( graphicsHeight / 150 ); //4;
  float lineWeight = ceil( graphicsHeight / 400 ); //2;
  
  // color bars
  //patterns.add( new PatternColorSMPTE( margin ) );
  patterns.add( new PatternColorLabeled( canvas, graphicsWidth, graphicsHeight, margin, hackBold, fontSize, lineWeight ) );
  patterns.add( new PatternGraysacle( canvas, graphicsWidth, graphicsHeight, margin, hackBold, fontSize, lineWeight ) );
  
  // grid
  patterns.add( new PatternDotGrid( canvas, graphicsWidth, graphicsHeight, margin, 9, lineWeight, dotSize, fgColor, highlightColor ) );
  
  // crosshair
  patterns.add( new PatternCrosshair( canvas, graphicsWidth, graphicsHeight, margin, 27, lineWeight, fgColor, highlightColor ) );
  
  // hex
  patterns.add( new PatternHex( canvas, graphicsWidth, graphicsHeight, margin, 27, lineWeight, fgColor, highlightColor, hackRegular, hackBold, fontSize ) );
  
  
  // SCANLINES
  scanlines = new Scanlines( 6, 2, true, 0.25 );
  
  titleCard.show( standardShowDelay );
}

// Draw logic
void draw() {
  canvas.beginDraw();
  canvas.background( bgColor );
  
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
  
  if( doScaleGraphics ) {
    pushMatrix();
    scale( scaleX, scaleY );
  }
  
  if( doShowBloom ) {
    drawWithBloom();
  } else {
    image( canvas, 0, 0 );
  }
  
  if( doScaleGraphics ) {
    popMatrix();
  }
}

void drawWithBloom() {
  // source: https://github.com/cansik/processing-bloom-filter
  
  // bright pass
  brightPass.beginDraw();
  brightPass.shader(bloomFilter);
  brightPass.image(canvas, 0, 0);
  brightPass.endDraw();

  // blur horizontal pass
  horizontalBlurPass.beginDraw();
  blurFilter.set("horizontalPass", 1);
  horizontalBlurPass.shader(blurFilter);
  horizontalBlurPass.image(brightPass, 0, 0);
  horizontalBlurPass.endDraw();

  // blur vertical pass
  verticalBlurPass.beginDraw();
  blurFilter.set("horizontalPass", 0);
  verticalBlurPass.shader(blurFilter);
  verticalBlurPass.image(horizontalBlurPass, 0, 0);
  verticalBlurPass.endDraw();

  // draw 
  image( canvas, 0, 0 );
  blendMode( SCREEN );
  image( verticalBlurPass, 0, 0 );
  blendMode( BLEND );
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
  if( keyCode == 83 ) { // S
    toggleScanlines();
  }
  if( keyCode == 66 ) { // B
    doShowBloom = !doShowBloom;
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
