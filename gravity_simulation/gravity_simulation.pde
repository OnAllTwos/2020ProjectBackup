//Using actual physics equations! I do thing that I may have done something wrong somewhere though, since there are so many numbers everwhere haha
//But the behavior is as intended it seems so yeah, that's neat!
void setup(){
  size(1000,1000);
  for(int i = 0; i< objects.length; i++){
    objects[i] = new object();
    objects[i].objSig = i;
    tempPosVals[i] = objects[i].pos;
    tempMomVals[i] = objects[i].mom;
  }
  objects[1].pos = new PVector(width/2,height/2);
  objects[1].mass = 999999;
  objects[1].size = 50;
}

class object{
  //float gravity = 1;
  int objSig = 0;
  float size = random(10,15);
  float mass = 5;
  PVector pos = new PVector((int)random(0,width),(int)random(0,height));
  PVector mom = new PVector(0,0);
  boolean stopped = false;
  color fill = color(map(this.pos.x,0,width,0,255),map(this.pos.y,0,height,0,255),random(255),random(255));
  int timer;
  boolean timerUp;
  void show(){
    //fill(map(this.pos.x,0,width,0,255),map(this.pos.y,0,height,0,255),this.timer,random(255));
    //noStroke();
    ellipse(this.pos.x, this.pos.y, this.size, this.size);
    if(stopped){
      line(this.pos.x, this.pos.y, mouseX, mouseY);
    }
  }
  void update(){
    if(timer<255 && timerUp){
      timer++;
    }else if(timer>=255){
      timerUp = false;
    }
    if(!timerUp && timer>0){
      timer--;
    }else if(timer<=0){
      timerUp = true;
    }
    this.pos = tempPosVals[this.objSig];  //Update the values to those calculated last frame
    this.mom = tempMomVals[this.objSig];  //Update the values to those calculated last frame
    /*if(this.pos.x<0){
      this.pos.x=0;
      this.mom.x*=-1;
    }
    if(this.pos.x>width){
      this.pos.x=width;
      this.mom.x*=-1;
    }
    if(this.pos.y<0){
      this.pos.y=0;
      this.mom.y*=-1;
    }
    if(this.pos.y>height){
      this.pos.y=height;
      this.mom.y*=-1;
    }*/
    //Gravity
    for(int i = 0; i < objects.length; i++){
      if(objects[i].objSig!=this.objSig && this.pos.x-objects[i].pos.x != 0){  //No self-attraction or divide by 0 errors
        tempMomVals[this.objSig].x -= (((this.pos.x-objects[i].pos.x)/abs(this.pos.x-objects[i].pos.x))*sqrt(2*((6.6726*pow(10,-11)*this.mass * objects[i].mass)/pow(dist(this.pos.x,this.pos.y,objects[i].pos.x,objects[i].pos.y),2))/this.mass))*100;   //Bigboye velocity calculation
      }
      if(objects[i].objSig!=this.objSig && this.pos.y-objects[i].pos.y != 0){  //No self-attraction or divide by 0 errors
        tempMomVals[this.objSig].y -= (((this.pos.y-objects[i].pos.y)/abs(this.pos.y-objects[i].pos.y))*sqrt(2*((6.6726*pow(10,-11)*this.mass * objects[i].mass)/pow(dist(this.pos.x,this.pos.y,objects[i].pos.x,objects[i].pos.y),2))/this.mass))*100;   //Bigboye velocity calcualtion
      }

    }
    //Gravity
    if(!stopped){
      tempPosVals[this.objSig].x += tempMomVals[this.objSig].x;
      tempPosVals[this.objSig].y += tempMomVals[this.objSig].y;
    }
  }
  void stahp(){
    stopped = true;
    tempMomVals[this.objSig] = new PVector(0,0);
    this.pos.x = mouseX;
    this.pos.y = mouseY;
  }
  void shoot(){
    this.stopped = false;
    float newXmom = (this.pos.x-mouseX)/20;
    float newYmom = (this.pos.y-mouseY)/20;
    tempMomVals[objSig] = new PVector(newXmom, newYmom);
  }
}
object[] objects = new object[3];
PVector[] tempPosVals = new PVector[objects.length];
PVector[] tempMomVals = new PVector[objects.length];
void draw(){
  background(255);
  for(int i = 0; i < objects.length; i++){
    objects[i].update();
    objects[i].show();
  }
}
void mousePressed(){
  objects[0].stahp();
}

void mouseReleased(){
  objects[0].shoot();
}
