import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class main extends PApplet {

player test = new player();
player[] players = new player[2];  //MOVE OVER TO THIS!!!!!!
float gravity = 1;
float termVel = 15;
public void setup(){
  
  test.hPos = new PVector(width/2,height/2);
  test.initializeLimbs();
  test.limbs[1].angle = 80;
  test.limbs[2].angle = -80;
  initializeAnimations();
}
public void draw(){
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
public void keyReleased(){          //Key released + key pressed allows for multiple buttons to be used at the same time.
    if(key == 'a' || key == 'A'){
      test.movingR = false;
    }
    if(key == 'd' || key == 'D'){
      test.movingL = false;
    }
    if(key == 'w' || key == 'W'){
      test.slowFalling = false;
    }
    if(key == 's' || key == 'S'){
      test.fastFalling = false;
    }
}
public void keyPressed(){
    if(keyCode == LEFT && test.onGround){
      test.use(jabr);
    }
    if(key == 'w' || key == 'W'){
      test.slowFalling = true;
      test.idleFalling = false;
      if(!test.onGround) test.use(slowfall);
    }
    if(key == ' '){
      test.jump();
    }
    if(key == 'a' || key == 'A'){
      test.movingR = true;
      if(!test.moveProg && test.onGround) test.use(walkR);
    }
    if(key == 'd' || key == 'D'){
      test.movingL = true;
      if(!test.moveProg && test.onGround) test.use(walkL);
    }
    if(key == 's' || key == 'S'){
      test.fastFalling = true;
    }
}
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
public void initializeAnimations(){
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

public void delay(){
  
}
class move{
  float angle;
  int startUp;  //How many frames to active?
  boolean instantCancel;
  int animationStages = 30;
  int hBnum;
  PVector active; //x=first frame, y=last frame
  int[] hBFrames = new int[hBnum]; //Time between each hitbox
  int recovery;  //Frames to standing
  int ID;
  float[][] animation = new float[100][10];  //First element = Which set of positions, second element = which part to position, value of element = position
  hitBox[] hitboxes = new hitBox[hBnum];
  public float[] go(int phase, player player){
    return animation[phase];
  }
}

class hitBox{      //BIG work in progress!
  PVector pos;
  PVector size;
  float angle;
  boolean attached = true;
  int bone = 0;  //Limb to which to attach the hitbox
  int hitAngle;
  int damage;
  public void show(player parent){
    pushMatrix();
    if(this.attached){
      translate(parent.limbs[bone].pos.x,parent.limbs[bone].pos.y);
    }else{
      translate(this.pos.x,this.pos.y);
    } 
    rotate(radians(this.angle));
    rect(0,0,this.size.x,this.size.y);
    popMatrix();
  }
  public boolean checkCollide(player parent, player player){ //This player is that player which might be hit
    noStroke();
    fill(parent.hitBoxColor);          //Overlapping colors used for hit detection!
    rect(0,0,2,2);                     //This area in the code makes a small sample of what overlapping hurtboxes and hitboxes would look like
    this.show(parent);
    fill(player.hurtBoxColor);
    rect(0,0,2,2);
    player.renderHurtbox();
    int expected = get(1,1);         
    background(100);
    fill(player.hitBoxColor);
    this.show(parent);
    fill(0,0,255,128);
    player.renderHurtbox();
    pushMatrix();
    translate(this.pos.x,this.pos.y);
    rotate(radians(this.angle)); 
    loadPixels();
    for(int i=0; i<(int)this.size.x; i++){
      for(int j=0; j<(int)this.size.y; j++){
        float newPosX = (int)((this.pos.x+i-this.pos.x)*cos(radians(this.angle))-(this.pos.y+j-this.pos.y)*sin(radians(this.angle))+this.pos.x);
        float newPosY = (int)((this.pos.x+i-this.pos.x)*sin(radians(this.angle))+(this.pos.y+j-this.pos.y)*cos(radians(this.angle))+this.pos.y);
        int test = get((int)newPosX,(int)newPosY);
        fill(test);
        //rect(0,0,10,10);    //This rectangle is for testing the value recieved by the get() function
        if(red(test) == red(expected) && green(test) == green(expected) && blue(test) == blue(expected) && alpha(test) == alpha(expected)){
          popMatrix();
          background(100);  //Make hitboxes invisible
          return true;
        }
      }
    }
    popMatrix();
    background(100);  //Make hitboxes invisible
    return false;
  }
}
class player{
  int hurtBoxColor = color(0,0,255,128);
  int hitBoxColor = color(255,0,0,128);
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
  public void initializeLimbs(){  //Mostly here to make modifying size values easier
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
  public void PlaceLimbs(){  //Use this to calculate the positions of each limb; Position of head and size of all limbs REQUIRED!
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
  public void renderHurtbox(){
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
  public void use(move name){      //Animation execution function
    if(!moveProg || currentMove.instantCancel){
      if(currentMove!=name){
        movePhase = 0;
      }
      currentMove = name;
      moveProg = true;
    }
  }
  public void walkR(){
    this.hPos.x-=10;
  }
  public void walkL(){
    this.hPos.x+=10;
  }
  public void jump(){
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
  public void update(){
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
  public void show(){        //Idk man I cheesed the hell out of this
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
  public void settings() {  size(1000,1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "main" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
