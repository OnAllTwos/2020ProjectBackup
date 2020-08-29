float gravity = -0.2;
String[] words = new String[]{"BAA", "BAAA", "BAAAA"};
class squeak{
  PVector pos = new PVector(width/2,height);
  PVector mom = new PVector(random(-4,4),random(-15,-10));
  float angle = 0;
  int which = (int) random(0,words.length);
  void show(){
    pushMatrix();
    //fill(0,map(this.pos.y,height/3,0,100,0),map(this.pos.y,height/3,0,255,0));
    translate(this.pos.x,this.pos.y);
    rotate(this.angle);
    text(words[which],0,0);
    //text("WAF",0,0);
    popMatrix();
  }
  void update(){
    this.angle = atan2(this.mom.y,this.mom.x);
    this.mom.y-=gravity;
    this.pos.x+=this.mom.x;
    this.pos.y+=this.mom.y;
    if(this.pos.y>height+100){
      this.pos = new PVector(width/2,height);
      this.mom = new PVector(random(-4,4),random(-15,-10));
      this.which = (int)random(0,words.length);
      print(which);
    }
  }
}
squeak[] squeaks = new squeak[8];
void setup(){
  for(int i=0; i<squeaks.length; i++){
    squeaks[i] = new squeak();
    squeaks[i].pos = new PVector(width/2,random(-height*2, height));
  }
  
  textSize(120);
  background(54,57,63);
  size(800,800);
}

void draw(){
  background(54,57,63);
  for(int i=0; i<squeaks.length; i++){
    fill(random(255), random(255), random(255));
    squeaks[i].update();
    squeaks[i].show();
  }
}
