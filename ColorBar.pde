
class ColorBarData {
  
  color barColor;
  color textColor;
  String labelText;
  PFont font;
  float fontSize;
  
  ColorBarData( color bColor, color tColor, String lText, PFont font, float fSize ) {
    this.barColor = bColor;
    this.textColor = tColor;
    this.labelText = lText;
    this.font = font;
    this.fontSize = fSize;
  }
  
}





//////////////////////////////////////////////////
//  Color Bar
//////////////////////////////////////////////////

class ColorBar extends SuperGraphicElement {
  
  // settings
  float finalWidth;
  float finalHeight;
  float lineWeight;
  color finalBarColor;
  color finalLineColor;
  
  // status
  float currentWidth = 0;
  float currentHeight = 0;
  
  // sub-graphics

  
  
  // constructor
  ColorBar( SuperPattern pPattern, color bColor, float pX, float pY, float fWidth, float fHeight ) {
    super( pPattern, pX, pY );
    
    this.finalBarColor = bColor;
    this.finalWidth = this.currentWidth = fWidth;
    this.finalHeight = this.currentHeight = fHeight;
  }
  
  
  
  // draw logic
  void draw() {    
    canvas.noStroke();
    color barColorWithAlpha = color( red( finalBarColor ), green( finalBarColor ), blue( finalBarColor ), currentAlpha );
    canvas.fill( barColorWithAlpha );
    canvas.rect( currentPosX, currentPosY, currentWidth, currentHeight );
    canvas.noFill();
    
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {
    //println( "ColorBar: show( " + tTime + ", " + delay + ")" );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentWidth = 0;
    currentPosX = finalPosX + finalWidth / 2;
    currentPosY = finalPosY;
    String propList = "currentAlpha:255,currentWidth:" + finalWidth + ",currentPosX:" + finalPosX;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {
    //println( "ColorBar: show( " + tTime + ", " + delay + ")" );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    float endPosX = finalPosX + finalWidth / 2;
    String propList = "currentAlpha:1,currentWidth:0,currentPosX:" + (finalPosX + finalWidth) + ",currentPosX:" + endPosX;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}




//////////////////////////////////////////////////
//  Color Bar Label
//////////////////////////////////////////////////

class ColorBarLabel extends SuperGraphicElement {
  
  // settings
  float finalWidth;
  float finalHeight;
  ColorBarData barData;
  
  float textX;
  float textY;
  
  float notchWidth;
  float notchHeight;
  
  // status
  float currentWidth = 0;
  float currentHeight = 0;
  
  // sub-graphics
  PShape barShape;
  
  
  // constructor
  ColorBarLabel( SuperPattern pPattern, ColorBarData data, float pX, float pY, float fWidth, float fHeight ) {
    super( pPattern, pX, pY );
    
    this.barData = data;
    this.finalWidth = this.currentWidth = fWidth;
    this.finalHeight = this.currentHeight = fHeight;
        
    notchWidth = barData.fontSize * 2;
    notchHeight = notchWidth * ( barData.labelText.length() * 0.42 );
    
    textX = finalPosX + notchWidth / 2;
    textY = finalPosY + notchHeight / 2;
    
    barShape = createShape();
    barShape.beginShape();
    barShape.vertex( notchWidth, 0 );
    barShape.vertex( notchWidth, notchHeight );
    barShape.vertex( 0, notchWidth + notchHeight );
    barShape.vertex( 0, finalHeight );
    //barShape.vertex( finalWidth, finalHeight );
    barShape.vertex( finalWidth - notchWidth, finalHeight );
    barShape.vertex( finalWidth, finalHeight - notchWidth );
    barShape.vertex( finalWidth, 0 );
    barShape.endShape();
    barShape.setFill( barData.barColor );
    
    
  }
  
  // draw logic
  void draw() {    
    canvas.noStroke();
    
    //color barColor = barData.barColor;
    //color barColorWithAlpha = color( red( barColor ), green( barColor ), blue( barColor ), currentAlpha );
    //fill( barColorWithAlpha );
    canvas.shape( barShape, currentPosX, currentPosY, currentWidth, currentHeight );
    
    canvas.textFont( barData.font );
    canvas.textSize( barData.fontSize );
    canvas.textAlign( CENTER, CENTER );
    
    color textColor = barData.textColor;
    color textWithAlpha = color( red( textColor ), green( textColor ), blue( textColor ), currentAlpha );
    canvas.fill( textWithAlpha );
    canvas.pushMatrix();
    canvas.translate( textX, textY );
    canvas.rotate( -HALF_PI );
    canvas.text( barData.labelText, 0, 0 );
    canvas.popMatrix();
    
    canvas.noFill();
    
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {
    //println( "ColorBar: show( " + tTime + ", " + delay + ")" );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    currentWidth = 0;
    currentPosX = finalPosX + finalWidth / 2;
    currentPosY = finalPosY;
    String propList = "currentAlpha:255,currentWidth:" + finalWidth + ",currentPosX:" + finalPosX;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_OUT, this, "onEnd:onShowEnd" );
  }
  
  void hide( float tTime, float delay ) {
    //println( "ColorBar: show( " + tTime + ", " + delay + ")" );
    
    this.tweenTime = tTime;
    
    clearTweens();
    
    float endPosX = finalPosX + finalWidth / 2;
    String propList = "currentAlpha:1,currentWidth:0,currentPosX:" + (finalPosX + finalWidth) + ",currentPosX:" + endPosX;
    inOutTweenAni = Ani.to( this, tweenTime, delay, propList, Ani.SINE_IN, this, "onEnd:onHideEnd" ); 
  }
  
}
