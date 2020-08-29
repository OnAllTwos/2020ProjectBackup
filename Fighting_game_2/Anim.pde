class animFlag{
  int type=0;  //Type 0 = Null flag, 1 = momentum Set, 2 = momentum Add, 3 = Hitbox stage increment, 4 = To Hitbox Stage at hbStage
  int hbStageSet=0;
  PVector momDo = new PVector(0,0);
}
class Animation{
  int frameTimer=0;
  int currentFrame=0;
  PImage[] frames;
  int[] delays;
  boolean flagSet = false;  //Set this back to false each time currentFrame changes!
  animFlag[][] flags = new animFlag[0][0]; //First index = Set of flags for that frame, Second index = 
  animFlag[] checkFlag(){
    if(flags[currentFrame]!=null && flagSet==false){
      flagSet = true;
      return flags[currentFrame];
    }
    return null;
  }
}
