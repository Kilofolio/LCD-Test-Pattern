class PatternHex extends SuperPatternGrid {
  
  // params
  float lineWeight;
  color baseColor;
  color highlightColor;
  
  // calculated
  float horizLines = 0;
  float vertLines = 0;
  
   
  // constructor
  PatternHex( float margin, int cells, float lWeight, color bColor, color hlColor, PFont bFont, PFont hlFont, float tSize ) {
    super( margin, PatternLineType.CROSSHATCH, cells, lWeight );
    
    this.lineWeight = lWeight;
    this.baseColor = bColor;
    this.highlightColor = hlColor;
    
    //doRandomizeTweens = true;
    //graphicTweenTime = 0.5;
    //graphicTweenDelayMax = 0.6;
    
    horizLines = vertCells + 1;
    vertLines = horizCells + 1;
    
    // construct graphics
    
    // hex
    float radiusInc = 80;
    int totalShapes = floor( croppedHeight / radiusInc );
    float centerX = width / 2;
    float centerY = height / 2;
    float currentDiameter = croppedHeight;
    for( var i = 0; i < totalShapes; i++ ) {
      GraphicPolygon thisShape;
      if( i < totalShapes - 1 ) {
        boolean isBold = ( i == 0 );//( i % 5 < 1 ) ? true : false;
        float thisLineWeight = ( isBold ) ? lineWeight * 2 : lineWeight;
        PFont thisFont = ( isBold ) ? hlFont : bFont;
        thisShape = new GraphicPolygon( this, centerX, centerY, currentDiameter, 6, 6, 0, true, baseColor, thisLineWeight, thisFont, tSize, str( currentDiameter ), 0 );
      } else {
        thisShape = new GraphicPolygon( this, centerX, centerY, currentDiameter, 6, 6, 0, true, highlightColor, 0, hlFont, tSize, str( currentDiameter ), 0 );
      }
      thisShape.tweenSequenceRatio = 1 - ( float( i ) / totalShapes );
      graphicElements.add( thisShape );
      
      currentDiameter -= radiusInc;
    }
    
    // chevrons    
    float chevAreaWidth = ( croppedWidth - croppedHeight ) / 2;
    int chevCount = round( chevAreaWidth / radiusInc ) * 4;
    float chevAngle = TWO_PI / 6;
    float chevDiameter = croppedHeight * 0.35;
    float chevInc = chevAreaWidth / chevCount;
    //float initInset = ( chevAreaWidth / 2 ) + ( ( chevInc * chevCount ) / 2 ) + ( chevDiameter / 2 );
    float startX = width - marginOffset - ( chevDiameter / 2 );
    float startY = centerY;
    float initAngle = -chevAngle;
    for( var i = 0; i < chevCount; i++ ) {
      float thisLineWeight = ( i % 5 < 1 ) ? lineWeight * 2 : lineWeight;
      GraphicPolygon thisChev = new GraphicPolygon( this, startX, startY, chevDiameter, 6, 2, initAngle, false, highlightColor, thisLineWeight );
      thisChev.tweenSequenceRatio = 1 - ( float( i ) / chevCount );
      graphicElements.add( thisChev );
      
      startX -= chevInc;
    }
    
    startX = marginOffset + ( chevDiameter / 2 );
    initAngle += PI;
    for( var i = 0; i < chevCount; i++ ) {
      float thisLineWeight = ( i % 5 < 1 ) ? lineWeight * 2 : lineWeight;
      GraphicPolygon thisChev = new GraphicPolygon( this, startX, startY, chevDiameter, 6, 2, initAngle, false, highlightColor, thisLineWeight );
      thisChev.tweenSequenceRatio = 1 - ( float( i ) / chevCount );
      graphicElements.add( thisChev );
      
      startX += chevInc;
    }
    
    //GraphicPolygon thisChev = new GraphicPolygon( this, centerX, centerY, height/2, 6, 2, PI, false, color( 0, 255, 0 ), 5 );
    //thisChev.doShowReg = true;
    //graphicElements.add( thisChev );
    
    setGraphicDelays();
  }
  
}
