
//////////////////////////////////////////////////
//  Graphic Rect
//////////////////////////////////////////////////

class GraphicRect extends SuperGraphicElement {
  
  // settings
  boolean doFill = false;
  boolean doCorners = false;
  float finalWidth;
  float finalHeight;
  float boxStrokeWeight;
  color finalColor;
  color finalStrokeColor;
  
  float cornerRatio;
  float cornerLength;
  float cornerInset;
  float cornerStrokeWeight;
  
  boolean doScaleTween = false;
  
  // calculated
  float finalBoxStartX;
  float finalBoxStartY;
  float startSize = 0.5;
  float startBoxX;
  float startBoxY;
  float startWidth;
  float startHeight;
  
  // status
  float currentWidth;
  float currentHeight;
  float currentScale = 1;
  color currentFillColor;
  color currentStrokeColor;
  float currentBoxStartX;
  float currentBoxStartY;
  
  // graphics
  PShape cornerShape, tlShape, trShape, blShape, brShape;
  
    
  
  // constructors
  GraphicRect( SuperPattern pPattern, color fColor, float lWeight, float pX, float pY, float fWidth, float fHeight, boolean fill, boolean doScale, float cRatio, float cStrokeWeight ) {
    super( pPattern, pX, pY );
    
    init( fColor, lWeight, fWidth, fHeight, fill, doScale, true, cRatio, cStrokeWeight );
  }
  
  GraphicRect( SuperPattern pPattern, color fColor, float lWeight, float pX, float pY, float fWidth, float fHeight, boolean fill, boolean doScale ) {
    super( pPattern, pX, pY );
    
    init( fColor, lWeight, fWidth, fHeight, fill, doScale, false, 0, 0 );
  }
  
