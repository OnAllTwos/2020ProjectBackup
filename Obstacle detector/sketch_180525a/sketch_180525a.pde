/*
  Places a bunch of points whenever the "robot" hits one of the randomly-placed invisible objects. Roombas would use something similar to build a model of where models are in your house, except they would then use grouping.
  So that's next! Implement grouping of objects into approximate rectangles.
*/
void setup(){
  size(1000,1000);
  frameRate(440);
  for(int i = 0; i< obs.length; i++){  //Defining all objects of an array of objects; Prevent null-pointers
    obs[i] = new obstacle();
    obs[i].pos = new PVector(random(0,width), random(0,height));
    obs[i].size = new PVector(random(40,80),random(40,80));
  }
}
PVector[] points = new PVector[0];  //This array starts at 0, is appended to whenever a new point is needed
obstacle[] obs = new obstacle[10];  //Array of all of the randomly-generated obstacles
class robot{
  PVector pos = new PVector(width/2,height/2);
  PVector mom = new PVector(5,6);
  float angle = 0;
  int mSpeed = 150;
  int size = 10;      // Higher size = faster, but less precision. Lower size = slower, but more precision. Can be set to 0 for complete precision.
  float r = this.size/6;
  PVector getRPV(){  //Keeps roughly the same speed in the randomly-generated PVectors (Not nearly as important at high speeds, more for visual clarity at low speeds)
    float xMod = random(-100,100);
    float yMod = (xMod/abs(xMod))*(-100)+xMod;  //The next few lines generate a random %
    xMod *= 0.01;
    yMod *= 0.01;
    return new PVector(xMod*mSpeed, yMod*mSpeed);
  }
  void show(){
    ellipse(this.pos.x,this.pos.y,this.size,this.size);
    ellipse(this.pos.x+(cos(this.angle)*this.r),this.pos.y+(sin(this.angle)*this.r), this.size/8, this.size/8);  //Dot to show direction that the bot is facing. Again mostly for visual clarity at lower speeds, and helps calculate angle-related positions.
  }
  void update(){
    this.angle = atan2(this.mom.y,this.mom.x);  //Sets the angle to one which points in the direction of movement
    this.pos.x += this.mom.x;
    this.pos.y += this.mom.y;
    if(this.pos.x-this.size/2 < 0){             //Left boundary
      this.pos.x = 0+this.size/2;
      this.mom = getRPV();
    }
    if(this.pos.x+this.size/2 > width){        //Right boundary
      this.pos.x = width-this.size/2;
      this.mom = getRPV();
    }
    if(this.pos.y-this.size/2 < 0){            //Top boundary
      this.pos.y = 0+this.size/2;
      this.mom = getRPV();
    }
    if(this.pos.y+this.size/2 > height){      //Bottom boundary
      this.pos.y = height-this.size/2;
      this.mom = getRPV();
    }
    fill(255);
    for(int i = 0; i < obs.length; i++){
      if(obs[i].collide(this.pos, this.size/2)){  //Check collision between this bot and all obstacles and places a permanent dot there
        fill(255,0,0);
        this.mom = getRPV();
        newPoint(this.pos);
      }
    }
  }
}

class obstacle{
  PVector pos = new PVector(500,500);
  PVector size = new PVector(50,200);
  void show(){
    rect(this.pos.x,this.pos.y,this.size.x,this.size.y);
  }
  boolean collide(PVector tPos, int tSize){    //Hitbox detection
    if(tPos.x+tSize/2>this.pos.x && tPos.x-tSize<this.pos.x+this.size.x && tPos.y+tSize>this.pos.y && tPos.y-tSize<this.pos.y+this.size.y){
      return true;
    }else{
      return false;
    }
  }
}
robot test = new robot();

void draw(){
  background(255);
  test.update();
  test.show();
  for(int i = 0; i < obs.length; i++){
    obs[i].show();
  }
  for(int i = 0; i < points.length; i++){
    ellipse(points[i].x,points[i].y,2,2);
  }
  //cluster();    //Draws lines between points that are close to one another (Can help to visualize where the obstacles are)
}
void newPoint(PVector pos){
  final float posx = pos.x;
  final float posy = pos.y;
  points = (PVector[]) append(points, new PVector(posx,posy));    //Adds a new point at the bot's position to the end of the points array
}
void cluster(){
  for(int i = 0; i<points.length; i++){                            //Check each point for its distance from each other point
    for(int j = 0; j<points.length; j++){
      if(dist(points[i].x,points[i].y,points[j].x,points[j].y)<20){
        line(points[i].x,points[i].y,points[j].x,points[j].y);
      }
    }
  }
}
