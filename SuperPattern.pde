
//////////////////////////////////////////////////
//  Super Pattern
//////////////////////////////////////////////////

class SuperPattern {
  
  // settings
  int marginOffset;
  int croppedWidth;
  int croppedHeight;
  boolean doRandomizeTweens = false;
  boolean doInvertHideDealys = false;
  
  // status
  float tweenAlpha = 1;
  
  // tween
  boolean isActive = false;
  
  float graphicTweenTime = 0.5;
  float graphicTweenInterval = 0.10;
  float graphicTweenDelayMax = 0.5;
  
  // graphics
  ArrayList<SuperGraphicElement> graphicElements;
  
  
  
  // constructor
  SuperPattern( float margin ) {
    this.marginOffset = round( margin * width );
    this.croppedWidth = width - (marginOffset * 2);
    this.croppedHeight = height - (marginOffset * 2);
    
    graphicElements = new ArrayList<SuperGraphicElement>();
  }
  
  void setGraphicDelays() {
    this.graphicTweenInterval = graphicTweenDelayMax / graphicElements.size();
  }
  
  
  // draw logic
  void draw() {
    for( int i = 0; i < graphicElements.size(); i++ ) {
      graphicElements.get(i).draw();
    }
  }
  
  
  
  // public functions
  void show( float initDelay ) {
    isActive = true;
    if( doRandomizeTweens ) {
      FloatList delayList = generateDelayList( graphicTweenDelayMax,  graphicElements.size() );
      delayList.shuffle();
      for( int i = 0; i < graphicElements.size(); i++ ) {
        graphicElements.get(i).show( graphicTweenTime, delayList.get( i ) + initDelay );
      }
    } else {
      for( int i = 0; i < graphicElements.size(); i++ ) {
        SuperGraphicElement thisElement = graphicElements.get(i);
        float thisDelay = thisElement.tweenSequenceRatio * graphicTweenDelayMax;
        thisElement.show( graphicTweenTime, thisDelay + initDelay );
      }
    }
    
  }
  
  void hide( float initDelay ) {
    if( doRandomizeTweens ) {
      FloatList delayList = generateDelayList( graphicTweenDelayMax,  graphicElements.size() );
      delayList.shuffle();
      for( int i = 0; i < graphicElements.size(); i++ ) {
        graphicElements.get(i).hide( graphicTweenTime, delayList.get( i ) );
      }
    } else {
      for( int i = 0; i < graphicElements.size(); i++ ) {
        SuperGraphicElement thisElement = graphicElements.get(i);
        float thisDelay = ( doInvertHideDealys ) ? 1 - ( thisElement.tweenSequenceRatio ) * graphicTweenDelayMax : thisElement.tweenSequenceRatio * graphicTweenDelayMax;
        thisElement.hide( graphicTweenTime, thisDelay );
      }
    }
  }
  
  
  
  // event handlers
  void onGraphicShowComplete() {
    // TODO: show complete
  }
  
  void onGraphicHideComplete() {
    boolean allComplete = true;
    for( int i = 0; i < graphicElements.size(); i++ ) {
      if( !graphicElements.get(i).isTweenComplete ) {
        allComplete = false;
      }
    }
    if( allComplete ) {
      isActive = false;
    }
  }
  
}





//////////////////////////////////////////////////
//  Super Pattern Grid
//////////////////////////////////////////////////

class SuperPatternGrid extends SuperPattern {
  
  // params
  int patternType;
  int cellCount;
  
  // calculated
  float cellSize;
  float cellWidth;
  float cellHeight;
  float horizCells = 0;
  float vertCells = 0;
  float offsetX = 0;
  
  
  
  // constructor
  SuperPatternGrid( float margin, int pType, int cells, float lWeight ) {
    super( margin );
    
    marginOffset += lWeight / 2;
    croppedWidth -= lWeight;
    croppedHeight -= lWeight;
    
    this.patternType = pType;
    this.cellCount = cells;
    
    if( cellCount > 0 ) {
      if( patternType == PatternLineType.CROSSHATCH || patternType == PatternLineType.HORIZONTAL ) {
        cellSize = croppedHeight / float( cellCount );
        vertCells = cellCount;
        if ( patternType == PatternLineType.CROSSHATCH ) {
            horizCells = floor( croppedWidth / cellSize );
            offsetX = ( croppedWidth - ( horizCells * cellSize ) ) / 2;
        }
      } else {
        cellSize = croppedWidth / float( cellCount );
        horizCells = cellCount;
      }
  
      cellWidth = croppedWidth / horizCells;
      cellHeight = croppedHeight / vertCells;
    }
  }
    
}
