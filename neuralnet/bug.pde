class bug{
  PVector pos = new PVector(random(width),random(height));
  network Brain = new network();
  float[] senses = {0,0,0,0,0,0,0,0,0};
  boolean alive = true;
  boolean isEgg = false;
  color col = color(random(255),random(255),random(255));
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
  void update(){
  this.eggEnergy = this.tSize*30; 
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
        color temp = this.eyes[i].see;
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
        this.speed = tSpeed*bugScale*0.3;
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
      this.angle+=(this.speed/10)*(this.Brain.layers[Brain.layers.length-1].nodes[1].value-0.5);
      this.pos.x+=cos(this.angle)*speedAc;
      this.pos.y+=sin(this.angle)*speedAc;
      this.energyUse = 1 + 0.4*this.tSize * pow(tSpeed,2) * this.Brain.layers[Brain.layers.length-1].nodes[0].value/180;
      if(this.inWater){
        this.energyUse*=1.5;
      }
      this.energy-=energyUse;
      if(this.energy<=0){
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
  void show(){
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
  color see = color(0,0,0);
  boolean seesCreature = false;
  void look(){
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

PVector getSpawn(){
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
