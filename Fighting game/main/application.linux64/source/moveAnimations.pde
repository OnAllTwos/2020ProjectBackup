//Direct Initializations
move jabr = new move();
move walkL = new move();
move walkR = new move();
move slowfall = new move();
move idleGround = new move();
move handsFall = new move();
move idleFall = new move();
//Direct Initializations


//Child Initializations
void initializeAnimations(){
  String[] jabrRaw = loadStrings("jab.txt");
  String[][] jabrInf = new String[jabrRaw.length][10];
  jabr.animation = new float[jabrRaw.length][10];
  for(int i=0; i<jabrRaw.length; i++){
    jabrInf[i] = split(jabrRaw[i], ',');
  }
  for(int i=0; i<jabrInf.length; i++){
    for(int j=0; j<jabrInf[1].length; j++){
      jabr.animation[i][j] = Float.parseFloat(jabrInf[i][j]);
    }
  }
  
  
  String[] walkLRaw = loadStrings("WalkR.txt");
  String[][] walkLInf = new String[walkLRaw.length][10];
  walkL.animation = new float[walkLRaw.length][10];
  for(int i=0; i<walkLRaw.length; i++){
    walkLInf[i] = split(walkLRaw[i], ',');
  }
  for(int i=0; i<walkLInf.length; i++){                    //This bit of code was just used to turn around the walking animation
    for(int j=0; j<walkLInf[1].length; j++){
      if(j==1){
        walkL.animation[i][j+1] = Float.parseFloat(walkLInf[i][j]) * -1;
      }
      if(j==2){
        walkL.animation[i][j-1] = Float.parseFloat(walkLInf[i][j]) * -1;
      }
      if(j==6){
        walkL.animation[i][j+1] = Float.parseFloat(walkLInf[i][j]) * -1;
      }
      if(j==7){
        walkL.animation[i][j-1] = Float.parseFloat(walkLInf[i][j]) * -1;
      }else{
        walkL.animation[i][j] = Float.parseFloat(walkLInf[i][j]);
      }
    }
  }
  
  
  String[] walkRRaw = loadStrings("WalkR.txt");           //Load each line from the file to this string array
  String[][] walkRInf = new String[walkRRaw.length][10];  //2d array
  walkR.animation = new float[walkRRaw.length][10];       //Declaring animation
  for(int i=0; i<walkRRaw.length; i++){                   //Go through each line of the raw info, splitting at commas and writing to the 2d array
    walkRInf[i] = split(walkRRaw[i], ',');
  }
  for(int i=0; i<walkRInf.length; i++){                   //Pass the values from this 2d array into the animation
    for(int j=0; j<walkRInf[1].length; j++){
      walkR.animation[i][j] = Float.parseFloat(walkRInf[i][j]);
    }
  }
  
  
  String[] slowfallRaw = loadStrings("Slowfall.txt");      //Same thing as above for the rest of these.
  String[][] slowfallInf = new String[slowfallRaw.length][10];
  slowfall.animation = new float[slowfallRaw.length][10];
  for(int i=0; i<slowfallRaw.length; i++){
    slowfallInf[i] = split(slowfallRaw[i], ',');
  }
  for(int i=0; i<slowfallInf.length; i++){
    for(int j=0; j<slowfallInf[1].length; j++){
      slowfall.animation[i][j] = Float.parseFloat(slowfallInf[i][j]);
    }
  }
  
  
  String[] IdleGroundRaw = loadStrings("idleGround.txt");
  String[][] IdleGroundInf = new String[IdleGroundRaw.length][10];
  idleGround.animation = new float[IdleGroundRaw.length][10];
  for(int i=0; i<IdleGroundRaw.length; i++){
    IdleGroundInf[i] = split(IdleGroundRaw[i], ',');
  }
  for(int i=0; i<IdleGroundInf.length; i++){
    for(int j=0; j<IdleGroundInf[1].length; j++){
      idleGround.animation[i][j] = Float.parseFloat(IdleGroundInf[i][j]);
    }
  }
  
  
  String[] HandsFallRaw = loadStrings("handsUpFall.txt");
  String[][] HandsFallInf = new String[HandsFallRaw.length][10];
  handsFall.animation = new float[HandsFallRaw.length][10];
  for(int i=0; i<HandsFallRaw.length; i++){
    HandsFallInf[i] = split(HandsFallRaw[i], ',');
  }
  for(int i=0; i<HandsFallInf.length; i++){
    for(int j=0; j<HandsFallInf[1].length; j++){
      handsFall.animation[i][j] = Float.parseFloat(HandsFallInf[i][j]);
    }
  }
  
  
  String[] IdleFallRaw = loadStrings("idleFall.txt");
  String[][] IdleFallInf = new String[IdleFallRaw.length][10];
  idleFall.animation = new float[IdleFallRaw.length][10];
  for(int i=0; i<IdleFallRaw.length; i++){
    IdleFallInf[i] = split(IdleFallRaw[i], ',');
  }
  for(int i=0; i<IdleFallInf.length; i++){
    for(int j=0; j<IdleFallInf[1].length; j++){
      idleFall.animation[i][j] = Float.parseFloat(IdleFallInf[i][j]);
    }
  }  
  walkR.instantCancel = true;
  walkL.instantCancel = true;
  idleGround.instantCancel = true;
}

void delay(){
  
}