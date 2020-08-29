int tileX = 100;
int tileY = 100;
float gravScale = 10;
PImage img;

class tile{
  PVector coord = new PVector(0,0);
  PVector pos = new PVector(0,0);
  PVector point = new PVector(0,0);
  float value = 0;
  void show(){
    fill(this.value);
    rect(this.coord.x * (width / tileX), this.coord.y * (height / tileX), width / tileX, height / tileY);
  }
  void calculateStream(){
    float maxAdjVal = 0;
    for(int i = -1; i<2; i++){
      for(int j = -1; j<2; j++){
        if(this.coord.x != 0 && this.coord.y != 0 && this.coord.x != tileX-1 && this.coord.y != tileY-1){
          if(tiles[int(this.coord.x)-j][int(this.coord.y)-i].value > maxAdjVal && (j!=0 || i!=0)){
            this.point = new PVector(i,j);
            maxAdjVal = tiles[int(this.coord.x)-j][int(this.coord.y)-i].value;
          }
        }
      }
    }
  }
}
class particle{
  PVector pos = new PVector(0,0);
  PVector vel = new PVector(0,0);
  PVector tileOver = new PVector(0,0);
  void show(){
    fill(0);
    ellipse(this.pos.x, this.pos.y, 10, 10);
  }
  void update(){
    /*for(int j = 0; j < tiles[0].length; j++){
      for(int i = 0; i < tiles.length; i++){
        float factor = sqrt(2*((6.6726*pow(10,-11)*tiles[i][j].value)/pow(dist(this.pos.x,this.pos.y,tiles[i][j].pos.x,tiles[i][j].pos.y),2)))*gravScale;
        this.vel.x -= (((this.pos.x-tiles[i][j].pos.x)/abs(this.pos.x-tiles[i][j].pos.x)) * factor);
        this.vel.y -= (((this.pos.y-tiles[i][j].pos.y)/abs(this.pos.y-tiles[i][j].pos.y)) * factor);
        float angle = atan2(this.pos.y-tiles[i][j].pos.y, this.pos.x-tiles[i][j].pos.x);
        float rawForce = (tiles[i][j].value)/pow(dist(this.pos.x,this.pos.y,tiles[i][j].pos.x,tiles[i][j].pos.y),2) * gravScale;
        this.vel.x = cos(angle) * rawForce;
        this.vel.y = sin(angle) * rawForce;
      }
    }*/
    this.tileOver = new PVector(floor(this.pos.x/tileX),floor(this.pos.y/tileY));
    if(this.pos.x > 0){
      this.vel.x += tiles[int(this.tileOver.x)][int(this.tileOver.y)].point.x * tiles[int(this.tileOver.x)][int(this.tileOver.y)].value/1000;
    }
    if(this.pos.y > 0){
      this.vel.y += tiles[int(this.tileOver.x)][int(this.tileOver.y)].point.y * tiles[int(this.tileOver.x)][int(this.tileOver.y)].value/1000;
    }
    this.pos.x += this.vel.x;
    this.pos.y += this.vel.y;
  }
}

particle[] all = new particle[100];
tile[][] tiles = new tile[tileX][tileY];

void setup(){
  frameRate(120);
  noStroke();
  size(1000, 1000);
  img = loadImage("Img.jpg");
  img.resize(1000, 1000);
  img.filter(GRAY);
  img.loadPixels();
  for(int i = 0; i < all.length; i++){
    all[i] = new particle();
    all[i].pos = new PVector(random(width), random(height));
  }
  for(int j=0; j<tiles[0].length; j++){
    for(int i=0; i<tiles.length; i++){
      tiles[i][j] = new tile();
      tiles[i][j].coord = new PVector(i, j);
      tiles[i][j].pos = new PVector(i * (width/tileX) + (tileX / 2), j * (height/tileY) + (tileY / 2));
      float sum_ = 0;
      int pixNum = 0;
      for(int y = (img.height / tileY) * j; y < (img.height / tileY) * (j + 1); y++){
        for(int x = (img.width / tileX) * i; x < (img.width / tileX) * (i + 1); x++){
          int index = x + y * (img.width);
          sum_ += red(img.pixels[index]);
          pixNum++;
        }
      }
     tiles[i][j].value = sum_ / pixNum;
    }
  }
  for(int j=0; j<tiles[0].length; j++){
    for(int i=0; i<tiles.length; i++){
      tiles[j][i].calculateStream();
    }
  }
  print(tiles[99][99].pos.x);
}

void draw(){
  for(int j = 0; j < tiles[0].length; j++){
    for(int i = 0; i < tiles.length; i++){
      tiles[i][j].show();
    }
  }
  for(int i = 0; i < all.length; i++){
    all[i].update();
    all[i].show();
  }
  //print("Run");
}
