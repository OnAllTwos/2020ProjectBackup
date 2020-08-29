
class hello{
  PVector pos = new PVector(0,0);
  float alpha = 255;
  float alphdec = random(1,5);
  color col = color(random(255),random(255),random(255),this.alpha);
  void update(){
    this.alpha-=this.alphdec;
    this.col = color(random(255),random(255),random(255),this.alpha);
    fill(this.col);
    text("Hello world!",this.pos.x,this.pos.y);
    if(this.alpha<=0){
      this.alpha = 255;
      this.pos = new PVector(random(width),random(height));
    }
  }
}
hello[] hellos = new hello[10];
void setup(){
  size(800,800);
  for(int i=0; i<hellos.length; i++){
    hellos[i] = new hello();
    hellos[i].pos = new PVector(random(width),random(height));
    hellos[i].alphdec = random(1,5);
  }
}

void draw(){
  background(0);
  println("Hello world!");
  for(int i=0; i<hellos.length; i++){
    hellos[i].update();
  }
}
