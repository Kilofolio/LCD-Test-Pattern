
//////////////////////////////////////////////////
//  Graphic Polygon
//////////////////////////////////////////////////

class GraphicPolygon extends SuperGraphicElement {
  
  // settings
  float finalDiameter;
  float finalWidth;
  float finalHeight;
  float lineWeight;
  color finalColor;
  PFont font;
  float fontSize;
  String labelText;
  
  boolean doFill;
  boolean doStroke;
  
  boolean hasLabel;
  int labelSegment;
  
  // calculated
  float startSize = 0.5;
  float textX;
  float textY;
  float textRot;
  
  float sideAngle;
  
  boolean doShowReg = false;
  
  // status
  float currentScale = 1;
  
  // sub-graphics
  PShape polygon;
  
  
  
  // constructors
  
  GraphicPolygon( SuperPattern pPattern, float pX, float pY, float diameter, int numSides, int drawSides, float startAngle, boolean doClose, color fColor, float lWeight ) {
    super( pPattern, pX, pY );
    
    hasLabel = false;
    
    init( diameter, numSides, drawSides, startAngle, doClose, fColor, lWeight );
  }
  
  GraphicPolygon( SuperPattern pPattern, float pX, float pY, float diameter, int numSides, int drawSides, float startAngle, boolean doClose, color fColor, float lWeight, PFont tFont, float tSize, String lText, int lSegment ) {
    super( pPattern, pX, pY );
    
    hasLabel = true;
    this.font = tFont;
    this.fontSize = tSize;
    this.labelText = lText;
    this.labelSegment = lSegment;
    
    init( diameter, numSides, drawSides, startAngle, doClose, fColor, lWeight );
  }
  
  
  void init( float diameter, int numSides, int drawSides, float startAngle, boolean doClose, color fColor, float lWeight ) {
    this.finalDiameter = diameter;
    this.finalColor = fColor;
    //this.finalColor = color( random( 0, 255 ), random( 0, 255 ), random( 0, 255 ) );
    this.lineWeight = lWeight;
    
    if( lWeight > 0 ) {
      doStroke = true;
    } else {
      doFill = true;
    }
    
    // construct graphics
    sideAngle = TWO_PI / float( numSides );
    float radius = finalDiameter / 2;
    float vertexCount = drawSides + 1;
   
    polygon = createShape();
    polygon.beginShape();
    
    float currentAngle  = normalizeAngle( startAngle ); //( nSides % 2 > 0 ) ? -PI / 2 : ( -PI / 2 ) + ( sideAngle / 2 );
    for( int i = 0; i < vertexCount; i++ ) {
      float vX = radius * cos( currentAngle );
      float vY = radius * sin( currentAngle );
      polygon.vertex( vX, vY );
      currentAngle = normalizeAngle( currentAngle + sideAngle );
      //println( "side: " + i + ", angle: " + currentAngle );
    }
    println( "---" );
    
    if( !doFill ) {
      polygon.noFill();
    }
    if( !doStroke ) {
      polygon.noStroke();
    }
    
    if( doClose ) {
      polygon.endShape( CLOSE );
    } else {
      polygon.endShape();
    }
    
    if( doFill ) {
      polygon.setFill( finalColor );
    }
    if( doStroke ) {
      polygon.setStroke( finalColor );
      polygon.setStrokeWeight( lineWeight );
    }
    
    // text label
    float a1 = ( float( labelSegment ) * sideAngle );
    float a2 = a1 + sideAngle;
    float textAngle = ( a1 + a2 ) / 2;
    float p1x = finalPosX + ( radius * cos( a1 ) );
    float p1y = finalPosY + ( radius * sin( a1 ) );
    float p2x = finalPosX + ( radius * cos( a2 ) );
    float p2y = finalPosY + ( radius * sin( a2 ) );
    float buffer = fontSize * 0.9;
    float bufferX = buffer * cos( textAngle );
    float bufferY = buffer * sin( textAngle );
    textX = ( p1x + p2x ) / 2 + bufferX;
    textY = ( p1y + p2y ) / 2 + bufferY;
    textRot = textAngle - HALF_PI;
    
    this.finalWidth = polygon.width;
    this.finalHeight = polygon.height;
  }
  
  float normalizeAngle( float ang ) {
    if( ang < 0 ) {
      return ang + TWO_PI;
    } else if ( ang > TWO_PI ) {
      return ang - TWO_PI;
    } else {
      return ang;
    }
  }
  
  // draw logic
  void draw() {

    color colorWithAlpha = color( red( finalColor ), green( finalColor ), blue( finalColor ), currentAlpha );

    if( doFill ) {
      polygon.setFill( colorWithAlpha );
    }
    
    if( doStroke ) {
      polygon.setStroke( colorWithAlpha );    
    }
    
    pushMatrix();
    translate( finalPosX, finalPosY );
    scale( currentScale );
    shape( polygon );
    popMatrix();
    
    if( hasLabel ) {
      noStroke();
      fill( colorWithAlpha );
      
      textFont( font );
      textSize( fontSize );
      textAlign( CENTER, CENTER );
      
      pushMatrix();
      translate( textX, textY );
      rotate( textRot );
      text( labelText, 0, 0 );
      popMatrix();
    }
    
    if( doShowReg ) {
      stroke( color( 0, 255, 0 ) );
      strokeWeight( 2 );
      float regSize = finalDiameter / 6;
      line( currentPosX - regSize, currentPosY, currentPosX + regSize, currentPosY );
      line( currentPosX, currentPosY - regSize, currentPosX, currentPosY + regSize );
    }
    
    noStroke();
    noFill();
    
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentAlpha = 1;
    currentScale = startSize;
    String propList = "currentAlpha:255,currentScale:1";
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:1,currentScale:" + startSize;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}
