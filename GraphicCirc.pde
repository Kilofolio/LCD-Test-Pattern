
//////////////////////////////////////////////////
//  Graphic Circ
//////////////////////////////////////////////////

class GraphicCirc extends SuperGraphicElement {
  
  // settings
  boolean doFill = false;
  float finalDiameter;
  color finalColor;
  float finalStrokeWeight;
  
  // status
  float currentDiameter;
  color currentColor;
  
  
  
  // constructor
  GraphicCirc( SuperPattern pPattern, color fColor, float lWeight, float pX, float pY, float fDiameter, boolean fill ) {
    super( pPattern, pX, pY );
    
    this.doFill = fill;
    this.finalColor = fColor;
    this.finalStrokeWeight = lWeight;
    this.finalDiameter = fDiameter;
  }
  
  
  
  // draw logic
  void draw() {    
    color colorWithAlpha = color( red( finalColor ), green( finalColor ), blue( finalColor ), currentAlpha );
    if( doFill ) {
      canvas.noStroke();
      canvas.fill( colorWithAlpha );
    } else {
      canvas.noFill();
      canvas.stroke( colorWithAlpha );    
      canvas.strokeWeight( finalStrokeWeight );
    }
    
    canvas.circle( currentPosX, currentPosY, currentDiameter );
    
    canvas.noFill(); 
    canvas.noStroke();
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {
    //println( "DotGraphic: show( " + tTime + ", " + delay + ") :: posX: " + currentPosX + ", posY: " + currentPosY );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentDiameter = finalDiameter / 2;
    String propList = "currentAlpha:255,currentDiameter:" + finalDiameter;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {  
    //println( "DotGraphic: hide( " + tTime + ", " + delay + ") :: posX: " + currentPosX + ", posY: " + currentPosY );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:1,currentDiameter:" + ( finalDiameter / 2 );
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}





//////////////////////////////////////////////////
//  Graphic Cross Circ
//////////////////////////////////////////////////

class GraphicCrossCirc extends SuperGraphicElementContainer {
  
  // settings
  color baseColor;
  color highlightColor;
  float finalStrokeWeight;
  
  
  // constructor
  GraphicCrossCirc( SuperPattern pPattern, color bColor, color hlColor, float lWeight, float pX, float pY, float fDiameter, float lineRatio ) {
    super( pPattern, pX, pY );
    
    init( bColor, hlColor, lWeight, fDiameter, lineRatio );
  }
  
  GraphicCrossCirc( SuperPattern pPattern, color bColor, float lWeight, float pX, float pY, float fDiameter, float lineRatio ) {
    super( pPattern, pX, pY );
    
    init( bColor, bColor, lWeight, fDiameter, lineRatio );
  }
  
  void init( color bColor, color hlColor, float lWeight, float fDiameter, float lineRatio ) {
    this.baseColor = bColor;
    this.highlightColor = hlColor;
    this.finalStrokeWeight = lWeight;
    float finalDiameter = ( lineRatio <= 1) ? fDiameter : fDiameter / lineRatio;
    
    GraphicCirc centerCirc = new GraphicCirc( parentPattern, bColor, finalStrokeWeight, finalPosX, finalPosY, finalDiameter, false );
    graphicElements.add( centerCirc );
    
    float lineSize = ( lineRatio > 1) ? fDiameter : fDiameter * lineRatio;
    float startX = finalPosX - ( lineSize / 2 );
    float startY = finalPosY;
    float endX = finalPosX + ( lineSize / 2 );
    GraphicLine hLine = new GraphicLine( parentPattern, finalStrokeWeight, hlColor, startX, startY, endX, startY );
    graphicElements.add( hLine );
    
    startX = finalPosX;
    startY = finalPosY - ( lineSize / 2 );
    float endY = finalPosY + ( lineSize / 2 );
    GraphicLine vLine = new GraphicLine( parentPattern, finalStrokeWeight, hlColor, startX, startY, startX, endY );
    graphicElements.add( vLine );
  }
  
}





//////////////////////////////////////////////////
//  Graphic Crosshair
//////////////////////////////////////////////////

class GraphicCrosshair extends SuperGraphicElementContainer {
  
  // settings
  color baseColor;
  color highlightColor;
  float finalStrokeWeight;
  float finalRotation;
  
  
  // constructor
  GraphicCrosshair( SuperPattern pPattern, color bColor, color hlColor, float lWeight, float pX, float pY, float fSize, int tShape, float lineRatio, boolean doCenterDot ) {
    super( pPattern, pX, pY );
    
    this.baseColor = bColor;
    this.highlightColor = hlColor;
    this.finalStrokeWeight = lWeight;
    lineRatio = constrain( lineRatio, 0, 1 );
    float lineSize = ( fSize / 2 ) * lineRatio;
    float finalRadius = fSize / 2;
    float finalDiameter = ( lineRatio > 0 ) ? fSize - ( ( fSize * lineRatio ) / 2 ) : fSize;
    
    if( tShape == TargetShape.CIRCLE ) {
      GraphicCirc centerCirc = new GraphicCirc( parentPattern, bColor, finalStrokeWeight, finalPosX, finalPosY, finalDiameter, false );
      graphicElements.add( centerCirc );
    } else if ( tShape == TargetShape.RECTANGLE ) {
      GraphicRect centerRect = new GraphicRect( parentPattern, bColor, finalStrokeWeight, finalPosX, finalPosY, finalDiameter, finalDiameter, false, true );
      graphicElements.add( centerRect );
    }
    
    if( doCenterDot ) {
      GraphicCirc centerDot = new GraphicCirc( parentPattern, bColor, finalStrokeWeight, finalPosX, finalPosY, finalStrokeWeight * 2, true );
      graphicElements.add( centerDot );
    }
    
    if( lineRatio > 0 ) {
      float startX = finalPosX - finalRadius;
      float endX = startX + lineSize;
      float startY = finalPosY;
      GraphicLine lLine = new GraphicLine( parentPattern, finalStrokeWeight, hlColor, startX, startY, endX, startY );
      graphicElements.add( lLine );
      
      endX = finalPosX + finalRadius;
      startX = endX - lineSize;
      GraphicLine rLine = new GraphicLine( parentPattern, finalStrokeWeight, hlColor, startX, startY, endX, startY );
      graphicElements.add( rLine );
      
      startX = finalPosX;
      startY = finalPosY - finalRadius;
      float endY = startY + lineSize;
      GraphicLine tLine = new GraphicLine( parentPattern, finalStrokeWeight, hlColor, startX, startY, startX, endY );
      graphicElements.add( tLine );
      
      endY = finalPosY + finalRadius;
      startY = endY - lineSize;
      GraphicLine bLine = new GraphicLine( parentPattern, finalStrokeWeight, hlColor, startX, startY, startX, endY );
      graphicElements.add( bLine );
    }
  }
  
}
