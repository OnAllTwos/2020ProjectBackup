void startGen(){
  int poss = 0;
  int newVal = 0;
  if(stepTime>=15){
   for(int i=0; i<grid.length; i++){  //Check for available numbers horizontally
     for(int j=1; j<10; j++){
       if(grid[(int)cellPos.x][i].value == j){
         grid[(int)cellPos.x][(int)cellPos.y].can[j-1] = false;
       }
     }
     for(int j=1; j<10; j++){  //Check for available numbers vertically
       if(grid[i][(int)cellPos.y].value == j){
         grid[(int)cellPos.x][(int)cellPos.y].can[j-1] = false;
       }
     }
   }
   for(int i=0; i<8; i++){  //Count number of possible values
     if(grid[(int)cellPos.x][(int)cellPos.y].can[i] == true){
       poss++;
     }
   }
   if(poss>0){
     while(newVal == 0){
       int tryVal = (int)random(1,10);
       if(grid[(int)cellPos.x][(int)cellPos.y].can[tryVal-1]){
         newVal = tryVal;
         println(newVal);
       }
     }
   }else{
     print("stumped! backtracking...");
     remCell = new PVector(cellPos.x,cellPos.y);
     backTrack();
     poss = checkPoss(cellPos);
     startGen();
     //backOneCell();
   }
   grid[(int)cellPos.x][(int)cellPos.y].value = newVal;
   println(cellPos.x+", "+cellPos.y);
   if(cellPos.x<8){
     cellPos.x++;
   }else if(cellPos.y<8){
     cellPos.x=0;
     cellPos.y++;
   }
   stepTime=0;
  }else{
    stepTime++;
  }
}
int regenVal(PVector cell){
  int newVal = 0;
  int poss = 0;
  for(int i=0; i<grid.length; i++){  //Check for available numbers horizontally
     for(int j=1; j<10; j++){
       if(grid[(int)cell.x][i].value == j){
         grid[(int)cell.x][(int)cell.y].can[j-1] = false;
       }
     }
     for(int j=1; j<10; j++){  //Check for available numbers vertically
       if(grid[i][(int)cell.y].value == j){
         grid[(int)cell.x][(int)cell.y].can[j-1] = false;
       }
     }
   }
   for(int i=0; i<8; i++){  //Count number of possible values
     if(grid[(int)cell.x][(int)cell.y].can[i] == true){
       poss++;
     }
   }
   if(poss>0){
     while(newVal == 0){
       int tryVal = (int)random(1,10);
       if(grid[(int)cell.x][(int)cell.y].can[tryVal-1]){
         return tryVal;
       }
     }
   }
   return 50;
}
int checkPoss(PVector cell){
  int poss = 0;
  for(int i=1; i<grid.length; i++){  //Check for available numbers horizontally
    for(int j=1; j<10; j++){
      if(grid[(int)cell.x][i].value == j){
        grid[(int)cell.x][(int)cell.y].can[j-1] = false;
      }
    }
    for(int j=1; j<10; j++){  //Check for available numbers vertically
      if(grid[i][(int)cell.y].value == j){
        grid[(int)cell.x][(int)cell.y].can[j-1] = false;
      }
    }
  }
  for(int i=0; i<8; i++){  //Count number of possible values
    if(grid[(int)cell.x][(int)cell.y].can[i] == true){
      poss++;
    }
  }
  return poss;
}
void backOneCell(){
  if(cellPos.x>0){
     cellPos.x--;
  }else if(cellPos.y>0){
     cellPos.x=8;
     cellPos.y--;
  }
}
void backTrack(){
  for(int i=0; i<3; i++){
    backOneCell();
    grid[(int)cellPos.x][(int)cellPos.y].value=0;
  }
}
