class tile{
  PVector coord = new PVector(0, 0);
  PVector pos = new PVector(0, 0);
  PVector size = new PVector(0, 0);
  color value = color(255, 255, 255);
  void show(){    //Called to show this individual tile
    fill(this.value);
    rect(this.pos.x, this.pos.y, this.size.x, this.size.y);
  }
  void updateValue(color newVal){  //Set function for value
    this.value = newVal;
  }
  boolean checkHover(){    //Call this when a mouseclick is detected in order to check if this tile was clicked
    if(mouseX >= this.pos.x && mouseX < this.pos.x + this.size.x && mouseY >= this.pos.y && mouseY < this.pos.y + this.size.y){
      return true;
    }
    return false;
  }
}

class checkers{
  tile[][] squares = new tile[8][8];
  
  void initialize(){  //Make sure the board is set up before using
    for(int i=0; i<this.squares.length; i++){
      for(int j=0; j<this.squares[i].length; j++){
        this.squares[j][i] = new tile();  //Initialize each tile.
      }
    }
  }
  
  void show(){   //Show the gameboard
    for(int i=0; i<this.squares.length; i++){
      for(int j=0; j<this.squares[i].length; j++){
        this.squares[j][i].show();    //Display all of the tiles
      }
    }
  }
  
  int[] getTileClicked(){    //Call to find which tile was clicked
    for(int i=0; i<this.squares.length; i++){
      for(int j=0; j<this.squares[i].length; j++){
        if(this.squares[j][i].checkHover()){
          return new int[]{j, i};
        }
      }
    }
    return new int[]{};
  }
  
  void changeTile(int xCoord, int yCoord, color newVal){
    this.squares[xCoord][yCoord].updateValue(newVal);
  }
  
}

class player{
  boolean myTurn = false;
  color col = color(255, 255, 255);
  boolean human = true;
  checkers board;
  
  player(checkers board_, color col_, boolean first_){
    this.board = board_;
    this.col = col_;
    this.myTurn = first_;
  }
}
