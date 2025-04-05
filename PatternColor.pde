
//////////////////////////////////////////////////
//  Pattern Color SMPTE
//////////////////////////////////////////////////

class PatternColorSMPTE extends SuperPattern {

  float barFill;
  float barSpace;
  float barWidth;
  
  color[] colorsRow1 = {
    color( 192, 192, 192 ),
    color( 192, 192, 0 ),
    color( 0, 192, 192 ),
    color( 0, 192, 0 ),
    color( 192, 0, 192 ),
    color( 192, 0, 0 ),
    color( 0, 0, 192 )
  };
  color[] colorsRow2 = {
    color( 0, 0, 192 ),
    color( 19, 19, 19 ),
    color( 192, 0, 192 ),
    color( 19, 19, 19 ),
    color( 0, 192, 192 ),
    color( 19, 19, 19 ),
    color( 192, 192, 192 )
  };
  color[] colorsRow3 = {
    color( 0, 33, 76 ),
    color( 255, 255, 255 ),
    color( 50, 0, 106 ),
    color( 19, 19, 19 ),
    color( 9, 9, 9 ),
    color( 19, 19, 19 ),
    color( 29, 29, 29 ),
    color( 19, 19, 19 )
  };
  
  
  
  // constructor
  PatternColorSMPTE( int sWidth, int sHeight, float margin ) {
    super( sWidth, sHeight, margin );
    
    doRandomizeTweens = true;
    
    // construct graphics
    
    // row 1
    float row1BarWidth = croppedWidth / 7;
    float row1BarHeight = croppedHeight * 8/12;
    float startX = marginOffset;
    float startY = marginOffset;
    for( int i = 0; i < colorsRow1.length; i++ ) {   
      ColorBar thisBar;
      thisBar = new ColorBar( this, colorsRow1[i], startX, startY, row1BarWidth, row1BarHeight );
      graphicElements.add( thisBar );
      
      startX += row1BarWidth;
    }
    
    // row 2
    float row2BarWidth = row1BarWidth;
    float row2BarHeight = croppedHeight * 1/12;
    startX = marginOffset;
    startY += row1BarHeight;
    for( int i = 0; i < colorsRow2.length; i++ ) {   
      ColorBar thisBar;
      thisBar = new ColorBar( this, colorsRow2[i], startX, startY, row2BarWidth, row2BarHeight );
      graphicElements.add( thisBar );
      
      startX += row2BarWidth;
    }
    
    // row 3
    float row3BarWidth1 = row1BarWidth * 5/4;
    float row3BarWidth2 = row1BarWidth * 1/3;
    float row3BarWidth3 = row1BarWidth;
    float row3BarHeight = croppedHeight * 3/12;
    startX = marginOffset;
    startY += row2BarHeight;
    for( int i = 0; i < colorsRow2.length; i++ ) {   
      ColorBar thisBar;
      float thisBarWidth;
      if( i < 4 ) {
        thisBarWidth = row3BarWidth1;
      } else if( i < 7 ) {
        thisBarWidth = row3BarWidth2;
      } else {
        thisBarWidth = row3BarWidth3;
      }
      thisBar = new ColorBar( this, colorsRow3[i], startX, startY, thisBarWidth, row3BarHeight );
      graphicElements.add( thisBar );
      
      startX += thisBarWidth;
    }
    
    
    setGraphicDelays();
  }
  
}




//////////////////////////////////////////////////
//  Color Bars Labeled
//////////////////////////////////////////////////

class PatternColorLabeled extends SuperPattern {

  float barFill;
  float barSpace;
  float barWidth;
  PFont font;
  float fontSize;
  float barGap;
  
  int cValHigh = 16;
  int cValLow = 210;
  
  color[] colorsRow1 = {
    color( cValLow, cValLow, cValLow ),
    color( cValLow, cValLow, cValHigh ),
    color( cValHigh, cValLow, cValLow ),
    color( cValHigh, cValLow, cValHigh ),
    color( cValLow, cValHigh, cValLow ),
    color( cValLow, cValHigh, cValHigh ),
    color( cValHigh, cValHigh, cValLow )
  };
  
  
  
