class ReimannRect{
  PVector pos=new PVector(0,0);
  PVector size=new PVector(1,1);
  double area = 0;
  void update(){
    this.area = this.size.x * this.size.y;
  }
  void show(){
    rect(this.pos.x,this.pos.y,this.size.x,this.size.y);
  }
}
class slider{
  PVector pos = new PVector(0,0);
  boolean sliding = false;
  int len = 1000;
  float min = 0;
  float max = 1000;
  float value = 1;
  int sliderpos = len/2;
  slider(){
  }
  slider(int posx, int posy, int len_, float min_, float max_){
    this.pos.x = posx;
    this.pos.y = posy;
    this.len = len_;
    this.min = min_;
    this.max = max_;
  }
  void update(){
    if(this.sliding){
      this.sliderpos = mouseX-(int)this.pos.x;
    }
    if(this.sliderpos<0){
      this.sliderpos = 0;
    }
    if(this.sliderpos>this.len){
      this.sliderpos = this.len;
    }
    this.value = map(sliderpos,0,this.len,this.min,this.max);
    if(this.value<this.min){
      this.value = this.min;
    }
  }
  void show(){
    rect(this.pos.x,this.pos.y,len,30);
    rectMode(CENTER);
    rect(this.pos.x+this.sliderpos,this.pos.y+15,20,50);
    rectMode(CORNER);
  }
}
slider[] sliders = new slider[1];
void setup(){
  for(int i=0; i<sliders.length; i++){
    sliders[i] = new slider(0,width,200,0.00001,50);
  }
  sliders[0].pos.x = 0;
  sliders[0].pos.y = 200;
  sliders[0].len = width;
  size(1800,900);
}
int pW = 25;
void draw(){
  float sum = 0;
  background(255);
  beginShape();
    for(float i=-pW; i<pW+1; i+=0.25){
      vertex(i+width/2,i*i+height-(pW*pW));
    }
  endShape();
  for(int i=0; i<sliders.length; i++){
    sliders[i].update();
    sliders[i].show();
  }
  ReimannRect[] rects = new ReimannRect[(int)(2*pW/sliders[0].value)*2];
  for(int i=0; i<rects.length; i++){
    rects[i] = new ReimannRect();
    rects[i].pos.x = i*sliders[0].value+(width/2)-pW;  //HARD VALUES FROM LINE 64; V=-20
    rects[i].size.x = sliders[0].value;
    rects[i].pos.y = ((i*sliders[0].value-pW)*(i*sliders[0].value-pW)+height-pW*pW);  //HARD VALUES FROM LINE 64; V=-20, V^2 = 400
    rects[i].size.y = height-rects[i].pos.y;
    rects[i].update();
    rects[i].show();
    if(rects[i].area>0){
      sum+=rects[i].area;
    }
  }
  println(sum,width/2,100);
}
void mousePressed(){
  for(int i=0; i<sliders.length; i++){
    if(mouseX>sliders[i].pos.x && mouseX<sliders[i].pos.x+sliders[i].len && mouseY>sliders[i].pos.y && mouseY<sliders[i].pos.y+30){
      sliders[i].sliding = true;
    }
  }
}
void mouseReleased(){
for(int i=0; i<sliders.length; i++){
    sliders[i].sliding = false;
  }
}
