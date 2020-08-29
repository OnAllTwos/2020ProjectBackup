int stepTime = 0;
boolean stumped = false;
PVector cellPos = new PVector(0,0);
PVector remCell = new PVector(0,0);
int possBeat = 0;
class cell{
  boolean[] can = new boolean[9];
  PVector pos = new PVector(0,0);
  int value = 0;
  void show(){
    fill(255);
    rect(this.pos.x,this.pos.y,width/9,height/9);
    fill(0);
    text(this.value,this.pos.x+width/18,this.pos.y+height/18);
  }
}
cell[][] grid = new cell[9][9];
void setup(){
  textSize(50);
  size(900,900);
  for(int i=0; i<grid.length; i++){
    for(int j=0; j<grid[i].length; j++){
      grid[j][i] = new cell();
      grid[j][i].pos = new PVector((width/9)*j,(height/9)*i);
      for(int k=0; k<grid[j][i].can.length; k++){
        grid[j][i].can[k] = true;
      }
    }
  }
}

void draw(){
  if(!stumped){
    startGen();
  }
  background(255);
  for(int i=0; i<grid.length; i++){
    for(int j=0; j<grid[i].length; j++){
      grid[j][i].show();
    }
  }
}
