
//////////////////////////////////////////////////
//  Title Card
//////////////////////////////////////////////////

class TitleCard extends SuperPattern {
  
  // settings
  LCDTestPatterns mainController;
  
  
  TitleCard( PGraphics pg, int sWidth, int sHeight, float margin, LCDTestPatterns main, PFont font1, color bgColor, color fgColor )  {
    super( pg, sWidth, sHeight, margin );
    
    this.mainController = main;
    
    this.doInvertHideDealys = true;
    
    // background
    float startX = graphicsWidth / 2;
    float startY = graphicsHeight / 2;
    GraphicRect bg = new GraphicRect( this, bgColor, 0, startX, startY, croppedWidth, croppedHeight, true, false );
    bg.tweenSequenceRatio = 0;
    graphicElements.add( bg );
    
    // caution tape
    float cautionWidth = croppedWidth;
    float cautionHeight = croppedHeight / 16;
    startX = graphicsWidth / 2;
    startY = graphicsHeight - marginOffset - ( cautionHeight / 2 );
    float cautionWeight = cautionHeight;
    CautionTape cTapeBottom = new CautionTape( this, fgColor, cautionWeight, startX, startY, cautionWidth, cautionHeight, true, 1.5, 1 );
    cTapeBottom.tweenSequenceRatio = 0.5;
    graphicElements.add( cTapeBottom );
    
    startY = marginOffset + ( cautionHeight / 2 );
    CautionTape cTapeTop = new CautionTape( this, fgColor, cautionWeight, startX, startY, cautionWidth, cautionHeight, true, 1.5, -1 );
    cTapeTop.tweenSequenceRatio = 0.5;
    graphicElements.add( cTapeTop );
    
    // text
    float textSize1 = ceil( graphicsWidth / 16 );
    float textSize2 = ceil( graphicsWidth / 32 );
    startX = graphicsWidth / 2;
    startY = graphicsHeight / 2 - ( textSize1 / 2 );
    TextLabel label1 = new TextLabel( this, startX, startY, font1, textSize1, fgColor, "CALIBRATION PROCESS" );
    label1.tweenSequenceRatio = 0.85;
    graphicElements.add( label1 );
    
    startY += textSize1;
    TextLabel label2 = new TextLabel( this, startX, startY, font1, textSize2, fgColor, "FOR INTERNAL USE ONLY // SCREECH INC." );
    label2.tweenSequenceRatio = 1;
    graphicElements.add( label2 );
    
    setGraphicDelays();
  }
  
}





//////////////////////////////////////////////////
//  Text Label
//////////////////////////////////////////////////

class TextLabel extends SuperGraphicElement {
  
  // settings
  PFont font;
  float textSize;
  String labelText;
  color finalColor;
  
  // status
  float currentAlpha = 1;
  
  
  
  TextLabel( SuperPattern pPattern, float pX, float pY, PFont font, float tSize, color tColor, String lText ) {
    super( pPattern, pX, pY );
    
    this.font = font;
    this.textSize = tSize;
    this.finalColor = tColor;
    this.labelText = lText;
  }
  
  void draw() {
    canvas.noStroke();
    
    color textWithAlpha = color( red( finalColor ), green( finalColor ), blue( finalColor ), currentAlpha );
    canvas.fill( textWithAlpha );
    canvas.textFont( font );
    canvas.textSize( textSize );
    canvas.textAlign( CENTER, CENTER );
    
    canvas.pushMatrix();
    canvas.translate( finalPosX, finalPosY );
    canvas.text( labelText, 0, 0 );
    canvas.popMatrix();
  }
  
  
  // public functions
  void show( float tTime, float delay ) {
    //println( "ColorBar: show( " + tTime + ", " + delay + ")" );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentAlpha = 1;
    String propList = "currentAlpha:255";
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {
    //println( "ColorBar: show( " + tTime + ", " + delay + ")" );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    String propList = "currentAlpha:1";
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
  
}
