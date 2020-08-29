/*
  An alright start to something that kinda looks like a fighting game!
  I've got animations happening, hitboxes are on their way to being implemented, so maybe I can get this all to come together.
  Make some kind of tool though so that making animations doesn't have to be done through handwriting fake csv files lol
*/
player test = new player();
player[] players = new player[2];  //MOVE OVER TO THIS!!!!!!
float gravity = 1;
float termVel = 15;
void setup(){
  size(1000,1000);
  for(int i=0; i<players.length;i++){
    players[i] = new player();
    players[i].initializeLimbs();
    players[i].limbs[1].angle = 80;
    players[i].limbs[2].angle = -80;
  }
  players[0].hPos = new PVector(width,height/2);
  players[1].hPos = new PVector(0,height/2);
  initializeAnimations();
}
void draw(){
  for(int i=0; i<players.length; i++){
    if(players[i].onGround){
      players[i].idleFalling = false;
    }
    if(players[i].movingR && players[i].onGround){
      players[i].use(walkR);
    }
    if(players[i].movingL && players[i].onGround){
      players[i].use(walkL);
    }
    if(players[i].slowFalling && !players[i].onGround){
      players[i].use(slowfall);
      players[i].idleFalling = false;
    }
    if(!players[i].movingR && !players[i].movingL && players[i].onGround){
      players[i].use(idleGround);
    }
    if(!players[i].onGround && !players[i].slowFalling && players[i].mom.y > 0 && players[i].idleFalling){
      players[i].use(idleFall);
    }
    if(!players[i].onGround && !players[i].slowFalling && players[i].mom.y > 0 && !players[i].idleFalling){
      players[i].use(handsFall);
      players[i].idleFalling = true;
    }
  }
  //These if statements check which state the player should be in
  /*if(players[0].onGround){
    players[0].idleFalling = false;
  }
  if(players[0].movingR && players[0].onGround){
    players[0].use(walkR);
  }
  if(players[0].movingL && players[0].onGround){
    players[0].use(walkL);
  }
  if(players[0].slowFalling && !players[0].onGround){
    players[0].use(slowfall);
    players[0].idleFalling = false;
  }
  if(!players[0].movingR && !players[0].movingL && players[0].onGround){
    players[0].use(idleGround);
  }
  if(!players[0].onGround && !players[0].slowFalling && players[0].mom.y > 0 && players[0].idleFalling){
    players[0].use(idleFall);
  }
  if(!players[0].onGround && !players[0].slowFalling && players[0].mom.y > 0 && !players[0].idleFalling){
    players[0].use(handsFall);
    players[0].idleFalling = true;
  }*/
  background(100);
  for(int i=0; i<players.length; i++){
    players[i].PlaceLimbs();
    players[i].update();
    players[i].show();
  }
}
