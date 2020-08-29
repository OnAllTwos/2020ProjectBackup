/*
  My very first, hilariously bad evolution simulator...
  It doesn't have proper food detection or collisions or reproduction...
  or quite frankly evolution for that matter
*/
float foodParts;
float bug1check=0;
float[] fX = {random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640),random(0,640)};
float[] fY = {random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360),random(0,360)};
Bug bugS1 = new Bug();
void setup(){
  background(102);
  size(640, 320);
}
void cls(){
  background(102);
} 
class Bug{
  float lastXpos;
  float lastYpos;
  float colorR;
  float colorG;
  float colorB;
  float eggTime;
  float eggLay;
  float xSpeed;
  float ySpeed;
  float food;
  float sizeX;
  float sizeY;
  float Ypos;
  float Xpos;
  float lifeTime;
  float xDir;
  float yDir;
  boolean carnivore;
}
class Food{
  float Xpos;
  float Ypos;
  boolean eaten;
}
  
void bug1Startergen(){
  bugS1.colorR=int(random(0,256));
  bugS1.colorG=int(random(0,256));
  bugS1.colorB=int(random(0,256));
  bugS1.eggTime=int(random(40,50));
  bugS1.eggLay=int(random(50,60));
  bugS1.xSpeed=int(random(0,4));
  bugS1.ySpeed=int(random(0,4));
  if(bugS1.ySpeed == 0 && bugS1.xSpeed == 0){
    float decide = random(-5,5);
    if(decide>=0){
      bugS1.xSpeed++;
    }
    else{
      bugS1.ySpeed++;
    }
  } 
  float decidexdir = random(-5,5);
  if (decidexdir>=0){
    bugS1.xDir=-1;
  }
  if (decidexdir<0){
    bugS1.xDir=1;
  }
  float decideydir = random(-5,5);
  if (decideydir>=0){
    bugS1.yDir=-1;
  }
  if (decideydir<0){
    bugS1.yDir=1;
  }
  bugS1.Xpos=int(random(50,590));
  bugS1.Ypos=int(random(50,310));
  bugS1.lifeTime=int(random(70,120));
  bugS1.food=getFood(1);
}

void draw(){
  if (bug1check==0){
    bug1Startergen();
    bug1check++;
  }
  bugBounceCheck(bugS1);
  drawFood();
  coverBug(bugS1);
  drawBug(bugS1);
  checkEatFood(bugS1);
  text("Food:"+getFood(5)+"",10,60);
  layEgg(bugS1);
}

void drawBug(Bug bug){ 
  fill(bug.colorR,bug.colorG,bug.colorB);
  noStroke();
  rect(bug.Xpos, bug.Ypos, 10, 10);
  bug.Xpos=bugMoveX(bugS1);
  bug.Ypos=bugMoveY(bugS1);
}

void bugBounceCheck(Bug bug){
  if(bug.Xpos>width-10 || bug.Xpos < 10){
    bug.xDir *= -1;
  }
  if(bug.Ypos>height-10 || bug.Ypos < height-height+10){
    bug.yDir *= -1;
  }
}

void coverBug(Bug bug){
  fill(102);
  stroke(102);
  rect(bug.Xpos-bug.xSpeed*bug.xDir, bug.Ypos-bug.ySpeed*bug.yDir, 13, 13);
}

float bugMoveX(Bug bug){
  float newposX= bug.Xpos+(bug.xSpeed*bug.xDir);
  return newposX;
}

float bugMoveY(Bug bug){
  float newposY= bug.Ypos+(bug.ySpeed*bug.yDir);
  return newposY;
}
  
float getFood(float addFood){
  float Food=0;
  Food=addFood+Food;
  return Food;
}

void layEgg(Bug bug){
  float avFood = bugS1.food;
  if(avFood>5){
    ellipse(bug.Xpos,bug.Ypos,5,10);
  }
}

void checkEatFood(Bug bug){
  for(int i =0; i<50;i++){
    if(bug.Xpos-5<=fX[i] && fX[i]<=bug.Xpos+5){
      if(bug.Ypos-5<=fY[i] && fY[i]<=bug.Ypos+5){
        getFood(1);  
      }
    }
   }
}
void drawFood(){
  while (foodParts!=1){
       for(int i = 0; i<49; i++){
        rect(fX[i],fY[i],5,5);
      }
      foodParts++;
  }
}
