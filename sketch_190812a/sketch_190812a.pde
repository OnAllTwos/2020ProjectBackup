import processing.sound.*;
class bug{
  PVector pos = new PVector(0,0);
  PVector mom = new PVector(0,0);
  float angle = 0;
  void update(){
    this.angle = atan2(this.mom.y,this.mom.x);
    this.pos.x+=this.mom.x;
    this.pos.y+=this.mom.y;
    if(this.pos.x<0){
      this.pos.x=0;
      this.mom.x*=-1;
    }else if(this.pos.x>width){
      this.pos.x=width;
      this.mom.x*=-1;
    }else if(this.pos.y<0){
      this.pos.y=0;
      this.mom.y*=-1;
    }else if(this.pos.y>height){
      this.pos.y=height;
      this.mom.y*=-1;
    }
  }
  void show(){
    pushMatrix();
    fill(random(255),random(255),random(255));
    noStroke();
    translate(this.pos.x,this.pos.y);
    rotate(this.angle);
    ellipse(0,0,30,30);
    ellipse(0+10,0,10,10);
    popMatrix();
  }
}
SoundFile bruh;
bug test = new bug();
int counter = 0;
void setup(){
  bruh = new SoundFile(this,"bruh.mp3");
  frameRate(120);
  size(500,500);
  test.pos = new PVector(width/2,height/2);
}

void draw(){
  
  if(counter>60){
    bruh.play();
    test.mom = new PVector(random(-3,3),random(-3,3));
    counter=0;
  }else{
    counter++;
  }
  test.update();
  test.show();
}