  void init( color fColor, float lWeight, float fWidth, float fHeight, boolean fill, boolean doScale, boolean corners, float cRatio, float cStrokeWeight ) {
    this.doFill = fill;
    this.doCorners = ( !doFill ) ? corners : false;
    this.cornerRatio = cRatio;
    this.finalColor = fColor;
    this.boxStrokeWeight = lWeight;
    this.finalWidth = this.currentWidth = fWidth;
    this.finalHeight = this.currentHeight = fHeight;
    this.cornerStrokeWeight = cStrokeWeight;
    this.doScaleTween = doScale;
    
    // calculate graphics
    finalBoxStartX = currentBoxStartX = finalPosX - ( finalWidth / 2 );
    finalBoxStartY = currentBoxStartY = finalPosY - ( finalHeight / 2 );
    
    startWidth = finalWidth * startSize;
    startHeight = finalHeight * startSize;
    startBoxX = finalPosX - ( startWidth / 2 );
    startBoxY = finalPosY - ( startHeight / 2 );
    
    
    if( doCorners ) {
      cornerLength = ( finalWidth > finalHeight ) ? finalWidth * cornerRatio : finalHeight * cornerRatio;
      cornerInset = cornerStrokeWeight / 2;
      
      float leftX = cornerInset - ( finalWidth / 2 );
      float rightX = ( finalWidth / 2 ) - cornerInset;
      float topY = cornerInset - ( finalHeight / 2 );
      float bottomY = ( finalHeight / 2 ) - cornerInset;
      
      cornerShape = createShape( GROUP );
      
      tlShape = createShape();
      tlShape.beginShape();
      tlShape.noFill();
      tlShape.vertex( leftX, topY + cornerLength );
      tlShape.vertex( leftX, topY );
      tlShape.vertex( leftX + cornerLength, topY );
      tlShape.endShape();
      tlShape.setStroke( finalColor );
      tlShape.setStrokeWeight( cornerStrokeWeight );
      cornerShape.addChild( tlShape );
      
      trShape = createShape();
      trShape.beginShape();
      trShape.noFill();
      trShape.vertex( rightX, topY + cornerLength );
      trShape.vertex( rightX, topY );
      trShape.vertex( rightX - cornerLength, topY );
      trShape.endShape();
      trShape.setStroke( finalColor ); 
      trShape.setStrokeWeight( cornerStrokeWeight );
      cornerShape.addChild( trShape );
      
      blShape = createShape();
      blShape.beginShape();
      blShape.noFill();
      blShape.vertex( leftX, bottomY - cornerLength );
      blShape.vertex( leftX, bottomY );
      blShape.vertex( leftX + cornerLength, bottomY );
      blShape.endShape();
      blShape.setStroke( finalColor ); 
      blShape.setStrokeWeight( cornerStrokeWeight );
      cornerShape.addChild( blShape );
      
      brShape = createShape();
      brShape.beginShape();
      brShape.noFill();
      brShape.vertex( rightX, bottomY - cornerLength );
      brShape.vertex( rightX, bottomY );
      brShape.vertex( rightX - cornerLength, bottomY );
      brShape.endShape();
      brShape.setStroke( finalColor ); 
      brShape.setStrokeWeight( cornerStrokeWeight );
      cornerShape.addChild( brShape );
      
    }
  }
  
  
  // draw logic
  void draw() {
    //println( "DotGraphic: draw() :: currentAlpha: " + currentAlpha );
    
    color colorWithAlpha = color( red( finalColor ), green( finalColor ), blue( finalColor ), currentAlpha );
    boolean doDrawBox = false;
    if( doFill ) {
      noStroke();
      fill( colorWithAlpha );
      doDrawBox = true;
    } else if( boxStrokeWeight > 0 ) {
      noFill();
      stroke( colorWithAlpha );    
      strokeWeight( boxStrokeWeight );
      doDrawBox = true;
    }
    
    if( doDrawBox ) {
      rect( currentBoxStartX, currentBoxStartY, currentWidth, currentHeight );
    }
    
    if( doCorners ) {
      tlShape.setStroke( colorWithAlpha ); 
      trShape.setStroke( colorWithAlpha ); 
      blShape.setStroke( colorWithAlpha ); 
      brShape.setStroke( colorWithAlpha );
      pushMatrix();
      translate( finalPosX, finalPosY );
      scale( currentScale );
      shape( cornerShape );
      popMatrix();
    }
    
    noFill();
    noStroke();
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {
    //println( "DotGraphic: show( " + tTime + ", " + delay + ") :: posX: " + currentPosX + ", posY: " + currentPosY );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentAlpha = 1;
    String propList = "currentAlpha:255";
    if( doScaleTween ) {
      currentBoxStartX = startBoxX;
      currentBoxStartY = startBoxY;
      currentWidth = startWidth;
      currentHeight = startHeight;
      currentScale = startSize;
      propList = propList + ",currentBoxStartX:" + finalBoxStartX + ",currentBoxStartY:" + finalBoxStartY + ",currentWidth:" + finalWidth + ",currentHeight:" + finalHeight + ",currentScale:" + 1;
    }
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {  
    //println( "DotGraphic: hide( " + tTime + ", " + delay + ") :: posX: " + currentPosX + ", posY: " + currentPosY );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:1";
    if( doScaleTween ) {
      propList = propList + ",currentBoxStartX:" + startBoxX + ",currentBoxStartY:" + startBoxY + ",currentWidth:" + startWidth + ",currentHeight:" + startHeight + ",currentScale:" + startSize;
    }
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}





//////////////////////////////////////////////////
//  Graphic Dashed Bar
//////////////////////////////////////////////////

class GraphicDashedBar extends SuperGraphicElement {
  
  // settings
  int divisions;
  float finalWidth;
  float finalHeight;
  float finalStrokeWeight;
  color finalColor;
  int direction;
  
  // status
  float currentWidth;
  float currentHeight;
  color currentColor;
  
  
  
  // constructor
  GraphicDashedBar( SuperPattern pPattern, color fColor, float lWeight, float pX, float pY, float fWidth, float fHeight, int divs ) {
    super( pPattern, pX, pY );
    
    this.finalColor = fColor;
    this.finalStrokeWeight = lWeight;
    this.finalWidth = this.currentWidth = fWidth;
    this.finalHeight = this.currentHeight = fHeight;
    this.divisions = divs;
    this.direction = ( finalWidth > finalHeight ) ? Direction.HORIZONTAL : Direction.VERTICAL;
    
    if( divisions % 2 < 1 ) {
      divisions++;
    }
  }
  
  
  // draw logic
  void draw() {
    //println( "DotGraphic: draw() :: currentAlpha: " + currentAlpha );
    
    color colorWithAlpha = color( red( finalColor ), green( finalColor ), blue( finalColor ), currentAlpha );
    float cellWidth = ( direction == Direction.HORIZONTAL ) ? finalWidth / float( divisions ) : finalWidth;
    float cellHeight = ( direction == Direction.VERTICAL ) ? finalHeight / float( divisions ) : finalHeight;
    float cellX = finalPosX;
    float cellY = finalPosY;
    
    for( int i = 0; i < divisions; i++ ) {
      boolean doFill = ( i % 2 < 1 ) ? true : false;
      
      stroke( colorWithAlpha );    
      strokeWeight( finalStrokeWeight );
      if( doFill ) {
        fill( colorWithAlpha );
      }
      
      rect( cellX, cellY, cellWidth, cellHeight );
      
      cellX = ( direction == Direction.HORIZONTAL ) ? cellX + cellWidth : cellX;
      cellY = ( direction == Direction.VERTICAL ) ? cellY + cellHeight : cellY;
      
      noFill();
      noStroke();
    }
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:255";
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {      
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:1";
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}





//////////////////////////////////////////////////
//  Caution Tape
//////////////////////////////////////////////////

class Point {
  float x;
  float y;
  
  Point( float x1, float y1 ) {
    this.x = x1;
    this.y = y1;
  }
}

class CautionTape extends SuperGraphicElement {
  
  // settings
  int divisions;
  float finalWidth;
  float finalHeight;
  float finalStrokeWeight;
  color finalColor;
  
  int direction;
  
  float startScale = 0;
  
  // status
  float currentWidth;
  float currentHeight;
  float currentScale;
  
  // graphics
  PShape shapeContainer;
  
  
  // constructor
  CautionTape( SuperPattern pPattern, color fColor, float lWeight, float pX, float pY, float fWidth, float fHeight ) {
    super( pPattern, pX, pY );
    
    this.finalColor = fColor;
    this.finalStrokeWeight = lWeight;
    this.finalWidth = this.currentWidth = fWidth;
    this.finalHeight = this.currentHeight = fHeight;
    this.direction = ( finalWidth > finalHeight ) ? Direction.HORIZONTAL : Direction.VERTICAL;
    
    float fullWidth = finalWidth + ( finalStrokeWeight * 2 );
    divisions = ceil( fullWidth / finalStrokeWeight );
    
    shapeContainer = createShape( GROUP );
    
    
    
    float startAngle = radians( 35 );
    float startX = -fullWidth / 2;
    float topY = -finalHeight / 2;
    float bottomY = finalHeight / 2;
    float offsetX = finalHeight * tan( startAngle );
    
    float leftBound = -finalWidth / 2;
    float rightBound = finalWidth / 2;
    
    for( int i = 0; i < divisions; i += 2 ) {
      Point tl = new Point( startX, topY );
      Point tr = new Point( startX + finalStrokeWeight, topY );
      Point br = new Point( startX + offsetX + finalStrokeWeight, bottomY );
      Point bl = new Point( startX + offsetX, bottomY );
      
      PShape shape = createShape();
      shape.beginShape();
      shape.noStroke();
      shape.fill( finalColor );
      // top left
      shape.vertex( tl.x, tl.y );
      // top right
      shape.vertex( tr.x, tr.y );
      // bottom right
      shape.vertex( br.x, br.y );
      // bottom left
      shape.vertex( bl.x, bl.y );
      shape.endShape( CLOSE );
      startX += finalStrokeWeight * 2;
      shapeContainer.addChild( shape );
    }
    
    //for( int i = 0; i < divisions; i += 2 ) {
    //  Point tl = new Point( startX, topY );
    //  Point tr = new Point( startX + finalStrokeWeight, topY );
    //  Point br = new Point( startX + offsetX + finalStrokeWeight, bottomY );
    //  Point bl = new Point( startX + offsetX, bottomY );
      
    //  PShape shape = createShape();
    //  shape.beginShape();
    //  shape.noStroke();
    //  shape.fill( finalColor );
    //  // top left
    //  if( tl.x >= leftBound ) {
    //    shape.vertex( tl.x, tl.y );
    //  } else if ( startX > leftBound - finalStrokeWeight ) {
    //    shape.vertex( leftBound, tl.y );
    //  }
    //  // top right
      
    //  if( tr.x >= leftBound ) {
    //    shape.vertex( tr.x, tr.y );
    //  } else {
    //    float thisY = getYForAngle( startAngle, br.x, br.y, leftBound );
    //    shape.vertex( leftBound, thisY );
    //  }
    //  // bottom right
    //  shape.vertex( br.x, br.y );
    //  // bottom left
    //  if( bl.x >= leftBound ) {
    //    shape.vertex(bl.x, bl.y );
    //  } else {
        
    //  }
      
    //  shape.endShape( CLOSE );
      
    //  startX += finalStrokeWeight * 2;
    //  shapeContainer.addChild( shape );
    //}
    
  }
  
  float getYForAngle( float angle, float x1, float y1, float x2 ) {
    float m = tan( angle );
    float b = y1 - m * x1;
    return m * x2 + b;
  }
  
  
  
  // draw logic
  void draw() {

    //color colorWithAlpha = color( red( finalColor ), green( finalColor ), blue( finalColor ), currentAlpha );

    //polygon.setFill( colorWithAlpha );

    pushMatrix();
    translate( finalPosX, finalPosY );
    scale( 1, currentScale );
    if( direction == Direction.VERTICAL ) {
      rotate( -HALF_PI );
    }
    shape( shapeContainer );
    popMatrix();
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentAlpha = 1;
    currentScale = startScale;
    String propList = "currentAlpha:255,currentScale:1";
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:1,currentScale:" + startScale;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}
