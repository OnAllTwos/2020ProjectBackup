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

public class sketch_170402a extends PApplet {

Bug[] myBugs = new Bug[10];
Food[] myFood = new Food[50];
Egg[] myEggs = new Egg[0];
int creatureeaten;
int bugs_gend=0;
int food_gend=0;
int sizex = 1440;
int sizey = 900;
int eggs = 0;
  
public void setup(){
  surface.setSize(sizex, sizey);
  background(255);
  frameRate(30);
}
 
public void draw(){
  if(bugs_gend == 0){  //Generate starting bugs once
    bugs_gend=1;
    genBugs();
  }
  if(food_gend ==0){  //Generate 50 food once
    food_gend = 1;
    genFood();
  }
  background(255);  //Clear screen before each draw cycle
  eatBug();
  checkFood();  //Respawns eaten food
  eatFood();  //Checks food collision and handles energy granting
  checkDead();  // If energy <=0, the organism dies and is no longer drawn.
  updateFood();  //Consumes Bug energy each frame
  eggTimer();  //Egg hatch countdown & Bug spawning
  moveBugs();  //Moves bugs according to speed each frame
  checkReproduce();  //Checks if a bug is ready to reproduce and generates eggs
  for(int i=0;i<50;i++){  //Draws food at position
    fill(0,255,8);
    rect(myFood[i].xpos, myFood[i].ypos, 5,5);
  }
  
  for(int i=0;i<myBugs.length;i++){ //Draws bugs at their positions each frame
    if(myBugs[i].living){
      fill(myBugs[i].r,myBugs[i].g,myBugs[i].b);
      ellipse(myBugs[i].xpos, myBugs[i].ypos, myBugs[i].size, myBugs[i].size);
    }
    if(myBugs[i].living==false){
    }
  }
  for(int i=0;i<myEggs.length;i++){ //Draws eggs at their position each frame
    if(myEggs[i].living == true){
      fill(238, 255, 0);
      ellipse(myEggs[i].xpos, myEggs[i].ypos, 3, 3);
    }
    if(myEggs[i].living == false){
    }
  }
  for(int i=0;i<myBugs.length;i++){  //Reproduction cooldown timer & age timer
    if(myBugs[i].reproductioncooldown != 0){
     myBugs[i].reproductioncooldown--;
    }
     myBugs[i].age++;
   }
   
  fill(0,100,0);
  textSize(100);
  text(eggs+" Eggs",100,100);
}

public void eatFood(){
  for(int i=0; i<50; i++){
    for(int h=0; h<myBugs.length; h++){
       if(myBugs[h].xpos-myFood[i].xpos<=myBugs[h].size && myBugs[h].xpos-myFood[i].xpos>=-1*(myBugs[h].size)){
         if(myBugs[h].ypos-myFood[i].ypos<=myBugs[h].size && myBugs[h].ypos-myFood[i].ypos>=-1*(myBugs[h].size)){
           if(!myBugs[h].isCarnivore){
             myBugs[h].energy+=6;
             myFood[i].alive=false;
           }
         }
       }
    }
  }
}

public void eatBug(){
  for(int i=0; i<myBugs.length; i++){
    for(int h=0; h<myBugs.length; h++){
      if(myBugs[h].living && myBugs[h].isCarnivore && myBugs[i].living && h!=i && aboutEqual(myBugs[h].size,myBugs[i].size,4)){
        if(myBugs[h].xpos-myBugs[i].xpos<=(myBugs[h].size+myBugs[i].size) && myBugs[h].xpos-myBugs[i].xpos>=-1*(myBugs[h].size+myBugs[i].size)){
          if(myBugs[h].ypos-myBugs[i].ypos<=(myBugs[h].size+myBugs[i].size) && myBugs[h].ypos-myBugs[i].ypos>=-1*(myBugs[h].size+myBugs[i].size)){
            if(myBugs[h].energy>myBugs[i].energy){
              myBugs[h].energy+=(myBugs[i].energy/10);
              myBugs[i].living = false;
              creatureeaten++;
            }
          }
        }
      }
    }
  }
}

public void updateFood(){
  for(int i=0;i<myBugs.length;i++){
    if(myBugs[i].living){
     myBugs[i].energy=myBugs[i].energy-myBugs[i].energyconsumption;
    }
  }
}

public void checkDead(){
  for(int i=0; i<myBugs.length; i++){
    if(myBugs[i].energy<=0){
      myBugs[i].living=false;
    }
  }
}

public void checkFood(){
  for(int i=0;i<50;i++){
    if(myFood[i].alive==false){
       myFood[i].xpos = (int)random(5,sizex-5);
       myFood[i].ypos = (int)random(5,sizey-5);
       myFood[i].alive=true;
    }
  }
}

public void genFood(){
  for(int i=0;i<50;i++){
    myFood[i] = new Food();
    myFood[i].xpos = (int)random(5,sizex-5);
    myFood[i].ypos = (int)random(5,sizey-5);
    myFood[i].alive = true;
  }
}

public void genBugs(){
  for (int i=0; i<myBugs.length; i++){
    int speedSeed = (int) random(1,20);
    myBugs[i] = new Bug();
    myBugs[i].size = (int)random(5,15);
    if(speedSeed <=5){
      myBugs[i].speedx = (int)random(1,5);
      myBugs[i].speedy = (int)random(1,5);
    }
    if(speedSeed > 5 && speedSeed<11){
      myBugs[i].speedx = (int)random(-5,-1);
      myBugs[i].speedy = (int)random(-5,-1);
    }
    if(speedSeed>= 11 && speedSeed<16){
      myBugs[i].speedx = (int)random(-5,-1);
      myBugs[i].speedy = (int)random(1,5);
    }
    if(speedSeed >= 16 && speedSeed <21){
      myBugs[i].speedx = (int)random(1,5);
      myBugs[i].speedy = (int)random(-5,-1);
    }
    myBugs[i].r =(int)random(0,255);
    myBugs[i].g =(int)random(0,255);
    myBugs[i].b =(int)random(0,255);
    myBugs[i].maturityage = (myBugs[i].size*360)+1800;
    myBugs[i].isCarnivore = false;
    myBugs[i].reproductioncap = (int)random(45,150);
    myBugs[i].incubationperiod = (int)random(90,3600);
    myBugs[i].xpos = (int)random(10,sizex-10);
    myBugs[i].ypos = (int)random(10,sizey-10);
    myBugs[i].reproductionwait = (int)random(0,5400);
    myBugs[i].energy = 50;
    myBugs[i].reproductioncooldown = 0;
    myBugs[i].living = true;
    myBugs[i].energyconsumption = (abs(myBugs[i].speedx)+abs(myBugs[i].speedy))*(0.003f+(abs(myBugs[i].speedx)+abs(myBugs[i].speedy))/1000+(myBugs[i].size*0.00001f));
  }
}

public void moveBugs(){
  for (int i=0; i<myBugs.length; i++){
    if(myBugs[i].living){
      myBugs[i].xpos+=myBugs[i].speedx;
      myBugs[i].ypos+=myBugs[i].speedy;
      myBugs[i].energy=myBugs[i].energy-myBugs[i].energyconsumption;
    }
    if(myBugs[i].xpos+myBugs[i].size>=sizex || myBugs[i].xpos<=0){
        myBugs[i].speedx*=-1;
    }
    if(myBugs[i].ypos+myBugs[i].size>=sizey || myBugs[i].ypos<=0){
      myBugs[i].speedy*=-1;
    }
  }
}

public void checkReproduce(){
  for(int i=0; i<myBugs.length; i++){
    if(myBugs[i].energy > myBugs[i].reproductioncap && myBugs[i].reproductioncooldown<=0 && myBugs[i].living && myBugs[i].age > myBugs[i].maturityage){
      text("This function is being run",70,70);
      Egg[] tempEgg = new Egg[1];
      tempEgg[0] = new Egg();
      tempEgg[0].maturityageA = myBugs[i].maturityage;
      tempEgg[0].isCarnivoreA = myBugs[i].isCarnivore || mutatevore();
      tempEgg[0].sizeA = myBugs[i].size+mutate();
      tempEgg[0].incubationtime = myBugs[i].incubationperiod;
      tempEgg[0].xpos = myBugs[i].xpos;
      tempEgg[0].ypos = myBugs[i].ypos;
      tempEgg[0].energyA = 50;
      tempEgg[0].rA = myBugs[i].r + mutate()*2;
      tempEgg[0].gA = myBugs[i].g + mutate()*2;
      tempEgg[0].bA = myBugs[i].b + mutate()*2;
      tempEgg[0].reproductioncapA = myBugs[i].reproductioncap+mutate()*3;
      tempEgg[0].reproductionwaitA = myBugs[i].reproductionwait+mutate()*30;
      tempEgg[0].incubationperiodA = myBugs[i].incubationperiod+mutate()*30;
      tempEgg[0].speedxA = myBugs[i].speedx+mutate();
      tempEgg[0].speedyA = myBugs[i].speedy+mutate();
      tempEgg[0].energyconsumptionA = (tempEgg[0].speedxA+tempEgg[0].speedyA)*(0.003f+(tempEgg[0].speedxA+tempEgg[0].speedyA)/2000);
      tempEgg[0].living = true;
      myEggs = (Egg[]) append(myEggs, tempEgg[0]);  //Pass the temporary egg off to the permanent egg array for drawing and other handling
      tempEgg[0] = null;
      myBugs[i].energy-=30+(myBugs[i].size);
      myBugs[i].reproductioncooldown = myBugs[i].reproductionwait;
      eggs++;
    }
  }
}

public void eggTimer(){
  for(int i=0;i<myEggs.length;i++){
    if(myEggs[i].incubationtime==0 && myEggs[i].living){
      myEggs[i].living = false;
      Bug[] tempBug = new Bug[1];
      tempBug[0] = new Bug();
      tempBug[0].isCarnivore = myEggs[i].isCarnivoreA;
      tempBug[0].size = myEggs[i].sizeA;
      tempBug[0].maturityage = myEggs[i].maturityageA;
      tempBug[0].xpos = myEggs[i].xpos;
      tempBug[0].ypos = myEggs[i].ypos;
      tempBug[0].living = true;
      tempBug[0].energy = myEggs[i].energyA;
      tempBug[0].r = myEggs[i].rA;
      tempBug[0].g = myEggs[i].gA;
      tempBug[0].b = myEggs[i].bA;
      tempBug[0].reproductioncap = myEggs[i].reproductioncapA;
      tempBug[0].reproductionwait = myEggs[i].reproductionwaitA;
      tempBug[0].reproductioncooldown = 0;
      tempBug[0].incubationperiod = myEggs[i].incubationperiodA;
      tempBug[0].speedy = myEggs[i].speedyA;
      tempBug[0].speedx = myEggs[i].speedxA;
      tempBug[0].energyconsumption = myEggs[i].energyconsumptionA;
      myBugs = (Bug[]) append(myBugs, tempBug[0]);  //Pass the temporary bug off to the permanent bug array for drawing and other handling
      myEggs[i].incubationtime=-1;
      eggs--;
    }
    if(myEggs[i].incubationtime>0){
      text(myEggs[i].incubationtime,60,60);
      myEggs[i].incubationtime--;
    }
  }
}

public int mutate(){
  int mutate =(int)random(1,20);
  int returnval=0;
  if(mutate == 1){
    returnval = 1;
  }
  if(mutate == 11){
    returnval = -1;
  }
  return returnval;
}

public boolean mutatevore(){
  boolean returnval = false;
  int randomSeed = (int) random(1,40);
  if(randomSeed == 1){
    returnval = true;
  }
  return returnval;
}

public boolean aboutEqual(int Num1, int Num2, int Leniancy){
  boolean returnval = false;
  if(abs(Num1-Num2)<=Leniancy || Num1 > Num2){
    returnval = true;
  }
  return returnval;
}

class Egg{
  boolean isCarnivoreA;
  int rA,gA,bA;
  int maturityageA;
  int sizeA;
  int incubationtime;
  int xpos;
  int ypos;
  boolean living;
  float energyA;
  int reproductioncapA;
  int reproductionwaitA;
  int incubationperiodA;
  int speedxA;
  int speedyA;
  float energyconsumptionA;
}

class Bug{
  boolean isCarnivore;
  int r,g,b;
  int age;
  int maturityage;
  int size;
  int xpos;
  int ypos;
  float energy;
  int reproductioncap;
  int reproductionwait;
  int reproductioncooldown;
  int incubationperiod;
  int speedx;
  int speedy;
  float energyconsumption;
  boolean living;
} 

class Food{
  boolean alive;
  int xpos;
  int ypos;
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_170402a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
