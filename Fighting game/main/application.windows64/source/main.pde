player test = new player();
player[] players = new player[2];  //MOVE OVER TO THIS!!!!!!
float gravity = 1;
float termVel = 15;
void setup(){
  size(1000,1000);
  test.hPos = new PVector(width/2,height/2);
  test.initializeLimbs();
  test.limbs[1].angle = 80;
  test.limbs[2].angle = -80;
  initializeAnimations();
}
void draw(){
  //These if statements check which state the player should be in
  if(test.onGround){
    test.idleFalling = false;
  }
  if(test.movingR && test.onGround){
    test.use(walkR);
  }
  if(test.movingL && test.onGround){
    test.use(walkL);
  }
  if(test.slowFalling && !test.onGround){
    test.use(slowfall);
    test.idleFalling = false;
  }
  if(!test.movingR && !test.movingL && test.onGround){
    test.use(idleGround);
  }
  if(!test.onGround && !test.slowFalling && test.mom.y > 0 && test.idleFalling){
    test.use(idleFall);
  }
  if(!test.onGround && !test.slowFalling && test.mom.y > 0 && !test.idleFalling){
    test.use(handsFall);
    test.idleFalling = true;
  }
  background(100);
  test.PlaceLimbs();
  test.update();
  test.show();
}