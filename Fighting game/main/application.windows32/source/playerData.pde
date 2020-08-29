class player{
  color hurtBoxColor = color(0,0,255,128);
  color hitBoxColor = color(255,0,0,128);
  boolean movingR = false;        //Is th player moving right?
  boolean jumping = false;
  boolean movingL = false;        //Is the player moving left?
  boolean fastFalling = false; 
  boolean idleFalling = false;    //Used to decide which falling animation to use
  boolean canDJ = true;    //Does the player have thier double jump?
  PVector hPos;            //Position of head
  PVector fPos = new PVector(0,0);  //Position of feet; Used to check for ground collision
  int moveFrame;           //The current frame of the current move
  int movePhase;           //The current phase of the current move animation (Frame)
  move currentMove;        //The current move being used
  float[] currentPhase;    //The values of the current phase of the current move (Frame)
  boolean moveProg;        //Whether or not a move is in progress
  boolean slowFalling;
  boolean onGround = false;
  PVector mom = new PVector(0,0);  //Player's momentum
  limb[] limbs = new limb[10];  //0-head, 1/2-left/right arm, 3/4-left/right forearm, 5-torso, 6/7-left/right thigh, 8/9-left/right lower leg; Prototyping, so lower legs and forearms are not in use yet.
  void initializeLimbs(){  //Mostly here to make modifying size values easier
    for(int i=0; i<limbs.length; i++){
      limbs[i] = new limb();
    }
    limbs[0].size = new PVector(40,40);            //Not much to say here... Size values, use negative values to change the corner from which a rectangle is drawn
    limbs[1].size = new PVector(80,30);
    limbs[2].size = new PVector(-80,30);
    limbs[5].size = new PVector(60,100);
    limbs[6].size = new PVector(30,80);
    limbs[7].size = new PVector(-30,80);
  }
  void PlaceLimbs(){  //Use this to calculate the positions of each limb; Position of head and size of all limbs REQUIRED!
  fill(255);
    limbs[5].pos.x = hPos.x-(limbs[5].size.x/2); //Centers the torso relative to the head
    limbs[5].pos.y = hPos.y+(limbs[0].size.y/2);  //Puts torso right below head
    limbs[0].pos.x = limbs[5].pos.x+(cos(radians(limbs[5].angle)+atan2(limbs[0].size.y/2,limbs[5].size.x/2))*(sqrt(pow(limbs[5].size.x/2,2)+pow(limbs[0].size.y/2,2))));    //This math is necessary to ensure that the arm is always attached to the torso
    limbs[0].pos.y = limbs[5].pos.y+(sin(radians(limbs[5].angle)+atan2(limbs[0].size.y/2,limbs[5].size.x/2))*(sqrt(pow(limbs[5].size.x/2,2)+pow(limbs[0].size.y/2,2))));    //Same thing here
    limbs[1].pos.x = limbs[5].pos.x+(cos(radians(limbs[5].angle))*(limbs[5].size.x));  //Left & right are relative to character!
    limbs[1].pos.y = limbs[5].pos.y+(sin(radians(limbs[5].angle))*(limbs[5].size.x));  //This puts the left arm on a y value equal to the bottom of the head
    limbs[2].pos.x = hPos.x-(limbs[5].size.x/2);  //Put at the side of the torso, negative x size value used to draw and rotate properly
    limbs[2].pos.y = hPos.y+(limbs[0].size.y/2);  //Y value equal to the bottom of the head
    limbs[6].pos.x = limbs[5].pos.x+(cos(radians(limbs[5].angle+90))*(limbs[5].size.y)); //Left thigh on right of torso
    limbs[6].pos.y = limbs[5].pos.y+(sin(radians(limbs[5].angle+90))*(limbs[5].size.y));  //Puts thigh at bottom of torso
    limbs[7].pos.x = limbs[5].pos.x+(cos(radians(limbs[5].angle)+atan2(limbs[5].size.y,(limbs[5].size.x)))*(sqrt(pow(limbs[5].size.y,2)+pow(limbs[5].size.x,2))));  //Thigh always attached to torso!
    limbs[7].pos.y = limbs[5].pos.y+(sin(radians(limbs[5].angle)+atan2(limbs[5].size.y,(limbs[5].size.x)))*(sqrt(pow(limbs[5].size.y,2)+pow(limbs[5].size.x,2))));  //Puts thigh at bottom of torso
  }
  void renderHurtbox(){
    fill(hurtBoxColor);
    noStroke();
    for(int i=0; i<limbs.length; i++){
      pushMatrix();
      translate(limbs[i].pos.x,limbs[i].pos.y);
      rotate(radians(limbs[i].angle));
      if(i==0) ellipse(0,0-limbs[0].size.y,limbs[i].size.x,limbs[i].size.y);
      else rect(0,0,limbs[i].size.x,limbs[i].size.y);
      //limbs[i].angle += i/2;
      popMatrix();
    }
  }
  void use(move name){      //Animation execution function
    if(!moveProg || currentMove.instantCancel){
      if(currentMove!=name){
        movePhase = 0;
      }
      currentMove = name;
      moveProg = true;
    }
  }
  void walkR(){
    this.hPos.x-=10;
  }
  void walkL(){
    this.hPos.x+=10;
  }
  void jump(){
    if(!onGround && canDJ){    //Only 1 double jump
      canDJ = false;
      this.mom.y += -20;
      this.onGround = false;
      this.idleFalling = false;
    }
    if(onGround){
      //this.hPos.y -= 10;
      this.mom.y += -20;
      this.onGround = false;
      canDJ = true;
    }
  }
  void update(){
    if(movingR) walkR();
    if(movingL) walkL();
    if(moveProg){                                                       //Move animation execution
      currentPhase = currentMove.go(movePhase, this);
      if(movePhase < currentMove.animation.length-1){
        for(int i = 0; i<limbs.length; i++){
          limbs[i].angle = currentPhase[i];
        }
        movePhase++;
      }else{
        moveProg = false;
        movePhase = 0;
      }
    }
    fPos.y=hPos.y+limbs[5].size.y+limbs[6].size.y;                      //Foot position calculations
    fPos.x=hPos.x;
    if(mom.y<termVel && !onGround && !slowFalling && !fastFalling){     //Normal gravity check
      mom.y+=gravity;
    }
    if(slowFalling && mom.y <= 0 && !onGround) mom.y+=gravity/2;        //Slowfall gravity acceleration modifiers
    if(slowFalling && mom.y >= 0 && !onGround) mom.y+=gravity/7;
    if(fastFalling && !onGround) mom.y+=gravity*2;                      //Fastfall gravity acceleration modifier
      hPos.y+=mom.y;
    if(fPos.y>height){                                                  //Is player touching the ground?
      hPos.y = height-limbs[5].size.y-limbs[6].size.y;
      mom.y = 0;
      onGround = true;
    }
  }
  void show(){        //Idk man I cheesed the hell out of this
    fill(255);
    noStroke();
    for(int i=0; i<limbs.length; i++){
      pushMatrix();
      translate(limbs[i].pos.x,limbs[i].pos.y);
      rotate(radians(limbs[i].angle));
      if(i==0) ellipse(0,0-limbs[0].size.y,limbs[i].size.x,limbs[i].size.y);
      else rect(0,0,limbs[i].size.x,limbs[i].size.y);
      //limbs[i].angle += i/2;
      popMatrix();
    }
  }
}

class limb{
  PVector pos = new PVector(0,0);
  PVector size = new PVector(0,0);
  int type; //0-head, 1/2-left/right arm, 3/4-left/right forearm, 5-torso, 6/7-left/right thigh, 8/9-left/right lower leg; Turns out this may not be needed; Using array element indices instead
  float angle = 0;
}