class menu{  //Menu class!
  button[] buttons;
  slider[] sliders;
  void display(){
    for(int i=0; i<this.buttons.length; i++){
      buttons[i].show();
    }
    for(int i=0; i<this.sliders.length; i++){
      sliders[i].show();
    }
  }
}
class slider{    //I am proud of this UwU
  boolean sliding;
  color textColor = color(0,0,0);
  boolean displayVal = true;
  PVector pos = new PVector(0,0);
  float sliderPos = 0;  //The actual position of the slider relative to the position of the value of 0 on the slider
  float len = 0;  //Absolute length of the slider in pixels
  String text = "";  //The text to write above this slider
  float sliderVal = 0;  //The value to be read
  float mapMin = 0;  //Floor for possible slider vals
  float mapMax = 100;  //Ceiling for possible slider vals
  float textSize = 40;
  boolean integer = false;  //If true, there will be no decimal points
  slider(String text_,float posX_,float posY_,float len_,float mapMin_,float mapMax_){
    pos = new PVector(posX_,posY_);
    len = len_;
    text = text_;
    mapMin = mapMin_;
    mapMax = mapMax_;
  }
  void getSliderVal(){  //Used to make sure all values are set to their defaults without ever needing to open the settings menu
    sliderVal = map(sliderPos,0,len,mapMin,mapMax);
  }
  void show(){  //You know how it be
    textSize(textSize);
    fill(textColor);
    textAlign(LEFT);
    if(!integer && this.displayVal){
      text(this.text + ": " + nf(this.sliderVal,0,1),this.pos.x,this.pos.y-20);
    }else if(this.displayVal){
      text(this.text + ": " + (int) this.sliderVal,this.pos.x,this.pos.y-20);
    }else if(!this.displayVal){
      text(this.text,this.pos.x,this.pos.y-20);
    }
    fill(100,100,100);
    rect(this.pos.x,this.pos.y,len,10);
    fill(255,255,255);
    rectMode(CENTER);
    rect(sliderPos+this.pos.x,this.pos.y+5,7,20);
    rectMode(CORNER);
    sliderVal = map(sliderPos,0,len,mapMin,mapMax);
  }
}
class button{
  boolean isImage = false;
  boolean selected = false;  //Will change color to show that it has been toggled if desired
  PVector pos = new PVector(0,0);
  PVector size = new PVector(0,0);
  float textSize = 40;
  String text = "";
  PImage buttonImg = loadImage("rscs/sing.png");
  color selectColor = color(0,200,0);
  color textColor = color(10,10,10);
  color rectColor = color(255,255,255,200);
  button(String text_,float posX_, float posY_, float sizeX_, float sizeY_){  //Use default colors
    this.text = text_;
    this.pos = new PVector(posX_,posY_);
    this.size = new PVector(sizeX_,sizeY_);
  }
  button(float posX_, float posY_, float sizeX_, float sizeY_, String path_){ //Buttons with PICTURES :OOOO
    this.buttonImg = loadImage(path_);
    this.buttonImg.resize((int)sizeX_,(int)sizeY_);
    this.pos = new PVector(posX_,posY_);
    this.size = new PVector(sizeX_,sizeY_);
  }
  button(String text_,float posX_, float posY_, float sizeX_, float sizeY_, color textColor_, color rectColor_){  //Colorful buttons
    this.text = text_;
    this.pos = new PVector(posX_,posY_);
    this.size = new PVector(sizeX_,sizeY_);
    this.textColor = textColor_;
    this.rectColor = rectColor_;
  }
  void setImage(PImage image){
    this.buttonImg = image;
    buttonImg.resize((int)this.size.x,(int)this.size.y);
  }
  void setImage(String path){
    this.buttonImg = loadImage(path);
    buttonImg.resize((int)this.size.x,(int)this.size.y);
  }
  void show(){
    fill(rectColor);
    rect(this.pos.x,this.pos.y,this.size.x,this.size.y);
    textAlign(CENTER);
    textSize(textSize);
    if(this.isImage){
      image(this.buttonImg,this.pos.x,this.pos.y);
    }
    if(selected){
      fill(selectColor);
    }else{
      fill(textColor);
    }
    text(this.text,this.pos.x+this.size.x/2,this.pos.y+this.size.y/2);
  }
}
PFont cS;
void initializeMenus(){
  cS = createFont("rscs/comicSans.ttf",40);
  // Start Main Menu
  mainMenuE.buttons = new button[4];  //Change then number here to the total number of buttons
  mainMenuE.sliders = new slider[0];
  mainMenuE.buttons[0] = new button("Start Game",(width-600)/2,400,600,100);  // 0 ; Start Button
  mainMenuE.buttons[1] = new button("Difficulty Settings",(width-600)/2,500,600,100);  // 1 ; Difficulty Settings\\
  mainMenuE.buttons[2] = new button("Skins", (width-600)/2, 700, 600,100);
  mainMenuE.buttons[3] = new button("Credit",(width-600)/2,600,600,100);
  // End Main Menu, Start Settings Menu
  settingsMenuE.buttons = new button[2];
  settingsMenuE.sliders = new slider[7];
  settingsMenuE.buttons[0] = new button("Teemo Darts",50,height-150,900,100);
  settingsMenuE.buttons[1] = new button("Back to Main Menu",width-200,-1,200,100);
  settingsMenuE.buttons[1].textSize = 20;
  settingsMenuE.sliders[0] = new slider("Max Shroom Throw Distance",50,height-200,width-100,0,400);
  settingsMenuE.sliders[0].sliderPos = map(150,0,settingsMenuE.sliders[0].mapMax,0,settingsMenuE.sliders[0].len);    //Sliderval is dependent upon sliderpos, so sliderpos is mapped to value which yields a sliderval of 150.
  settingsMenuE.sliders[0].getSliderVal();
  settingsMenuE.sliders[1] = new slider("Teemo MS",50,height-300,width-100,0,20);
  settingsMenuE.sliders[1].sliderPos = map(teemoMS,0,settingsMenuE.sliders[1].mapMax,0,settingsMenuE.sliders[1].len);
  settingsMenuE.sliders[1].getSliderVal();
  settingsMenuE.sliders[2] = new slider("Singed MS",50,height-400,width-100,0,20);
  settingsMenuE.sliders[2].sliderPos = map(singedMS,0,settingsMenuE.sliders[2].mapMax,0,settingsMenuE.sliders[2].len);
  settingsMenuE.sliders[2].getSliderVal();
  settingsMenuE.sliders[3] = new slider("Shroom Throw Interval (Frames)",50,height-500,width-100,0,360);
  settingsMenuE.sliders[3].sliderPos = map(90,0,settingsMenuE.sliders[3].mapMax,0,settingsMenuE.sliders[3].len);
  settingsMenuE.sliders[3].getSliderVal();
  settingsMenuE.sliders[4] = new slider("Singed Starting HP",50,height-600,width-100,1,5);
  settingsMenuE.sliders[4].sliderPos = map(5,0,settingsMenuE.sliders[4].mapMax,0,settingsMenuE.sliders[4].len);
  settingsMenuE.sliders[4].getSliderVal();
  settingsMenuE.sliders[4].integer = true;
  settingsMenuE.sliders[5] = new slider("Teemo Starting HP",50,height-700,width-100,1,600);
  settingsMenuE.sliders[5].sliderPos = map(150,0,settingsMenuE.sliders[5].mapMax,0,settingsMenuE.sliders[5].len);
  settingsMenuE.sliders[5].getSliderVal();
  settingsMenuE.sliders[5].integer = true;
  settingsMenuE.sliders[6] = new slider("Teemo Dart Interval (Frames)",50,height-800,width-100,0,600);
  settingsMenuE.sliders[6].sliderPos = map(180,0,settingsMenuE.sliders[6].mapMax,0,settingsMenuE.sliders[6].len);
  settingsMenuE.sliders[6].getSliderVal();
  settingsMenuE.sliders[6].integer = true;
  //End Settings Menu, Start End Menu
  endMenuE.buttons = new button[2];
  endMenuE.sliders = new slider[0];
  endMenuE.buttons[0] = new button("Play again",(width-400)/2,height*0.4,400,100);
  endMenuE.buttons[0].rectColor = color(0,255,0,200);
  endMenuE.buttons[1] = new button("Main Menu",(width-400)/2,height*0.4+100,400,100);
  endMenuE.buttons[1].rectColor = color(255,255,0,200);
  //End End Menu, Start Credits Menu
  creditsMenuE.buttons = new button[1];
  creditsMenuE.sliders = new slider[0];
  creditsMenuE.buttons[0] = new button("Back to Main Menu",width-199,0,200,100);
  creditsMenuE.buttons[0].textSize = 20;
  //End of Credits Menu, Start of Skins Menu
  skinsMenuE.buttons = new button[3];
  skinsMenuE.sliders = new slider[1];
  skinsMenuE.buttons[0] = new button("Back to Main Menu",width-199,0,200,100);
  skinsMenuE.buttons[0].textSize = 20;
  skinsMenuE.buttons[1] = new button(width/2-250,0,500,800,chosenSkinPath);
  skinsMenuE.buttons[1].isImage = true;
  skinsMenuE.sliders[0] = new slider("      Slide to select skin", width/2-250,850,500,0,9);
  skinsMenuE.sliders[0].textColor = color(255,255,255,200);
  skinsMenuE.sliders[0].integer = true;
  skinsMenuE.sliders[0].displayVal = false;
  skinsMenuE.buttons[2] = new button("Apply Skin", width/2-250,850,500,100);
}
void buttonFunctions(int id){  //Function called by mousePressed to perform the actions assigned to each button. The "id" value is the array position for the button in a menu.
  if(mainMenu){
    switch(id){
      case 0:
        player.health = settingsMenuE.sliders[4].sliderVal;
        gameRunning = true;
        mainMenu = false;
        enemyPC.health = settingsMenuE.sliders[5].sliderVal;
        break;
      case 1:
        mainMenu = false;
        settingsMenu = true;
        break;
      case 2:
        background(255);
        mainMenu = false;
        skinsMenu = true;
        break;
      case 3:
        mainMenu = false;
        creditsMenu = true;
        break;
    }
  }
  else if(creditsMenu){
    switch(id){
      case 0:
        creditsMenu = false;
        mainMenu = true;
        break;
    }
  }
  else if(skinsMenu){
    switch(id){
      case 0:
        skinsMenu = false;
        mainMenu = true;
        break;
      case 2:
        if(round(skinsMenuE.sliders[0].sliderVal)!=9){
          chosenSkin = round(skinsMenuE.sliders[0].sliderVal);
        }else if(round(skinsMenuE.sliders[0].sliderVal)==9){
          makeDeal = true;
        }
        break;
    }
  }
  else if(settingsMenu){
    switch(id){
      case 0:
        useDarts = !useDarts;
        settingsMenuE.buttons[0].selected = !settingsMenuE.buttons[0].selected;
        break;
      case 1:
        settingsMenu = false;
        mainMenu = true;
        break;
    }
  }
  else if(endMenu){
    switch(id){
      case 0:
        refreshGame();
        mainMenu = false;
        gameRunning = true;
        endMenu = false;
        break;
      case 1:
        refreshGame();
        endMenu = false;
        gameRunning = false;
        mainMenu = true;
        stroke(0);
    }
  }
}

void refreshGame(){  //Resets most values to their defaults, essentially resetting the game
      enemyPC.pos = new PVector(0,0);
      player.pos = new PVector(width/2,height-img.height);
      enemyPC.health = 150;
      player.health = settingsMenuE.sliders[4].sliderVal;
      for(int i=0; i<darts.length; i++){
        darts[i].pos = new PVector(-1000,-1000);
        darts[i].mom = new PVector(0,0);
      }
      for(int i=0; i<mushrooms.length; i++){
        mushrooms[i].pos = new PVector(-1000,-1000);
      }
      for(int i=0; i<poisonCloud.length; i++){
        poisonCloud[i].pos = new PVector(-1000,-1000);
      }
      lost = false;
      won = false;
      poisonCounter = 0;
      shroomCounter = 0;
      shroomNumber = 0;
      dartCounter = 0;
      dartNumber = 0;
      player.alive = true;
      enemyPC.alive = true;
      enemyPC.isPoisoned = false;
}
//<Menu declarations>
menu skinsMenuE = new menu();
menu creditsMenuE = new menu();
menu mainMenuE = new menu();
menu endMenuE = new menu();
menu settingsMenuE = new menu();
//</Menu declarations>
