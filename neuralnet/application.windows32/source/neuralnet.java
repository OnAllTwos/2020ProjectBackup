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

public class neuralnet extends PApplet {

network test = new network();
int[] nodesLay = {10,18,18,8};
float scale = 1;
float bugScale = 0.25f;
class node{
  PVector pos = new PVector(0,0);
  int Lay = 0;
  float value=0;
  float[] weights;
}

class layer{
  int size;
  node[] nodes;
}

class network{
  layer[] layers;
  public void evaluate(){
    for(int i=1; i<this.layers.length; i++){
      for(int j=0; j<layers[i].nodes.length;j++){
        layers[i].nodes[j].value=0.5f;
        for(int k=0; k<layers[i-1].nodes.length; k++){
          layers[i].nodes[j].value += layers[i-1].nodes[k].value * layers[i-1].nodes[k].weights[j];
          if(layers[i].nodes[j].value<0){
            layers[i].nodes[j].value=0;
          }else if(layers[i].nodes[j].value>1){
            layers[i].nodes[j].value=1;
          }
        }
      }
    }
  }
  public void show(){
    for(int i=0; i<this.layers.length; i++){
      for(int j=0; j<layers[i].nodes.length;j++){
        layers[i].nodes[j].pos = new PVector(200*i+100,80*j+40);
        if(i>0){
          for(int k=0; k<layers[i-1].nodes.length; k++){
            strokeWeight(abs(layers[i-1].nodes[k].weights[j]));
            if(layers[i-1].nodes[k].weights[j]<0){
              stroke(255,0,0);
            }else if(layers[i-1].nodes[k].weights[j]>0){
              stroke(0,255,0);
            }
            line(layers[i-1].nodes[k].pos.x,layers[i-1].nodes[k].pos.y,layers[i].nodes[j].pos.x,layers[i].nodes[j].pos.y);
          }
        }
        this.evaluate();
        strokeWeight(1);
        fill(map(layers[i].nodes[j].value,0,1,0,255));
        ellipse(layers[i].nodes[j].pos.x,layers[i].nodes[j].pos.y,50,50);
      }
    }
  }
}
boolean mP = false;
bug[] bugs = new bug[150];
public void firstBugs(){
  for(int b=0; b<bugs.length;b++){
    bugs[b] = new bug();
    bugs[b].pos = getSpawn();
    bugs[b].tSpeed = random(1,5);
    bugs[b].eggEnergy = random(300,2000);
    bugs[b].eggGest = random(300,3600);
    bugs[b].tSize = random(15,60);
    bugs[b].eyeAngle = random(0,radians(360));
    bugs[b].maturity = random(1200,3600);
    bugs[b].eggRecharge = (int)random(120,420);
    bugs[b].eggMinE = random(100,1000);
    for(int i=0; i<bugs[b].eyes.length;i++){
      bugs[b].eyes[i] = new eye();
      bugs[b].eyes[i].eyeDist = random(15,60);
    }
    //bugs[b].Brain = new network();
    bugs[b].Brain.layers = new layer[nodesLay.length];
    for(int i=0; i<bugs[b].Brain.layers.length; i++){
      bugs[b].Brain.layers[i] = new layer();
      bugs[b].Brain.layers[i].nodes = new node[nodesLay[i]];
      for(int j=0; j<bugs[b].Brain.layers[i].nodes.length; j++){
        bugs[b].Brain.layers[i].nodes[j] = new node();
        bugs[b].Brain.layers[i].nodes[j].Lay = i;
        if(i<bugs[b].Brain.layers.length-1){
          bugs[b].Brain.layers[i].nodes[j].weights = new float[nodesLay[i+1]];
          for(int k=0; k<bugs[b].Brain.layers[i].nodes[j].weights.length; k++){
            bugs[b].Brain.layers[i].nodes[j].weights[k] = random(-1,1);
          }
        }
      }
    }
    for(int i=0; i<bugs[b].Brain.layers[0].nodes.length; i++){
      bugs[b].Brain.layers[0].nodes[i].value = random(0,1);
    }
  }
  
}
public void setup(){
  
  test.layers = new layer[nodesLay.length];
  for(int i=0; i<test.layers.length; i++){
    test.layers[i] = new layer();
    test.layers[i].nodes = new node[nodesLay[i]];
    for(int j=0; j<test.layers[i].nodes.length; j++){
      test.layers[i].nodes[j] = new node();
      test.layers[i].nodes[j].Lay = i;
      if(i<test.layers.length-1){
        test.layers[i].nodes[j].weights = new float[nodesLay[i+1]];
        for(int k=0; k<test.layers[i].nodes[j].weights.length; k++){
          test.layers[i].nodes[j].weights[k] = random(-1,1);
        }
      }
    }
  }
  for(int i=0; i<test.layers[0].nodes.length; i++){
    test.layers[0].nodes[i].value = random(0,1);
  }
  firstBugs();
  mapGen();
  for(int i=0; i<bits.length; i++){
    bits[i] = new food();
    bits[i].pos = getSpawn();
  }
}
boolean firstDone = false;
boolean respawned = false;
boolean baby = false;
int bitsTimer=0;
public void draw(){
  if(bitsTimer>30){
    for(int i=0; i<bits.length; i++){
      if(bits[i].eaten==true){
        bits[i].eaten = false;
        bits[i].pos = getSpawn();
        println("respawned");
        bitsTimer=0;
        respawned = true;
        break;
      }
      if(respawned){
        break;
      }
    }
  }
  respawned = false;
  bitsTimer++;
  translate(-panX,-panY);
  translate(width/2,height/2);
  scale(scale);
  translate(-width/2,-height/2);
  for(int j=0; j<height; j++){
    for(int i=0; i<width; i++){
      set(i,j,map[i][j]);
    }
  }
  if(!firstDone){
    firstBugs();
    firstDone=true;
  }  
  for(int i=0; i<bits.length; i++){
    bits[i].show();
  }
  for(int i=0; i<bugs.length; i++){
    bugs[i].update();
    bugs[i].show();
  }
  //bugs[0].Brain.show();
  if(mP){
    test.layers[0].nodes[0].value=map(mouseY,0,height,0,1);
    test.layers[0].nodes[1].value=map(mouseX,0,width,0,1);
  }
  //for(int i=0; i<nodesLay[nodesLay.length-1]; i++){
  //}
  //test.show();
}
float[][] preMap = new float[1000][1000];
int[][] map = new int[1000][1000];
float continentalFactor = 0.015f; //Higher = more split, Lower = less split; Double when doubling map size in order to increase resolution of map without changing the way they generate.
int seaLevel = 90;
public void mapGen(){
  for(int j=0; j<map[0].length; j++){
    for(int i=0; i<map.length; i++){
      float temp = noise(i*continentalFactor,j*continentalFactor)*255;
      if(temp>seaLevel){
        map[i][j] = color(0,255*((temp-seaLevel)/temp)+seaLevel,0);
      }else{
        map[i][j] = color(0,0,temp+50);
      }
    }
  }
}
public void makeBaby(PVector pos_, bug parent){  //Deepcopy the parent org
  bug newBug = new bug();
  newBug.pos = pos_;
  newBug.Brain.layers = new layer[parent.Brain.layers.length];
  for(int i=0;i<parent.Brain.layers.length;i++){
    newBug.Brain.layers[i] = new layer();
    newBug.Brain.layers[i].nodes = new node[parent.Brain.layers[i].nodes.length];
    for(int j=0;j<parent.Brain.layers[i].nodes.length;j++){
      newBug.Brain.layers[i].nodes[j] = new node();
      if(i!=3){
        newBug.Brain.layers[i].nodes[j].weights = new float[parent.Brain.layers[i].nodes[j].weights.length];
        for(int k=0;k<parent.Brain.layers[i].nodes[j].weights.length;k++){
          //println(i + ", " +j);
          newBug.Brain.layers[i].nodes[j].weights[k] = parent.Brain.layers[i].nodes[j].weights[k] + mutate(10,0.1f,0.2f);
          if(!baby){
          println();
          baby = true;
          }
        }
      }
    }
  }
  newBug.energy = parent.eggEnergy;
  newBug.isEgg = true;
  newBug.tSize = parent.tSize + mutate(15,1,4);
  newBug.eyeAngle = parent.eyeAngle + mutate(10,radians(5),radians(10));
  newBug.tSpeed = parent.tSpeed + mutate(10,0.5f,1.5f);
  newBug.eggGest = parent.eggGest + mutate(10,30,300);
  newBug.eggEnergy = parent.eggEnergy + mutate(10,20,200);
  newBug.maturity = parent.maturity + mutate(10,300,600);
  for(int i=0; i<newBug.eyes.length; i++){
    newBug.eyes[i] = new eye();
    newBug.eyes[i].eyeDist = parent.eyes[i].eyeDist + mutate(10,5,15);;
  }
  bugs = (bug[]) append(bugs,newBug);
  println("BABY");
  baby = true;
}

public float mutate(float chance, float minChange, float maxChange){
  float toBeat = random(0,100);
  if(chance>toBeat){
    int pm = (int)random(0,1);
    switch(pm){
      case 0:
        return random(minChange, maxChange);
      case 1:
        return -1*random(minChange, maxChange);
    }
  }
  return 0;
}

public boolean mutBool(float chance){
  float toBeat = random(0,100);
  if(chance>toBeat){
    return true;
  }
  return false;
}
class bug{
  PVector pos = new PVector(random(width),random(height));
  network Brain = new network();
  float[] senses = {0,0,0,0,0,0,0,0,0};
  boolean alive = true;
  boolean isEgg = false;
  int col = color(random(255),random(255),random(255));
  boolean inWater = false;
  eye[] eyes = new eye[2];
  float energy = 1000;
  float tSpeed = 3;
  float speed = 3*bugScale;
  float speedAc;
  float angle = 0;
  float tSize = 30;
  float energyUse;
  float size = tSize*bugScale;
  float eggEnergy = 500;
  float eggGest;
  float eyeAngle=30;
  float maturity=1300;
  float matTimer=0;
  int eggRecharge=60;
  int eggReTimer=0;
  boolean eggCharged=false;
  int eggTimer=0;
  float eggMinE = 0;
  public void update(){
    if(eggReTimer>eggRecharge){
      this.eggCharged = true;
    }else{
      eggReTimer++;
    }
    if(this.isEgg){
      this.size = tSize*bugScale;
      if(this.eggTimer>=this.eggGest){
        this.isEgg=false;
      }else{
        this.eggTimer++;
      }
    }
    if(this.alive && !isEgg){
      if(matTimer<maturity){
        matTimer++;
      }
      this.col = color(this.Brain.layers[2].nodes[3].value*255,this.Brain.layers[2].nodes[4].value*255,this.Brain.layers[2].nodes[5].value*255);
      this.size = tSize*bugScale;
      this.speed = this.tSpeed*bugScale;
      if(blue(map[(int)this.pos.x][(int)this.pos.y])>0){
        this.inWater = true;
      }else{
        this.inWater = false;
      }
      for(int i=0;i<bits.length;i++){
        if(dist(this.pos.x,this.pos.y,bits[i].pos.x,bits[i].pos.y)<this.size/2+bits[i].size && !bits[i].eaten){
          bits[i].eaten = true;
          this.energy+=1000;
        }
      }
      for(int i=0;i<this.eyes.length;i++){
        int I = 4*i;
        this.eyes[i].eyeDist = this.Brain.layers[this.Brain.layers.length-1].nodes[this.Brain.layers[this.Brain.layers.length-1].nodes.length-2-i].value * this.size * 5;
        this.eyes[i].pos = new PVector(this.pos.x+(eyes[i].eyeDist*cos(this.angle-eyeAngle+i*eyeAngle)),this.pos.y+(eyes[i].eyeDist*sin(this.angle-eyeAngle+i*eyeAngle)));
        this.eyes[i].look();
        int temp = this.eyes[i].see;
        this.senses[I] = map(red(temp),0,255,0,1);
        this.senses[I+1] = map(green(temp),0,255,0,1);
        this.senses[I+2] = map(blue(temp),0,255,0,1);
        if(this.eyes[i].seesCreature){
          this.senses[I+3] = 1;
        }else{
          this.senses[I+3] = 0;
        }
      }
      if(this.inWater){    //Am I in water neuron
        this.speed = tSpeed*bugScale*0.3f;
        this.senses[8] = 1;
      }else{
        this.senses[8]=0;
      }
      for(int i=0;i<senses.length;i++){  //Writing senses to brain
        this.Brain.layers[0].nodes[i].value = senses[i];
      }
      this.Brain.evaluate();
      this.Brain.layers[0].nodes[this.eyes.length*4+1].value = this.Brain.layers[this.Brain.layers.length-1].nodes[this.Brain.layers[this.Brain.layers.length-1].nodes.length-1].value; //Memory node
      //Move
      speedAc = speed*this.Brain.layers[Brain.layers.length-1].nodes[0].value;
      this.angle+=(this.speed/10)*(this.Brain.layers[Brain.layers.length-1].nodes[1].value-0.5f);
      this.pos.x+=cos(this.angle)*speedAc;
      this.pos.y+=sin(this.angle)*speedAc;
      this.energyUse = 1+0.5f*this.tSize*pow(tSpeed,2)*this.Brain.layers[Brain.layers.length-1].nodes[0].value/180;
      if(this.inWater){
        this.energyUse*=1.5f;
      }
      this.energy-=energyUse;
      if(this.energy<0){
        this.alive = false;
      }
      if(matTimer>=maturity && this.energy>=this.eggEnergy && eggCharged && this.energy>eggMinE){
        this.energy-=eggEnergy;
        eggReTimer=0;
        PVector tempPos = new PVector(this.pos.x,this.pos.y);
        makeBaby(new PVector(tempPos.x,tempPos.y),this);
        eggCharged=false;
      }
      if(this.pos.x-this.size/2<0){
        this.pos.x=this.size/2;
      }if(this.pos.x+size/2>width){
        this.pos.x=width-this.size/2;
      }if(this.pos.y-size/2<0){
        this.pos.y=this.size/2;
      }if(this.pos.y+size/2>height){
        this.pos.y=height-this.size/2;
      }
    }
  }
  public void show(){
    if(this.isEgg){
      fill(255,0,255);
      ellipse(this.pos.x,this.pos.y,this.size/3,this.size/3);
    }
    if(this.alive&&!isEgg){
      fill(this.col);
      ellipse(this.pos.x,this.pos.y,this.size,this.size);
      for(int i=0;i<this.eyes.length;i++){
        ellipse(eyes[i].pos.x,eyes[i].pos.y,this.size/3,this.size/3);
      }
    }
  }
}

class eye{
  float eyeDist=30;
  PVector pos = new PVector(0,0);
  int see = color(0,0,0);
  boolean seesCreature = false;
  public void look(){
    for(int i=0; i<bugs.length; i++){
      if(dist(this.pos.x,this.pos.y,bugs[i].pos.x,bugs[i].pos.y)<=bugs[i].size){
        this.seesCreature = true;
      }else{
        this.seesCreature = false;
      }
    }
    this.see = get((int)this.pos.x,(int)this.pos.y);
  }
}

public PVector getSpawn(){
  for(int i=0; i<100; i++){
    PVector trySpawn = new PVector(random(width),random(height));
    if(green(map[(int)trySpawn.x][(int)trySpawn.y])>0){
       return trySpawn;
    }else{
      trySpawn = new PVector(random(width),random(height));
    }
  }
  return(new PVector(0,0));
}
public void mouseWheel(MouseEvent event){
  int e = event.getCount();
  if(e>0 && scale>0){
    //scale-=0.1;
  }else if(e<0){
    // scale+=0.1;
  }
  println(e + " " + scale);
}
int panX;
int panY;
int clickPosx;
int clickPosy;
public void mousePressed(){
  if(!mP){
    //clickPosx = mouseX;
    //clickPosy = mouseY;
  }
  mP = true;
}

public void mouseReleased(){
  if(mP){
    //panX += clickPosx-mouseX;
    //panY += clickPosy-mouseY;
  }
  mP = false;
}
food[] bits = new food[800];
class food{
  PVector pos = new PVector (random(width), random(height));
  boolean eaten = false;
  float size = 35*bugScale;
  public void show(){
    if(!eaten){
      noStroke();
      fill(255,0,0);
      ellipse(this.pos.x,this.pos.y,this.size,this.size);
    }
  }
}
  public void settings() {  size(1000,1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "neuralnet" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
