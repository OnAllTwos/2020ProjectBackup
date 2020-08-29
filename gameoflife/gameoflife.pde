int gridSizeX = 500;
int gridSizeY = 500;
int gridX;
int gridY;

void setup(){
  frameRate(120);
  size(1900,1100);
  for(int i=0; i<gridSizeX; i++){
    for(int j=0; j<gridSizeY; j++){
      grid[j][i] = ranGen();
    }
  }
  gridX = width/gridSizeX;
  gridY = height/gridSizeY;
}

int[][] grid = new int[gridSizeX][gridSizeY];
int[][] tempGrid = new int[gridSizeX][gridSizeY];
void draw(){
  noStroke();
  for(int i = 0; i<gridSizeX; i++){
    arrayCopy(grid[i], tempGrid[i]);
  }
  for(int i = 0; i<gridSizeX; i++){
    for(int j = 0; j<gridSizeY; j++){
      if(grid[i][j] == 1){
        fill(0);
        rect(j*gridX, i*gridY, gridX-1,gridY-1);
      }
      if(grid[i][j] == 0){
        fill(255);
        rect(j*gridX, i*gridY, gridX-1,gridY-1);
      }
    }
  }
  nextGen();
}

public int ranGen(){
  if(random(-0.5,1)<0){
    return 0;
  }else{
    return 1;
  }
}

public void nextGen(){
  for(int i = 0; i<gridSizeX; i++){
    for(int j = 0;j<gridSizeY; j++){
      if((grid[i][j] == 1 && countNeighbors(i,j) < 2) || (grid[i][j] == 1 && countNeighbors(i,j) > 3)){
        tempGrid[i][j] = 0;
      }
      if(grid[i][j] == 0 && countNeighbors(i,j) == 3){
        tempGrid[i][j] = 1;
      }
    }
  }
  for(int i = 0; i<gridSizeX; i++){
    arrayCopy(tempGrid[i], grid[i]);
  }
}

public int countNeighbors(int x, int y){
  int neighbors = 0;
  if(x-1>=0 && x+1<gridSizeX && y-1>=0 && y+1<gridSizeY){
    if(grid[x-1][y-1] == 1){
      neighbors++;
    }
    if(grid[x-1][y] == 1){
      neighbors++;
    }
    if(grid[x-1][y+1] == 1){
      neighbors++;
    }
    if(grid[x][y-1] == 1){
      neighbors++;
    }
    if(grid[x][y+1] == 1){
      neighbors++;
    }
    if(grid[x+1][y-1] == 1){
      neighbors++;
    }
    if(grid[x+1][y] == 1){
      neighbors++;
    }
    if(grid[x+1][y+1] == 1){
      neighbors++;
    }
    return neighbors;
  }else{
    return 0;
  }
}