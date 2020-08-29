int borderWeight=10;
int whoseTurn = 0;
class ai{
  boolean crosses = false;
  PVector[] possible = new PVector[0];  //Coords of open slots which the AI can place a move in
  PVector[] threatSolution;
  PVector[] winSolution;
  int enemy = 2;
  void randomMove(){
      int random = (int)random(0,possible.length-1);
      if(possible.length > 0){
        this.makeMove(new PVector(possible[random].x,possible[random].y));
      }
  }
  void myTurn(){
    this.scanBoard();
    this.checkThreats();
    this.checkWin();
    if(this.winSolution.length>0){
      int random = (int)random(0,winSolution.length-1);
      this.makeMove(new PVector(winSolution[random].x,winSolution[random].y));
    }else if(this.threatSolution.length>0){
      int random = (int)random(0,threatSolution.length-1);
      this.makeMove(new PVector(threatSolution[random].x,threatSolution[random].y));
    }else if(possible.length==9){
      this.makeMove(new PVector(1,1));
    }else{
      randomMove();
    }
  }
  void scanBoard(){ 
    if(this.crosses){
      this.enemy = 1;
    }else{
      this.enemy = 2;
    }
    int possibleSize=0;
    int possibleSlot=0;  //Used when recording coordinates of slots; "possible" array position
    for(int i=0; i<boardLength; i++){  //Look over the board once to see how many slots are open
      for(int j=0; j<boardLength; j++){
        if(board[j][i].state==0){
          possibleSize++;
        }
      }
    }
    possible = new PVector[possibleSize];  //Set array size equal to number of open slots
    for(int i=0; i<boardLength; i++){  //Record coordinates of each open slot
      for(int j=0; j<boardLength; j++){
        if(board[j][i].state==0){
          possible[possibleSlot] = new PVector(j,i);
          possibleSlot++;
        }
      }
    }
  }
  void makeMove(PVector coord){
    if(this.crosses){
      board[(int)coord.x][(int)coord.y].state = 2;
    }else{
      board[(int)coord.x][(int)coord.y].state = 1;
    }
  }
  void checkWin(){  //THICC BOY
    int good=2;
    int other=1;
    if(!this.crosses){
      good = 1;
      other = 2;
    }
    winSolution = new PVector[0];
    int winSlot=0;
    int winLength=0;
    boolean otherIn = false;
    int tempCounter=0;
    /*
      ___________________________
     |                           |
     |       COUNT WINS          |
     |___________________________|
    */
    //Horizontally
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[j][i].state==good){
          tempCounter++;
        }
      }    
      if(tempCounter==boardLength-1){
        winLength++;
      }
    }
    //Diagonally LR
    tempCounter=0;
    for(int i=0; i<boardLength; i++){
      if(board[i][i].state==good){
        tempCounter++;
      } 
    }
    if(tempCounter==boardLength-1){
        winLength++;
    }
    //Vertically
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[i][j].state==good){
          tempCounter++;
        }
      }    
      if(tempCounter==boardLength-1){
        winLength++;
      }
    }
    //Diagonally RL
    tempCounter=0;
    for(int i=2; i>-1; i--){
      if(board[i][boardLength-1-i].state==good){
        tempCounter++;
      } 
    }
    if(tempCounter==boardLength-1){
        winLength++;
    }
    winSolution = new PVector[winLength];
    /*
      ___________________________
     |                           |
     | FIND SOLUTION HORIZONTALLY|
     |___________________________|
    */
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[j][i].state==good){
          tempCounter++;
        }
      }    
      if(tempCounter==2){
        for(int h=0; h<boardLength; h++){
          if(board[h][i].state==0){
            winSolution[winSlot]=new PVector(h,i);
            winSlot++;
          }
        }
      }
    }
    /*
      ___________________________
     |                           |
     | FIND SOLUTION VERTICALLY  |
     |___________________________|
    */
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[i][j].state==good){
          tempCounter++;
        }
      }
      if(tempCounter==2){
        for(int h=0; h<boardLength; h++){
          if(board[i][h].state==0){
            winSolution[winSlot]=new PVector(i,h);
            winSlot++;
          }
        }
      }
    }
    /*
      ___________________________
     |                           |
     |FIND SOLUTION DIAGONALLY LR|
     |___________________________|
    */
    tempCounter=0;
    for(int i=0; i<boardLength; i++){
      if(board[i][i].state==good){
        tempCounter++;
      }
    }
    if(tempCounter==2){
      for(int h=0; h<boardLength; h++){
        if(board[h][h].state==0){
          print("found win!"+good);
          winSolution[winSlot]=new PVector(h,h);
          winSlot++; 
        }
      }
    }
    /*
      ___________________________
     |                           |
     |FIND SOLUTION DIAGONALLY RL|
     |___________________________|
    */
    tempCounter=0;
    for(int i=2; i>-1; i--){
      if(board[i][boardLength-1-i].state==good){
        tempCounter++;
      }
    }
    if(tempCounter==2){
      for(int h=2; h>-1; h--){
        if(board[h][boardLength-1-h].state==0){
          print("found win!"+good);
          winSolution[winSlot]=new PVector(h,boardLength-1-h);
          winSlot++;
        }
      }
    }
    PVector[] fixBugs = new PVector[winSlot];
    arrayCopy(winSolution,fixBugs,winSlot);
    winSolution = new PVector[winSlot];
    arrayCopy(fixBugs,winSolution);
  }
  void checkThreats(){  //THICC BOY
    int bad = 1;
    int other = 2;
    if(!this.crosses){
      bad = 2;
      other = 1;
    }else{
      bad = 1;
      other = 2;
    }
    threatSolution = new PVector[0];
    int threatSlot=0;
    int threatLength=0;
    int tempCounter=0;
    boolean otherIn = false;
    /*
      ___________________________
     |                           |
     |       COUNT THREATS       |
     |___________________________|
    */
    //Horizontally
    otherIn = false;
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[j][i].state==bad){
          tempCounter++;
        }
      }    
      if(tempCounter==boardLength-1){
        threatLength++;
      }
    }
    //Diagonally LR
    tempCounter=0;
    for(int i=0; i<boardLength; i++){
      if(board[i][i].state==bad){
        tempCounter++;
      } 
    }
    if(tempCounter==boardLength-1){
        threatLength++;
    }
    //Vertically
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[i][j].state==bad){
          tempCounter++;
        }
      }    
      if(tempCounter==boardLength-1){
        threatLength++;
      }
    }
    //Diagonally RL
    tempCounter=0;
    for(int i=boardLength-1; i>-1; i--){
      if(board[i][boardLength-1-i].state==bad){
        tempCounter++;
      } 
    }
    if(tempCounter==boardLength-1){
        threatLength++;
    }
    threatSolution = new PVector[threatLength];
    /*
      ___________________________
     |                           |
     | FIND SOLUTION HORIZONTALLY|
     |___________________________|
    */
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[j][i].state==bad){
          tempCounter++;
        }
      }    
      if(tempCounter==2){
        for(int h=0; h<boardLength; h++){
          if(board[h][i].state==0){
            threatSolution[threatSlot]=new PVector(h,i);
            threatSlot++;
          }
        }
      }
    }
    /*
      ___________________________
     |                           |
     | FIND SOLUTION VERTICALLY  |
     |___________________________|
    */
    for(int i=0; i<boardLength; i++){
      tempCounter=0;
      for(int j=0; j<boardLength; j++){
        if(board[i][j].state==bad){
          tempCounter++;
        }
      }
      if(tempCounter==2){
        for(int h=0; h<boardLength; h++){
          if(board[i][h].state==0){
            threatSolution[threatSlot]=new PVector(i,h);
            threatSlot++;
          }
        }
      }
    }
    /*
      ___________________________
     |                           |
     |FIND SOLUTION DIAGONALLY LR|
     |___________________________|
    */
    tempCounter=0;
    for(int i=0; i<boardLength; i++){
      if(board[i][i].state==bad){
        tempCounter++;
      }
    }
    if(tempCounter==2){
      for(int h=0; h<boardLength; h++){
        if(board[h][h].state==0){
          print("found block!");
          threatSolution[threatSlot]=new PVector(h,h);
          threatSlot++; 
        }
      }
    }
    /*
      ___________________________
     |                           |
     |FIND SOLUTION DIAGONALLY RL|
     |___________________________|
    */
    tempCounter=0;
    for(int i=boardLength-1; i>=0; i--){
      if(board[i][boardLength-1-i].state==bad){
        tempCounter++;
      }
    }
    if(tempCounter==2){
      for(int h=boardLength-1; h>=0; h--){
        if(board[h][boardLength-1-h].state==0){
          print("found block"+bad);
          threatSolution[threatSlot]=new PVector(h,boardLength-1-h);
          threatSlot++;
        }
      }
    }
    print("Before: ");
    print(threatSolution);
    PVector[] fixBugs = new PVector[threatSlot];
    arrayCopy(threatSolution,fixBugs,threatSlot);
    threatSolution = new PVector[threatSlot];
    arrayCopy(fixBugs,threatSolution);
    print(" After: ");
    print(threatSolution);
  }
}
ai test = new ai();
ai test2 = new ai();
class box{
  int state = 0;  //0 = empty, 1 = naught, 2 = cross
  PVector pos = new PVector(0,0);
  void show(){
    switch(state){
      case 1:
        text("O",this.pos.x,this.pos.y);
        break;
      case 2:
        text("X",this.pos.x,this.pos.y);
        break;
    }
  }
}
int boardLength = 3;
box[][] board = new box[boardLength][boardLength];
int boxSize;
void setup(){
  textSize(40);
  size(1000,1000);
  boxSize = width/board.length;
  for(int i=0; i<board[0].length; i++){
    for(int j=0; j<board.length;j++){
      board[j][i] = new box();
      board[j][i].pos = new PVector(j*boxSize+boxSize/2-borderWeight,i*boxSize+boxSize/2+borderWeight);
    }
  }
  test2.crosses = true;
}
void draw(){
  for(int i=1; i<boardLength; i++){
    strokeWeight(borderWeight);
    line(i*boxSize,0,i*boxSize,height);
    line(0,i*boxSize,width,i*boxSize);
  }
  for(int i=0; i<boardLength; i++){
    for(int j=0; j<boardLength; j++){
      board[j][i].show();
    }
  }
  //print(test.winSolution.length);
}
void mouseClicked(){
  int boxX = 0;
  int boxY = 0;
  if(mouseX>0 && mouseX<width/boardLength){
    boxX = 0;
  }
  if(mouseX > width/boardLength && mouseX < 2*width/boardLength){
    boxX = 1;
  }
  if(mouseX > 2*width/boardLength && mouseX < 3*width/boardLength){
    boxX = 2;
  }
  if(mouseY>0 && mouseY< height/boardLength){
    boxY = 0;
  }
  if(mouseY > height/boardLength && mouseY<2*height/boardLength){
    boxY = 1;
  }
  if(mouseY > 2*height/boardLength && mouseY<3*height/boardLength){
    boxY = 2;
  }
  if(board[boxX][boxY].state == 0){
    board[boxX][boxY].state = 2;
    test.myTurn();
  }
}
