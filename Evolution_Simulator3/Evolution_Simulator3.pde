/*
  "Post-project" documentation (Because I'm probably not actually done with it yet):
  BY FAR THE MOST PROMISING EVOLUTION SIMULATOR YET!
  Well no evolution is happening because they can't reproduce... but I'm working on implementing that like I did in previous versions!
  But they DO have sight and reactions thereof using a very strange method which I developed myself, since it turns out that detecting collisions with slanted rectangles is not very easy.
  It uses a method in which sightboxes and "seeable things" are rendered in two different colors at 50% alpha, and the program then searches for the net color produced by the two overlapping colors.
  Problematically, that means that every pixel of every sightbox has to be individually checked, which is turning out to not be very practical on this large of a scale
*/
int foodSize=20;
int foodCounter=0;
color foodColor = color(0,0,255,128);
int foodEnergy=10;
class food{
  PVector pos = new PVector(-1000,-1000);
  boolean eaten = false;
  void show(){
    if(!this.eaten){
      color(0,255,0);
      rect(this.pos.x,this.pos.y,foodSize,foodSize);
    }
  }
  void spawn(){
    this.pos = new PVector((int)random(width),(int)random(height));
  }
}
class org{  //An organism
  behaviors act = new behaviors();  //Weeeeee subclassses!
  color seeColor = color(255,0,0,128);  //"Color" of things it will see
  color thisColor = color(0,0,255,128);  //Color of the sightbox
  boolean alive = true;
  float angle;
  boolean notEgg = true;
  PVector pos = new PVector(0,0);
  float speed = 3;
  PVector mom = new PVector(2,0);
  int size = (int)random(10,50);
  int energy = 100;
  color col = color(random(255),random(255),random(255));
  int checkCount = (int)random(0,10);
  int orgNum=0;
  int eggTime=(int)random(600,3600);
  int eggTimer=0;
  aBox sight = new aBox(this.pos.x,this.pos.y,this.size*3,this.size*3);
  void show(){
    if(this.notEgg){
      stroke(1);
      pushMatrix();
      translate(this.pos.x,this.pos.y);
      rotate(this.angle);
      fill(this.col);
      ellipse(0,0,this.size,this.size);
      ellipse(this.size/4,0,this.size/2,this.size/2);
      popMatrix();
    }else if(!this.notEgg){
      rect(this.pos.x,this.pos.y,this.size/4,this.size/4);
    }
  }
  void lay(){
    layEgg(this);
  }
  void look(){
      this.act.checkSee(this);
      checkCount = 0;
  }
  void update(){
    if(this.notEgg){
      this.sight.thisColor = this.seeColor;
      this.sight.angle = this.angle-(PI/4);
      this.sight.pos = new PVector(this.pos.x,this.pos.y);
      this.angle=atan2(this.mom.y,this.mom.x);
      this.pos.x+=this.mom.x;
      this.pos.y+=this.mom.y;
      this.act.checkTouch(this);
      if(this.pos.x+this.size/2>width){
        this.mom.x *= -1;
        this.pos.x = width-this.size/2;
      }
      if(this.pos.x-this.size/2<0){
        this.mom.x *= -1;
        this.pos.x = this.size/2;
      }
      if(this.pos.y+this.size/2>height){
        this.mom.y *= -1;
        this.pos.y = height-this.size/2;
      }
      if(this.pos.y-this.size/2<0){
        this.mom.y *= -1;
        this.pos.y = this.size/2;
      }
      if(checkCount >= 10){
        this.look();
      }else{
        checkCount++;
      }
    }else if(!this.notEgg){
      
    }
  }
}
void layEgg(org mommy){  //This kind of function always tend to a be a liiiiiiitle bit janky. I think I need to implement a deepcopy function so that mommy.behaviors is entirely copied over to the new organism. That's why this project is taking so long because hecking deep copies!
  org[] newEgg = new org[1];
  newEgg[0].pos = new PVector(mommy.pos.x, mommy.pos.y);
  newEgg[0].size = mommy.size;
  newEgg[0].act = mommy.act;
  orgs = (org[]) append(orgs,newEgg);
}
class aBox{  //Angled Hitbox; Used for vision
  PVector pos = new PVector(500,250);
  PVector size = new PVector(100,50);
  color thisColor;
  float angle;
  aBox(float posX, float posY, int sizeX, int sizeY){
    this.pos = new PVector(posX, posY);
    this.size = new PVector(sizeX,sizeY);
  }
  void show(){
    pushMatrix();
    translate(this.pos.x,this.pos.y);
    rotate(this.angle);
    rect(0,0,this.size.x,this.size.y);
    popMatrix();
  }
  boolean checkCollide(PVector point, PVector Psize, color thatColor){  //Sightboxes with my own method!
    noStroke();
    fill(thisColor);
    rect(0,0,5,5);
    this.show();
    fill(thatColor);
    rect(0,0,5,5);
    rect(point.x,point.y,Psize.x,Psize.y);
    color expected = get(1,1);
    background(255);
    fill(thisColor);
    this.show();
    fill(thatColor);
    rect(point.x,point.y,Psize.x,Psize.y);
    pushMatrix();
    translate(this.pos.x,this.pos.y);
    rotate(this.angle); 
    float redE = red(expected);
    float greenE = green(expected);
    float blueE = blue(expected);
    int sizeX = (int)this.size.x;
    int sizeY = (int)this.size.y;
    int tempX = (int)this.pos.x;
    int tempY = (int)this.pos.y;
    loadPixels();
    for(int i=0; i<sizeX; i+=10){
      for(int j=0; j<sizeY; j+=10){
        int newPosX = (int)((tempX+i-tempX)*cos(this.angle)-(tempY+j-tempY)*sin(this.angle)+tempX);
        int newPosY = (int)((tempX+i-tempX)*sin(this.angle)+(tempY+j-tempY)*cos(this.angle)+tempY);
        color test = get(newPosX,newPosY);
        if(red(test) == redE && green(test) == greenE && blue(test) == blueE){
          popMatrix();
          return true;
        }
      }
    }
    popMatrix();
    //background(255);
    return false;
  }
}
class behaviors{ //Basically how the organism will react when it sees organisms, food, 
  float orgR = random(2*PI); //What will it do when it sees an organism? Not currently in use for testing purposes.
  float foodR = random(2*PI);  //What will it do when it sees food?
  float orgSR = random(-1,1);  //Another kind of modification of what it will do when it sees and organism. 
  void checkSee(org Org){
    for(int i=0; i<foods.length; i++){
      if(!foods[i].eaten){
        if(Org.sight.checkCollide(foods[i].pos, new PVector(foodSize,foodSize), foodColor)){
          this.seeFood(i, Org);
        }
      }
    }
    for(int i=0; i<orgs.length; i++){
      if(orgs[i].alive){
        if(i!=Org.orgNum){
          if(Org.sight.checkCollide(orgs[i].pos, new PVector(orgs[i].size,orgs[i].size), orgs[i].thisColor)){
            this.seeOrg(i, Org);
          }
        }
      }
    }
  }
  void checkTouch(org Org){
    for(int i=0; i<foods.length; i++){
      if(!foods[i].eaten){
        if(dist(Org.pos.x,Org.pos.y,foods[i].pos.x,foods[i].pos.y)<Org.size/2){
          Org.energy+=foodEnergy;
          foods[i].eaten=true;
        }
      }
    }
  }
  void seeOrg(int orgI, org Org){
   float orgSpeed = Org.speed;
   Org.mom = PVector.fromAngle(atan2(orgs[orgI].pos.y-Org.pos.y, orgs[orgI].pos.x-Org.pos.x)+orgR+orgSR*map(orgs[orgI].size,10,50,0,2*PI));
   Org.mom.x *= orgSpeed;
   Org.mom.y *= orgSpeed;
  }
  void seeFood(int foodI, org Org){
   float orgSpeed = Org.speed;
   Org.mom = PVector.fromAngle(atan2(foods[foodI].pos.y-Org.pos.y, foods[foodI].pos.x-Org.pos.x)+foodR);
   Org.mom.x *= orgSpeed;
   Org.mom.y *= orgSpeed;
   //print(Org.mom);
  }
}
org[] orgs = new org[10];
food[] foods = new food[20];
food test = new food();
void setup(){
  size(1000,1000);
  orgs[0]=new org();
  orgs[0].pos = new PVector(width/2,height/2);
  for(int i=0; i<orgs.length; i++){
    orgs[i] = new org();
    orgs[i].orgNum = i;
    orgs[i].pos = new PVector(random(width),random(height));
  }
  for(int i=0; i<foods.length; i++){
    foods[i] = new food();
    foods[i].pos = new PVector(random(width),random(height));
  }
}
void draw(){  //Ahhhhh such a nice and small draw function! Good optimization has occurred! (At least in this regard)
  foodCounter++;
  if(foodCounter==30){
    for(int i=0; i<foods.length; i++){
      if(foods[i].eaten){
        foods[i].spawn();
        foods[i].eaten = false;
        foodCounter = 0;
        break;
      }
    }
  }
  for(int i=0; i<orgs.length; i++){
    orgs[i].update();
  }
  background(255);
  for(int i=0; i<orgs.length; i++){
    orgs[i].show();
  }
  for(int i=0; i<foods.length; i++){
    foods[i].show();
  }
  text((int)frameRate,20,60);
}
