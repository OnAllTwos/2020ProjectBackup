float birdSpeed = 3;
float birdSize = 10;
float sizeH = birdSize/2;
float turnEase = 0.05;

class bird{
  PVector pos = new PVector(0, 0);
  PVector vel = new PVector(0, 0);
  float angle = 0;
  boolean turnN = false;
  boolean turnP = false;
  bird(PVector pos_, float angle_){
    this.pos.x = pos_.x;
    this.pos.y = pos_.y;
    this.angle = angle_;
  }
  void flockIn(){
    for(int i=0; i<flock.length; i++){
      if(flock[i].pos.x != this.pos.x && flock[i].pos.y != this.pos.y && dist(this.pos.x, this.pos.y, flock[i].pos.x, flock[i].pos.y) < birdSize*2){
        if(flock[i].angle > this.angle){
          this.turnP = true;
        }else if(flock[i].angle < this.angle){
          this.turnN = true;
        }
      }
    }
  }
  void update(){
    if(this.pos.x<0){
      this.pos.x = width;
    }if(this.pos.x > width){
      this.pos.x = 0;
    }if(this.pos.y > height){
      this.pos.y = 0;
    }if(this.pos.y < 0){
      this.pos.y = height;
    }
    this.flockIn();
    if(this.turnP){
      this.angle += turnEase;
      turnP = false;
    }
    if(this.turnN){
      this.angle -= turnEase;
      turnN = false;
    }
    this.vel.x = birdSpeed * cos(this.angle);
    this.vel.y = birdSpeed * sin(this.angle);
    this.pos.x += this.vel.x;
    this.pos.y += this.vel.y;
  }
  void show(){
    pushMatrix();
    translate(this.pos.x, this.pos.y);
    rotate(this.angle + PI / 2);
    triangle(0, -sizeH, sizeH, sizeH, -sizeH, sizeH);
    popMatrix();
  }
}
bird[] flock = new bird[1000];
void setup(){
  size(1000,1000);
  for(int i=0; i<flock.length; i++){
    flock[i] = new bird(new PVector(random(width), random(height)), random(2*PI));
  }
}

void draw(){
  background(255);
  for(int i=0; i<flock.length; i++){
    flock[i].update();
    flock[i].show();
  }
      print(flock[0].pos.x);
}
