class PatternDotGrid extends SuperPatternGrid {
  
  // params
  float lineWeight;
  float dotSize;
  color baseColor;
  color highlightColor;
  
  // calculated
  float horizLines = 0;
  float vertLines = 0;
  
  
  
  // constructor
  PatternDotGrid( int sWidth, int sHeight, float margin, int cells, float lWeight, float dSize, color bColor, color hlColor ) {
    super( sWidth, sHeight, margin, PatternLineType.CROSSHATCH, cells, lWeight );
    
    this.lineWeight = lWeight;
    this.dotSize = dSize;
    this.baseColor = bColor;
    this.highlightColor = hlColor;
    
    doRandomizeTweens = true;
    //graphicTweenTime = 0.5;
    graphicTweenDelayMax = 0.65;
    
    horizLines = vertCells + 1;
    vertLines = horizCells + 1;
    
    // construct graphics
    float centerOffset = cellSize / 2;
    float startY = marginOffset + centerOffset;
    for( int row = 0; row < vertCells; row++ ) {
      float startX = marginOffset + offsetX + centerOffset;
      for( int col = 0; col < horizCells; col++ ) {
        boolean isHighlighted = ( row < 1 || row >= vertCells - 1 || col < 1 || col >= horizCells - 1 ) ? true : false;
        color dotColor = ( isHighlighted ) ? highlightColor : baseColor;
        GraphicCirc thisDot = new GraphicCirc( this, dotColor, 0, startX, startY, dotSize, true );
        GraphicRect thisBox = new GraphicRect( this, dotColor, 1, startX, startY, cellSize, cellSize, false, false, 0.15, lineWeight );
        if( isHighlighted ) {
          graphicElements.add( thisDot );
          graphicElements.add( thisBox );
        } else {
          graphicElements.add( 0, thisDot );
          graphicElements.add( 0, thisBox );
        }
        
        startX += cellSize;
      }
      startY += cellSize;
    }
    
    setGraphicDelays();
  }
  
}
