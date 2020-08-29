/*
  Ignore the triangles coming out of everything, that's a "vestigial trait" of some early sight experimentation which I kept around for future reference haha
  This is one of few of my evolution simulators in which evolution actually occurs!
  I'm not a big fan though of how the traits work, since it seems like certain arrays of motions aren't exactly favored over others.
*/
int foodAmt = 70;
PVector[] foodBits = new PVector[foodAmt];
PVector[] bodyParts = new PVector[0];
int foodEnergy=20;
boolean bugSelected;
int foodSize =5;
PVector parentV;

Bug[] bugs = new Bug[10];
public class Bug{
  PVector pos = PVector.random2D();
  PVector vel = new PVector(0,0);
  int speed = (int)random(0,10);
  int eggLayE = (int)random(0,200);
  int eggTime = (int)random(300,7200);
  int eggTimer=0;
  color Color = color((int)random(255),(int)random(255),(int)random(255));
  int movementTime =(int) random(5,120);;
  int movementTimer = movementTime;
  int rotation=0;
  int rotate=0;
  int rotateTime = (int) random(5,120);
  int rotateTimer = rotateTime;
  int incubT = (int)random(1800,7200);
  int incubTimer=0;
  int size = (int)random(10,50);
  int movement=0;
  float mutateChance = random(0,1)/100;
  float energy = 1000;
  boolean alive = true;
  boolean isEgg = false;
  boolean isCarnivore = false;
  DNA dna = new DNA();
  int food;
  void hatch(){
    if(this.isEgg){
      if(this.incubTimer<this.incubT){
        this.incubTimer++;
      }else if(this.incubTimer>=this.incubT){
        if(prob(this.mutateChance)){
          this.dna.movements[(int)random(0,this.dna.movements.length)] = PVector.random2D();
        }
        if(prob(this.mutateChance)){
          this.size+=PosNeg()*5;
        }
        if(prob(this.mutateChance)){
          this.isCarnivore = !this.isCarnivore;
        }
        this.isEgg = false;
      }
    }
  }
  void egg(){
    final PVector ANGERY = this.pos;
     cloneBug(this, ANGERY);
     println("Egg lain "+bugs[1].pos.x+" "+bugs.length);
     eggTimer = 0;
  }
  void layEgg(){
    if(!this.isEgg && this.energy-(this.size*4)>=eggLayE && eggTimer >= eggTime){
      this.energy-=this.size*4;
      this.egg();
    }
  }
  void edges(){
    if(this.pos.x<0){
      this.pos.x = width;
    }
    if(this.pos.x>width){
      this.pos.x = 0;
    }
    if(this.pos.y<0){
      this.pos.y = height;
    }
    if(this.pos.y>height){
      this.pos.y = 0;
    }
  }
  void checkDead(){
    if(energy<=0){
      this.alive = false;
    }
  }
  void show(){
    if(alive){
      if(!isEgg){
        pushMatrix();
        translate(this.pos.x, this.pos.y);
        rotate(radians(this.rotation));
        noStroke();
        fill(0,50);
        triangle(0, 0, this.size*2, this.size*4, -this.size*2, this.size*4);
        stroke(1);
        fill(Color,255);
        ellipse(0, 0, this.size, this.size);
        fill(100);
        ellipse(0, this.size/3, this.size/4, this.size/4);
        popMatrix();
      }
      if(isEgg){
        fill(Color);
        rect(this.pos.x, this.pos.y, this.size/5, this.size/5);
      }
    }
  }
  void update(){
    if(this.alive && !this.isEgg){
      if(this.eggTimer<this.eggTime){
        this.eggTimer++;
      }
      this.vel = new PVector(cos(radians(this.rotation))*this.speed, sin(radians(this.rotation))*this.speed);
      if(this.movementTimer >= this.movementTime){
        this.vel = this.dna.movements[this.movement].copy();
        if(this.movement<this.dna.movements.length && this.movement!=this.dna.movements.length-1){
          this.movement++;
        }else{
          this.movement = 0;
        }
        this.movementTimer = 0;
      }else{
        this.movementTimer++;
      }
      if(this.rotateTimer >= this.rotateTime){
        this.rotation = this.dna.rotations[this.rotate];
        if(this.rotate<this.dna.rotations.length && this.rotate!=this.dna.rotations.length-1){
          this.rotate++;
        }else{
          this.rotate = 0;
        }
        this.rotateTimer = 0;
      }else{
        this.rotateTimer++;
      }
      this.pos.x += this.vel.x;
      this.pos.y += this.vel.y;
      this.energy -= (abs(this.vel.x)+abs(this.vel.y)+(speed/10)+(size/40))/20;
      println(this.energy);
      if(!isCarnivore){
        for(int i = 0; i<foodBits.length; i++){
          if(dist(this.pos.x, this.pos.y, foodBits[i].x, foodBits[i].y) <= (this.size/2) + foodSize){
            this.vel = this.dna.foodEatAction.copy();
            this.energy+=foodEnergy;
            foodBits[i] = new PVector((int)random(width),(int)random(height));
          }
        }
      }
      if(isCarnivore){
        for(int i = 0; i<bugs.length; i++){
          if(dist(this.pos.x, this.pos.y, bugs[i].pos.x, bugs[i].pos.y) <= (this.size/2) + (bugs[i].size/2) && this.Color != bugs[i].Color){
            if(!bugs[i].isCarnivore){
              this.vel = this.dna.foodEatAction.copy();
              this.energy+=(bugs[i].energy/10);
              bugs[i].alive = false;
            }
            if(bugs[i].isCarnivore){
              if(this.energy+(this.size*2)>bugs[i].energy+(bugs[i].size*2)){
                this.vel = this.dna.foodEatAction.copy();
                this.energy+=(bugs[i].energy/10);
                bugs[i].alive = false;
              }
            }
          }
        }
      }
    }
  }
}
public void cloneBug(Bug parent, PVector pos){
  Bug rBug = new Bug();
  float x,y;
  x = pos.x;
  y = pos.y;
  rBug.energy = parent.size*4;
  rBug.alive=true;
  rBug.isEgg=true;
  rBug.vel = parent.vel;
  rBug.pos = new PVector(x,y);
  rBug.speed = parent.speed;
  rBug.eggLayE = parent.eggLayE;
  rBug.eggTime = parent.eggTime;
  rBug.Color = parent.Color;
  rBug.movementTime = parent.movementTime;
  rBug.rotateTime = parent.rotateTime;
  rBug.incubT = parent.incubT;
  rBug.size = parent.size;
  rBug.mutateChance = parent.mutateChance;
  rBug.isCarnivore = parent.isCarnivore;
  rBug.dna = parent.dna;
  bugs = (Bug[]) append(bugs, rBug);
}
public class DNA{
  PVector[] movements = new PVector[(int)random(30,80)];
  int[] rotations = new int[(int)random(30,80)];
  PVector foodEatAction = PVector.random2D();
}

