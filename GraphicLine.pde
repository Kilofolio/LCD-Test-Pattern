class LineData {
  float finalX1;
  float finalY1;
  float finalX2;
  float finalY2;
  
  LineData( float x1, float y1, float x2, float y2 ) {
    this.finalX1 = x1;
    this.finalY1 = y1;
    this.finalX2 = x2;
    this.finalY2 = y2;
  }
}


//////////////////////////////////////////////////
//  Graphic Line
//////////////////////////////////////////////////

class GraphicLine extends SuperGraphicElement {
  
  // settings
  float finalStrokeWeight;
  float finalEndPosX;
  float finalEndPosY;
  color finalColor;
  
  float midPosX;
  float midPosY;
  
  // status
  float currentEndPosX;
  float currentEndPosY;
  color currentColor;
  
  
  
  // constructor
  GraphicLine( SuperPattern pPattern, float lWeight, color fColor, float pX, float pY, float endX, float endY ) {
    super( pPattern, pX, pY );
    
    this.finalStrokeWeight = lWeight;
    this.finalColor = fColor;
    this.finalEndPosX = endX;
    this.finalEndPosY = endY;
    midPosX = ( finalPosX + finalEndPosX ) / 2;
    midPosY = ( finalPosY + finalEndPosY ) / 2;
  }
  
  
  
