network test = new network();
int[] nodesLay = {10,18,18,8};
float scale = 1;
float bugScale = 0.25;
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
  void evaluate(){
    for(int i=1; i<this.layers.length; i++){
      for(int j=0; j<layers[i].nodes.length;j++){
        layers[i].nodes[j].value=0.5;
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
  void show(){
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
void firstBugs(){
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
void setup(){
  size(1000,1000);
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
void draw(){
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
