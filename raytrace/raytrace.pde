float sec1w;
float sec1h;
class screenSec{
  int res = main.rayNum;
  int secWid = width/res;
  int index = 0;
  void show(){
    noStroke();
    float rayLen=sqrt(pow(sec1w,2)+pow(sec1h,2));
    if(main.rays[index].endPos!=null){
      rayLen = dist(main.rays[index].pos.x,main.rays[index].pos.y,main.rays[index].endPos.x,main.rays[index].endPos.y);
    }
    fill(map(rayLen,0,sqrt(pow(sec1w,2)+pow(sec1h,2))/2,255,0));
    rect(index*secWid,height/2,secWid,height/(1+rayLen/10));
    stroke(0);
  }
}
class cam{
  PVector pos = new PVector(0,0);
  float FOV = PI/2;
  float rotation = 0;
  int rayNum = 360;
  ray[] rays = new ray[rayNum];
  void show(){
    this.pos = new PVector(mouseX,mouseY);
    if(mouseX>sec1w){
      this.pos.x = sec1w;
    }
    if(mouseY>sec1h){
      this.pos.y = sec1h;    
    }
    ellipse(this.pos.x,this.pos.y,10,10);
    for(int i=0; i<rays.length; i++){
      rays[i] = new ray(this.pos.x,this.pos.y,(FOV/rayNum)*i+rotation);
      rays[i].cast();
      rays[i].show();
    }
  }
}
class ray{
  PVector pos = new PVector(0,0);
  PVector dir = new PVector(0,0);
  float relAngle = 0;
  float camRotation = 0;
  PVector endPos;
  boolean intersected;
  ray(float posX, float posY, float angle){
    this.pos = new PVector(posX,posY);
    this.dir = PVector.fromAngle(angle);
  }
  void update(float posX, float posY){
    this.pos = new PVector(posX, posY);
  }
  void update(float posX, float posY, float angle){
    this.pos = new PVector(posX, posY);
    this.dir = PVector.fromAngle(angle);
  }
  void cast(){
    float record = pow(10,10);
    for(int i=0; i<walls.length; i++){
      float x1 = walls[i].posA.x;
      float x2 = walls[i].posB.x;
      float y1 = walls[i].posA.y;
      float y2 = walls[i].posB.y;
      float x3 = this.pos.x;
      float x4 = this.pos.x+this.dir.x;
      float y3 = this.pos.y;
      float y4 = this.pos.y+this.dir.y;
      float den = (x1-x2)*(y3-y4)-(y1-y2)*(x3-x4);
      float t = 0;
      float u = 0;
      if(den!=0){
        t = ((x1-x3)*(y3-y4) - (y1-y3)*(x3-x4))/den;
        u = -1*((x1-x2)*(y1-y3)-(y1-y2)*(x1-x3))/den;
      }
      if(t>0 && t<1 && u>0){
        PVector inter = new PVector(x1+t*(x2-x1), y1+t*(y2-y1));
        if(dist(inter.x,inter.y,this.pos.x,this.pos.y)<record){
          record = dist(inter.x,inter.y,this.pos.x,this.pos.y);
          this.endPos = new PVector(inter.x, inter.y);
        }
      }
    }
  }
  void show(){
    if(endPos!=null){
      stroke(200,128,0,128);
      line(this.pos.x,this.pos.y,this.endPos.x,this.endPos.y);
      stroke(0);
    }
  }
}
class wall{
  PVector posA = new PVector(0,0);
  PVector posB = new PVector(0,0);
  void show(){
    stroke(255);
    line(this.posA.x,this.posA.y,this.posB.x,this.posB.y);
    stroke(0);
  }
}
wall[] walls = new wall[10];
wall[] bounds = new wall[8];
cam main = new cam();
screenSec[] Screen2 = new screenSec[main.rayNum];
void setup(){
  size(1000,1000);
  sec1w = width/4;
  sec1h = height/4;
  for(int i=0; i<Screen2.length; i++){
    Screen2[i] = new screenSec();
    Screen2[i].index = i;
  }
  for(int i=0; i<walls.length; i++){
    walls[i] = new wall();
    walls[i].posA = new PVector(random(sec1w),random(sec1h));
    walls[i].posB = new PVector(random(sec1w),random(sec1h));
  }
  walls[walls.length-4].posA = new PVector(0,0);
  walls[walls.length-4].posB = new PVector(0,sec1h);
  walls[walls.length-3].posA = new PVector(0,0);
  walls[walls.length-3].posB = new PVector(sec1w,0);
  walls[walls.length-2].posA = new PVector(sec1w,0);
  walls[walls.length-2].posB = new PVector(sec1w,sec1h);
  walls[walls.length-1].posA = new PVector(0,sec1h);
  walls[walls.length-1].posB = new PVector(sec1w,sec1h);
}
void draw(){
  main.show();
  background(0);
  //"3D" RENDER
  for(int i=0; i<Screen2.length; i++){
    Screen2[i].show();
  }
  //RUN THIS PART SECOND
  if(rotA){
    main.rotation+=0.1;
  }
  if(rotD){
    main.rotation-=0.1;
  }
  main.show();
  for(int i=0; i<walls.length; i++){
    walls[i].show();
  }
}
boolean rotA = false;
boolean rotD = false;
void keyPressed(){
  switch(key){
    case 'a':
      rotA = true;
      break;
    case 'd':
      rotD = true;
      break;
  }
}
void keyReleased(){
  switch(key){
    case 'a':
      rotA = false;
      break;
    case 'd':
      rotD = false;
      break;
  }
}