  // draw logic
  void draw() {
    //println( "LineGraphic: draw() :: currentAlpha: " + currentAlpha );
    
    noFill();
    
    color colorWithAlpha = color( red( finalColor ), green( finalColor ), blue( finalColor ), currentAlpha );
    stroke( colorWithAlpha );    
    strokeWeight( finalStrokeWeight );
    line( currentPosX, currentPosY, currentEndPosX, currentEndPosY );
    
    noStroke(); 
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentPosX = currentEndPosX = midPosX;
    currentPosY = currentEndPosY = midPosY;
    String propList = "currentAlpha:255,currentPosX:" + finalPosX + ",currentPosY:" + finalPosY + ",currentEndPosX:" + finalEndPosX + ",currentEndPosY:" + finalEndPosY;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:1,currentPosX:" + midPosX + ",currentPosY:" + midPosY + ",currentEndPosX:" + midPosX + ",currentEndPosY:" + midPosY;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}




//////////////////////////////////////////////////
//  Graphic Ruled Line
//////////////////////////////////////////////////

class GraphicRuledLine extends SuperGraphicElementContainer {
  
  // settings
  float finalWidth;
  float finalHeight;
  float finalStrokeWeight;
  color finalColor;
  int divisions;
  int subdivisions;
  int direction;
  int animationDirection = 1;
  
  float midPosX;
  float midPosY;
  
  
  
  // constructor
  GraphicRuledLine( SuperPattern pPattern, float lWeight, color fColor, float pX, float pY, float fWidth, float fHeight, int divs, int subdivs, int animDir ) {
    super( pPattern, pX, pY );
    
    this.finalStrokeWeight = lWeight;
    this.finalColor = fColor;
    this.finalWidth = fWidth;
    this.finalHeight = fHeight;
    this.divisions = divs;
    this.subdivisions = subdivs;
    this.direction = ( finalWidth > finalHeight ) ? Direction.HORIZONTAL : Direction.VERTICAL;
    this.animationDirection = animDir;
    midPosX = finalPosX + finalWidth / 2;
    midPosY = finalPosY + finalHeight / 2;
        
    float lineLength = ( direction ==  Direction.HORIZONTAL ) ? finalWidth : finalHeight;
    addLine( midPosX, midPosY, lineLength, finalStrokeWeight, finalColor, direction );
    
    float startX = ( direction ==  Direction.HORIZONTAL ) ? finalPosX : midPosX;
    float startY = ( direction ==  Direction.VERTICAL ) ? finalPosY : midPosY;
    int totalDivs = divs + ( ( divs - 1 ) * ( subdivs - 1 ) );
    float divDist = ( direction ==  Direction.HORIZONTAL ) ? finalWidth / float( totalDivs - 1 ) : finalHeight / float( totalDivs - 1 );
    float fullDivHeight = ( direction ==  Direction.HORIZONTAL ) ? finalHeight : finalWidth;
    float partDivHeight = fullDivHeight / 4;
    int divOrientation = ( direction ==  Direction.HORIZONTAL ) ? Direction.VERTICAL : Direction.HORIZONTAL;
    for( int i = 0; i < totalDivs; i++ ) {
      boolean isTall = ( i % subdivisions < 1 ) ? true : false;
      float divHeight = ( isTall ) ? fullDivHeight : partDivHeight;
      float divWeight = ( isTall ) ? finalStrokeWeight : 1;
      
      addLine( startX, startY, divHeight, divWeight, finalColor, divOrientation );
      
      startX = ( direction ==  Direction.HORIZONTAL ) ? startX + divDist : startX;
      startY = ( direction ==  Direction.VERTICAL ) ? startY + divDist : startY;
    }
  }
  
  void addLine( float centerX, float centerY, float lineLength, float lineWeight, color lineColor, int orientation ) {
    float startX = ( orientation ==  Direction.HORIZONTAL ) ? centerX - ( lineLength / 2 ) : centerX;
    float startY = ( orientation ==  Direction.VERTICAL ) ? centerY - ( lineLength / 2 ) : centerY;
    float endX = ( orientation ==  Direction.HORIZONTAL ) ? centerX + ( lineLength / 2 ) : centerX;
    float endY = ( orientation ==  Direction.VERTICAL ) ? centerY + ( lineLength / 2 ) : centerY;
    GraphicLine newLine = new  GraphicLine( parentPattern, lineWeight, lineColor, startX, startY, endX, endY );
    if( animationDirection > 0 ) {
      graphicElements.add( newLine );
    } else {
      graphicElements.add( 0, newLine );
    }
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    float subDelay = delay;
    float tweenInc = tTime / graphicElements.size() / 2;
    graphicElements.get(0).show( tTime, delay );
    for( int i = 1; i < graphicElements.size(); i++ ) {
      graphicElements.get(i).show( tTime, subDelay );
      subDelay += tweenInc;
    }
  }
  
  void hide( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    float subDelay = delay;
    float tweenInc = tTime / graphicElements.size() / 2;
    graphicElements.get(0).hide( tTime, subDelay );
    for( int i = 1; i < graphicElements.size(); i++ ) {
      graphicElements.get(i).hide( tTime, subDelay );
      subDelay += tweenInc;
    }
  }
  
}





//////////////////////////////////////////////////
//  Scanlines
//////////////////////////////////////////////////

class Scanlines {
  
  // settings
  boolean doAnimate;
  
  // graphics
  PShape linesShape;
  
  // status
  float currentPosY = 0;
  
  // animation
  Ani loopAni;
  
  
  // Constructor
  Scanlines( float lineHeightLight, float lineHeightDark, boolean doAnimate, float tweenTime ) {
    this.doAnimate = doAnimate;
    
    color lightColor = color( 255, 255, 255, 16 );
    color darkColor = color( 0, 0, 0, 36 );
    
    // construct graphics
    float numLines = ceil( height / ( lineHeightLight + lineHeightDark ) * 2 );
    linesShape = createShape( GROUP );
    
    float lineStartX = 0;
    float lineEndX = width;  
    float lineStartY = 0; 
    float lineEndY = 0;
    boolean isLight = true;
    for( int i = 0; i < numLines + 2; i++ ) {
      //PShape thisLine = createShape( RECT, 0, float( i ) * lineHeight, width, lineHeight );
      
      float thisLineHeight = ( isLight ) ? lineHeightLight : lineHeightDark;
      lineEndY += thisLineHeight;
      
      PShape thisLine = createShape();
      thisLine.beginShape();
      thisLine.noStroke();
      thisLine.fill( isLight ? lightColor : darkColor );
      thisLine.vertex( lineStartX, lineStartY );
      thisLine.vertex( lineEndX, lineStartY );
      thisLine.vertex( lineEndX, lineEndY );
      thisLine.vertex( lineStartX, lineEndY );
      thisLine.endShape( CLOSE );
      linesShape.addChild( thisLine );
      
      lineStartY += thisLineHeight;
      isLight = !isLight;
    }
    
    // animate
    if( doAnimate ) {
      currentPosY = -( lineHeightLight + lineHeightDark);
      loopAni = Ani.to( this, tweenTime, "currentPosY", 0, Ani.LINEAR );
      loopAni.repeat();
    }
  }
  
  
  // Event handlers
  void draw() {
    shape( linesShape, 0, currentPosY );
  }
  
}
