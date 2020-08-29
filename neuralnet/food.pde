food[] bits = new food[800];
class food{
  PVector pos = new PVector (random(width), random(height));
  boolean eaten = false;
  float size = 35*bugScale;
  void show(){
    if(!eaten){
      noStroke();
      fill(255,0,0);
      ellipse(this.pos.x,this.pos.y,this.size,this.size);
    }
  }
}
