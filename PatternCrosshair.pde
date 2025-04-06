class PatternCrosshair extends SuperPatternGrid {
  
  // params
  float lineWeight;
  color baseColor;
  color highlightColor;
  
  // calculated
  float horizLines = 0;
  float vertLines = 0;
  
  
  
  // constructor
  PatternCrosshair( PGraphics pg, int sWidth, int sHeight, float margin, int cells, float lWeight, color bColor, color hlColor ) {
    super( pg, sWidth, sHeight, margin, PatternLineType.CROSSHATCH, cells, lWeight );
    
    this.lineWeight = lWeight;
    this.baseColor = bColor;
    this.highlightColor = hlColor;
    
    horizLines = vertCells + 1;
    vertLines = horizCells + 1;
    
    graphicTweenDelayMax = 0.6;
    
    // construct graphics
    
    // edge grids
    float barSize = cellSize * 1/3;
    float left = marginOffset;
    float right = graphicsWidth - marginOffset - barSize;
    float top = marginOffset;
    float bottom = graphicsHeight - marginOffset - barSize;
    GraphicDashedBar topBar = new GraphicDashedBar( this, baseColor, lineWeight, left, top, croppedWidth, barSize, ceil( horizCells ) );
    graphicElements.add( topBar );
    GraphicDashedBar bottomBar = new GraphicDashedBar( this, baseColor, lineWeight, left, bottom, croppedWidth, barSize, ceil( horizCells ) );
    graphicElements.add( bottomBar );
    GraphicDashedBar leftBar = new GraphicDashedBar( this, baseColor, lineWeight, left, top, barSize, croppedHeight, ceil( vertCells ) );
    graphicElements.add( leftBar );
    GraphicDashedBar rightBar = new GraphicDashedBar( this, baseColor, lineWeight, right, top, barSize, croppedHeight, ceil( vertCells ) );
    graphicElements.add( rightBar );
    
    
    // rings
    float startX = graphicsWidth / 2;
    float startY = graphicsHeight / 2;
    float ringSize = croppedHeight * 0.65;
    //GraphicCirc centerRing = new GraphicCirc( this, highlightColor, lineWeight, startX, startY, ringSize, false );
    GraphicRect centerRing = new GraphicRect( this, highlightColor, 0, startX, startY, ringSize, ringSize, false, true, 0.1, lineWeight );
    centerRing.tweenSequenceRatio = 0.2;
    graphicElements.add( centerRing );
    
    float knockoutCells = ceil( vertCells / 3 );
    float rulerKnockout = knockoutCells * cellSize;
    ringSize = rulerKnockout;
    float crossRatio = 0.9;
    GraphicCrosshair centCrosshair = new GraphicCrosshair( this, highlightColor, highlightColor, lineWeight, startX, startY, ringSize, TargetShape.RECTANGLE, crossRatio, true );
    centCrosshair.tweenSequenceRatio = 0.9;
    graphicElements.add( centCrosshair );
    
    // corner markers
    crossRatio = 0.5;
    ringSize = croppedHeight * 0.15;
    float circOffset = croppedHeight / 6;
    startX = marginOffset + circOffset;
    startY = marginOffset + circOffset;
    GraphicCrosshair tlCrosshair = new GraphicCrosshair( this, baseColor, baseColor, lineWeight, startX, startY, ringSize, TargetShape.NONE, crossRatio, true );
    tlCrosshair.tweenSequenceRatio = 0.5;
    graphicElements.add( tlCrosshair );
    
    startX = croppedWidth - marginOffset - circOffset;
    GraphicCrosshair trCrosshair = new GraphicCrosshair( this, baseColor, baseColor, lineWeight, startX, startY, ringSize, TargetShape.NONE, crossRatio, true );
    trCrosshair.tweenSequenceRatio = 0.6;
    graphicElements.add( trCrosshair );
    
    startY = croppedHeight - marginOffset - circOffset;
    GraphicCrosshair brCrosshair = new GraphicCrosshair( this, baseColor, baseColor, lineWeight, startX, startY, ringSize, TargetShape.NONE, crossRatio, true );
    brCrosshair.tweenSequenceRatio = 0.7;
    graphicElements.add( brCrosshair );
    
    startX = marginOffset + circOffset;
    GraphicCrosshair blCrosshair = new GraphicCrosshair( this, baseColor, baseColor, lineWeight, startX, startY, ringSize, TargetShape.NONE, crossRatio, true );
    blCrosshair.tweenSequenceRatio = 0.8;
    graphicElements.add( blCrosshair );
    
    
    // crosshair
    float rulerDepth = croppedHeight * 1/8;
    float rulerWidth = ( ( croppedWidth - ( barSize * 2 ) ) - rulerKnockout ) / 2;
    float rulerHeight = ( ( croppedHeight - ( barSize * 2 ) ) - rulerKnockout ) / 2;
    startX = marginOffset + barSize;
    startY = ( graphicsHeight / 2 ) - ( rulerDepth / 2 );
    GraphicRuledLine hRuleLeft = new GraphicRuledLine( this, lineWeight, baseColor, startX, startY, rulerWidth, rulerDepth, ceil( ( horizCells - knockoutCells ) / 2 ), 5, 1 );
    hRuleLeft.tweenSequenceRatio = 0.5;
    graphicElements.add( hRuleLeft );
    
    startX = croppedWidth - marginOffset - barSize - rulerWidth;
    GraphicRuledLine hRuleRight = new GraphicRuledLine( this, lineWeight, baseColor, startX, startY, rulerWidth, rulerDepth, ceil( ( horizCells - knockoutCells ) / 2 ), 5, -1 );
    hRuleRight.tweenSequenceRatio = 0.6;
    graphicElements.add( hRuleRight );
    
    startX = ( graphicsWidth / 2 ) - ( rulerDepth / 2 ); 
    startY = marginOffset + barSize;
    GraphicRuledLine vRuleTop = new GraphicRuledLine( this, lineWeight, baseColor, startX, startY, rulerDepth, rulerHeight, ceil( ( vertCells - knockoutCells ) / 2 ), 5, 1 );
    vRuleTop.tweenSequenceRatio = 0.7;
    graphicElements.add( vRuleTop );
    
    startY = croppedHeight - marginOffset - barSize - rulerHeight;
    GraphicRuledLine vRuleBottom = new GraphicRuledLine( this, lineWeight, baseColor, startX, startY, rulerDepth, rulerHeight, ceil( ( vertCells - knockoutCells ) / 2 ), 5, -1 );
    vRuleBottom.tweenSequenceRatio = 0.8;
    graphicElements.add( vRuleBottom );
    
    
    setGraphicDelays();
  }
  
}