  // constructor
  PatternColorLabeled( int sWidth, int sHeight, float margin, PFont tFont, float tSize, float bGap ) {
    super( sWidth, sHeight, margin );
    
    this.font = tFont;
    this.fontSize = tSize;
    this.barGap = bGap;
        
    // construct graphics
    
    // row 1
    float row1Count = float( colorsRow1.length );
    float row1BarWidth = ( croppedWidth - ( barGap * ( row1Count + 1 ) ) ) / row1Count;
    float row1BarHeight = croppedHeight - ( barGap * 2 );
    float startX = marginOffset + barGap;
    float startY = marginOffset + barGap;
    for( int i = 0; i < colorsRow1.length; i++ ) {   
      ColorBarLabel thisBar;
      color thisColor = colorsRow1[i];
      String textString = getNumberString( red( thisColor ), 3 ) + "." + getNumberString( green( thisColor ), 3 ) + "." + getNumberString( blue( thisColor ), 3 );
      ColorBarData thisData = new ColorBarData( thisColor, thisColor, textString, tFont, fontSize );
      thisBar = new ColorBarLabel( this, thisData, startX, startY, row1BarWidth, row1BarHeight );
      thisBar.tweenSequenceRatio = float( i ) / row1Count;
      graphicElements.add( thisBar );
      
      startX += row1BarWidth + barGap;
    }
    
    
    setGraphicDelays();
  }
  
}





//////////////////////////////////////////////////
//  Color Bars Labeled
//////////////////////////////////////////////////

class PatternGraysacle extends SuperPattern {

  float barFill;
  float barSpace;
  float barWidth;
  PFont font;
  float fontSize;
  float barGap;
  
  float[] valuesRow1 = {
    0,
    8,
    16,
    36,
    56,
    76,
    96,
    116,
    136,
    156,
    176,
    196,
    216,
    236,
    245,
    255
  };
  
  float[] valuesRow2 = {
    255,
    245,
    236,
    216,
    196,
    176,
    156,
    136,
    116,
    96,
    76,
    56,
    36,
    16,
    8,
    0
  };
  
  float[][] allRowValues = {
    valuesRow1,
    valuesRow2
  };
    
  // constructor
  PatternGraysacle( int sWidth, int sHeight, float margin, PFont tFont, float tSize, float bGap ) {
    super( sWidth, sHeight, margin );
    
    this.font = tFont;
    this.fontSize = tSize;
    this.barGap = bGap;
    
    graphicTweenDelayMax = 0.65;
    
    color labelColor = color( 239 );

    // construct graphics

    float rowTotal = float( allRowValues.length );
    float barHeight = ( croppedHeight / rowTotal ) - ( barGap * ( rowTotal ) );
    float startX = marginOffset + barGap;
    float startY = marginOffset + barGap;
    float runningDelay = 0;
    
    for( int i = 0; i < allRowValues.length; i++ ) {
      boolean isEven = ( i % 2 > 0 );
      float rowCount = float( allRowValues[ i ].length );
      float barWidth = ( croppedWidth - ( barGap * ( rowCount + 1 ) ) ) / rowCount;
      float delayInc = 1 / rowCount;
      runningDelay = ( isEven ) ? graphicTweenDelayMax : 0;
      for( int j = 0; j < rowCount; j++ ) {   
        ColorBarLabel thisBar;
        float thisColorValue =  allRowValues[i][j];
        color barColor = color( thisColorValue, thisColorValue, thisColorValue );
        String barLabelText = getNumberString( thisColorValue, 3 );
        ColorBarData thisData = new ColorBarData( barColor, labelColor, barLabelText, tFont, fontSize );
        thisBar = new ColorBarLabel( this, thisData, startX, startY, barWidth, barHeight );
        thisBar.tweenSequenceRatio = runningDelay;
        graphicElements.add( thisBar );
        
        startX += barWidth + barGap;
        runningDelay = ( isEven ) ? runningDelay - delayInc : runningDelay + delayInc;
      }
      startX = marginOffset + barGap;
      startY += barHeight + barGap;
    }    
    
    setGraphicDelays();
  }
  
}
