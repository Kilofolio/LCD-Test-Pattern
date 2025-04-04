static class PatternLineType {
  static int CROSSHATCH = 0;
  static int HORIZONTAL = 1;
  static int VERTICAL = 2; 
}


static class Direction {
  static int HORIZONTAL = 0;
  static int VERTICAL = 1; 
}

static class TargetShape {
  static int NONE = 0;
  static int CIRCLE = 1;
  static int RECTANGLE = 2; 
}


String getNumberString( float number, int strLength ) {
  String str = str( round( number ) );
  while( str.length() < strLength ) {
    str = "0" + str;
  }
  return str;
}




FloatList generateDelayList( float delayTotalTime, int graphicElementCount ) {
  FloatList delayList = new FloatList();
  float delayInc = delayTotalTime / graphicElementCount;
  float runningDelay = 0;
  for( int i=0; i < graphicElementCount; i++ ) {
    delayList.append( runningDelay );
    runningDelay += delayInc;
  }
  delayList.shuffle();
  
  return delayList;
}



class Timer {
  int fullDuration = 0;
  int currentDuration = 0;
  boolean isRunning = false;
  
  int lastMillis = 0;

  Timer( int duration ) {
    this.fullDuration = duration;
  }
  
  void start( int duration ) {
    this.fullDuration = duration;
    start();
  }
  
  void start() {
    currentDuration = 0;
    lastMillis = millis();
    isRunning = true;
  }
  
  void pause() {
    isRunning = false;
  }
  
  void stop() {
    isRunning = false;
    currentDuration = 0;
  }
  
  void draw() {
    if( isRunning ) {
      int milliInterval = millis() - lastMillis;
      currentDuration += milliInterval;
      if( currentDuration >= fullDuration ) {
        isRunning = false;
        currentDuration = fullDuration;
        lastMillis = 0;
      } else {
        lastMillis = millis();
      }
    }
  }
  
  float progress() {
    return float( currentDuration ) / float( fullDuration );
  }
}