public boolean prob(float chance){
  if(random(0,1) < chance){
    return true;
  }else{
    return false;
  }
}
public int PosNeg(){
  if(random(-1,1)<0){
    return 1;
  }else{
    return -1;
  }
}
void setup(){
  size(1000,1000);
  background(255);
  for(int i=0; i<foodBits.length; i++){
    fill(100);
    foodBits[i] = new PVector((int)random(width), (int)random(height));
  } 
  for(int i=0; i<bugs.length; i++){
    bugs[i] = new Bug();
    bugs[i].pos.x = random(width);
    bugs[i].pos.y = random(height);
    for(int j=0; j<bugs[i].dna.movements.length; j++){
      bugs[i].dna.movements[j] = PVector.random2D();
    }
    for(int j=0; j<bugs[i].dna.rotations.length; j++){
      bugs[i].dna.rotations[j] = (int) random(0,360);
    }
  }
}

void draw(){
  background(255);
  for(int i = 0; i<foodBits.length; i++){
    fill(100);
    rect(foodBits[i].x, foodBits[i].y, foodSize, foodSize);
  }
  for(int i=0; i<bugs.length; i++){
    bugs[i].update();
    bugs[i].checkDead();
    bugs[i].show();
    bugs[i].edges();
    bugs[i].layEgg();
    bugs[i].hatch();
    }
}
