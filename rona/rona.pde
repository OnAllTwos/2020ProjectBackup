
PrintWriter out;
float contagionFactor = 10;
int pSize = 4;
float contagionRad = pSize * 4;
class student{
  PVector pos = new PVector(0, 0);
  PVector mom = new PVector(0, 0);
  boolean inf = false;
  boolean imm = false;
  int movTimer = 0;
  int movLen = 0;
  int infTimer = 0;
  int infLen = 0;
  void catchTheRona(){
    if(!this.inf){
      for(int i=0; i<stdClass.length; i++){
        if(dist(this.pos.x, this.pos.y, stdClass[i].pos.x, stdClass[i].pos.y)<contagionRad && !this.inf && stdClass[i].inf && !this.imm){
          this.inf = random(100) > (100-(contagionFactor/100));
        }
      }
    }else{
      if(this.infTimer < this.infLen){
        this.infTimer++;
      }else{
        this.inf = false;
        this.imm = true;
      }
    }
  }
  void update(){
    if(this.movTimer < this.movLen){
      this.movTimer++;
    }else{
      this.mom = PVector.fromAngle(random(0, 2*PI));
      this.movTimer = 0;
      this.movLen = (int) random(60,300);
    }
    this.pos.add(this.mom);
    if(this.pos.x > width){
      this.pos.x = width;
      this.movLen = -1;
    }
    if(this.pos.x < 0){
      this.pos.x =  0;
      this.movLen = -1;
    }
    if(this.pos.y > height){
      this.pos.y = height;
      this.movLen = -1;
    }
    if(this.pos.y < 0){
      this.pos.y = 0;
      this.movLen = -1;
    }
  }
  void show(){
    fill(this.inf ? color(255,0,0) : (this.imm ? color(0,0,255) : color(0,255,0)));
    ellipse(this.pos.x, this.pos.y, pSize, pSize);
    if(this.inf){
      noFill();
      ellipse(this.pos.x, this.pos.y, contagionRad*2, contagionRad*2);
    }
  }
}

student[] stdClass = new student[1000];

void setup(){
  size(1000,1000);
  for(int i=0; i<stdClass.length; i++){
    stdClass[i] = new student();
    stdClass[i].infLen = (int) random(10080, 20160);
    stdClass[i].pos = new PVector(random(width), random(height));
    stdClass[i].inf = random(100) > 99;
  }
  out = createWriter("nums.csv");
}

void draw(){
  background(255);
  for(int i=0; i<stdClass.length; i++){
    stdClass[i].update();
    stdClass[i].catchTheRona();
    stdClass[i].show();
  }
  if(frameCount % 60 == 0){
    int infNum = 0;
    for(int i=0; i<stdClass.length; i++){
      if(stdClass[i].inf){
        infNum++;
      }
    }
    out.print(infNum+", ");
    out.flush();
    println(infNum);
  }
}
