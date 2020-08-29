/*
  Use Perlin noise to generate 2D maps. I'll probably end up using this in the future
  to make some kind of game like Dwarf Fortress or Starcraft maybe
*/
tile[][] map = new tile[500][500]; 
float continentalFactor = 0.04; //Higher = more split, Lower = less split; Double when doubling map size in order to increase resolution of map without changing the way they generate.
float tileSize = 100;
int seaLevel = 150;
PVector cameraOff = new PVector(0,0);
float cameraZoom = 1;
class tile{
  PVector index = new PVector(0,0);
  float value = 0;
  float type = 0; //0 = water; 1 = land
  color fill = color(0,0,0);
  void show(){
    if((this.index.x-cameraOff.x)*(tileSize*cameraZoom)>0 && (this.index.y-cameraOff.y)*(tileSize*cameraZoom)>0 && (this.index.y-cameraOff.y)*(tileSize*cameraZoom)<height && (this.index.x-cameraOff.x)*(tileSize*cameraZoom)<width){
      if(this.value>seaLevel){
        stroke(fill);
        fill(fill);
      }else{
        stroke(fill);
        fill(fill);
      }
      rect((this.index.x-cameraOff.x)*(tileSize*cameraZoom), (this.index.y-cameraOff.y)*(tileSize*cameraZoom), tileSize*cameraZoom, tileSize*cameraZoom);
    }
  }
}
void setup(){
  size(1000,1000);
  if(width/map.length<height/map[0].length){
    tileSize = width/map.length;
  }else{
    tileSize = height/map[0].length;
  }
  for(int j=0; j<map[0].length; j++){
    for(int i=0; i<map.length; i++){
      map[i][j] = new tile();
      map[i][j].index = new PVector(i,j);
      map[i][j].value = noise(i*continentalFactor,j*continentalFactor)*255;
      float tempval = map[i][j].value;
      if(tempval>seaLevel){
        map[i][j].fill = color(0,255*((tempval-seaLevel)/tempval)+seaLevel,0);
        map[i][j].type = 1;
      }else{
        map[i][j].type = 0;
        map[i][j].fill = color(0,0,tempval+50);
      }
    }
  }
}
void draw(){
  background(255);
  for(int j=0; j<map[0].length; j++){
    for(int i=0; i<map.length; i++){
      map[i][j].show();
    }
  }
}
