class move{
  int playerID = 0;
  Animation anim = new Animation();
  hitBox[] hitBoxes = new hitBox[0];
  int currentHitbox = 0;
  void use(){
    animFlag[] tempFlag = anim.checkFlag();
    if(tempFlag!=null){
      for(int i=0; i<tempFlag.length; i++){
        processFlag(tempFlag[i]);
      }
    }
  }
  void processFlag(animFlag flag){
    switch(flag.type){
      case 0:
        break;
      case 1:
        players[playerID].mom = flag.momDo.copy();
        break;
      case 2:
        players[playerID].mom.add(flag.momDo);
        break;
      case 3:
        currentHitbox++;
        break;
      case 4:
        currentHitbox=flag.hbStageSet;
        break;
    }
  }
}
