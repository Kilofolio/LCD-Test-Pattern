
//////////////////////////////////////////////////
//  Super Graphic Element
//////////////////////////////////////////////////

class SuperGraphicElement {
  
  // settings
  SuperPattern parentPattern;
  float finalPosX;
  float finalPosY;
  
  float tweenSequenceRatio = 0;
  
  // status
  float currentAlpha = 1;
  float currentPosX;
  float currentPosY;
  
  // tween
  Ani[] inOutTweenAni = new Ani[0];
  float tweenTime = 0.75;
  boolean isTweenComplete = true; 
  
  
  
  // constructor
  SuperGraphicElement( SuperPattern pPattern, float pX, float pY ) {
    this.parentPattern = pPattern;
    this.finalPosX = this.currentPosX = pX;
    this.finalPosY = this.currentPosY = pY;
  }
  
  
  
  // private functions
  protected void clearTweens() {
    isTweenComplete = false;
    for( int i=0; i < inOutTweenAni.length; i++ ) {
      if( inOutTweenAni[i].isPlaying() ) {
        inOutTweenAni[i].end();
      }
    }
  }
  
  
  
  // draw logic
  void draw() {}
  
  
  
  // public functions
  void show( float tTime, float delay ) {}
  
  void hide( float tTime, float delay ) {}
  
  
  
  // event handlers
  void onShowEnd() {    
    isTweenComplete = true;
    parentPattern.onGraphicShowComplete();
  }
  
  void onHideEnd() {    
    isTweenComplete = true;
    parentPattern.onGraphicHideComplete();
  }
  
}




//////////////////////////////////////////////////
//  Super Graphic Element Container
//////////////////////////////////////////////////


class SuperGraphicElementContainer extends SuperGraphicElement {
  
  // graphics
  ArrayList<SuperGraphicElement> graphicElements;
  
  
  
  // constructor
  SuperGraphicElementContainer( SuperPattern pPattern, float pX, float pY ) {
    super( pPattern, pX, pY );
    
    graphicElements = new ArrayList<SuperGraphicElement>();
  }
  
  
  
  // draw logic
  void draw() {    
    for( int i = 0; i < graphicElements.size(); i++ ) {
      graphicElements.get(i).draw();
    }
  }
  
  
  
  // public functions
  void show( float tTime, float delay ) {    
    this.tweenTime = tTime;
    
    clearTweens();
    
    for( int i = 0; i < graphicElements.size(); i++ ) {
      graphicElements.get(i).show( tTime, delay );
    }
  }
  
  void hide( float tTime, float delay ) {      
    this.tweenTime = tTime;
    
    clearTweens();
    
    for( int i = 0; i < graphicElements.size(); i++ ) {
      graphicElements.get(i).hide( tTime, delay );
    }
  }
  
}
