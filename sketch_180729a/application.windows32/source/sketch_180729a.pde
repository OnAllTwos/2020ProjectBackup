/* 
This is a League of Legends fan game
Started in August 2018
The only library used here is the sound library,
all of the menu elements are of my own spaghetti'd design
*/
import processing.sound.*;  //So that I can play sound files
//<Declaration of global variables>
float endRotation = 0;
float singedMS = 7;
float teemoMS = 5;
float teemoAimCompens = 140;
float dartMS = 10;
int chosenSkin = 0;
String chosenSkinPath = "rscs/sing.png";
int poisonParts = 600;
int poisonCounter = 0;
int poisonDensity = 6;
int shroomCounter = 0;
int shroomNumber = 0;
int dartCounter = 0;
int dartNumber = 0;
boolean gameRunning = false;
boolean mainMenu = true;
boolean endMenu = false;
boolean settingsMenu = false;
boolean creditsMenu = false;
boolean skinsMenu = false;
boolean useDarts;
boolean lost = false;
boolean won = false;
boolean makeDeal = false;
//</Declaration of global variables>
class projectile{  //Pretty much the dart class
  PVector pos = new PVector(-1000,-1000);
  PVector mom = new PVector(0,0);
  float angle = 0;
  boolean alive;
  void setMom(PVector source, PVector target){
    this.mom = new PVector(cos(atan2(source.y-target.y,source.x-target.x))*dartMS,sin(atan2(source.y-target.y,source.x-target.x))*dartMS);  //Shiny new way of calculating proper trajectory of dart towards player :]
    //this.pos.x-=cos(atan2(this.pos.y-player.pos.y,this.pos.x-player.pos.x))*teemoMS;  <---Old, inefficient way of doing it :[
    //this.pos.y-=sin(atan2(this.pos.y-player.pos.y,this.pos.x-player.pos.x))*teemoMS;  <---|
  }
  void update(){  //Move the dart in accordance with its momentum
    this.alive = !(this.pos.x<0 || this.pos.x > width || this.pos.y < 0 || this.pos.y > height);
    if(this.alive){
      this.pos.x -= this.mom.x;
      this.pos.y -= this.mom.y;
    }
  }
  void show(){  //Show the dart
    tint(255,255,255);
    image(dartTex,this.pos.x,this.pos.y);
  }
}
class shroom{  //Mushroom trap class
  PVector pos = new PVector(-1000,-1000);
  void show(){
    tint(255,255,255);
    image(shroom,this.pos.x,this.pos.y);
  }
}
class poison{  //Player poison trail class
  PVector pos = new PVector(0,0);
  PVector cloudMom = new PVector(0,0);
  int life = 255;
  void update(){
    this.pos.x+=cloudMom.x;
    this.pos.y+=cloudMom.y;
  }
  void show(){
    noStroke();
    if(life>0){
      life--;
    }
    switch(chosenSkin){ //Special poison colors dependent upon skin used
      case 4:
        fill(255,243,0,map(life,0,poisonParts/poisonDensity,0,255));
        break;
      case 5:
        fill(255,255,255,map(life,0,poisonParts/poisonDensity,0,255));
        break;
      default:
        fill(0,255,0,map(life,0,poisonParts/poisonDensity,0,255));
        break;
    }
    ellipse(this.pos.x,this.pos.y,10,10);
  }
}
class pc{  //The player character class. Right now there are only two objects of this type, but if I ever want to make a multiplayer version then it'd be easy.
  PVector pos = new PVector(width/2, height);
  float health = 150;  //Tip: don't let this equal zero
  float poisonTimer = 0;  //Checks duration left on poison
  boolean isPoisoned = false;  //Used only for if this pc is an enemy
  boolean isEnemy = false;
  boolean alive = true;
  int invulnTimer = 0;  //You're welcome
  //<Player movement directions>
  boolean l = false;
  boolean r = false;
  boolean u = false;
  boolean d = false;
  //<Player movement directions>
  void update(){  //Oh boy this is a big one
    if(this.alive){
      invulnTimer++;
      if(this.health<=0){
        this.alive = false;
      }
      //<Movement things with menu slider values accounted for>
      if(this.l){
        this.pos.x-=settingsMenuE.sliders[2].sliderVal;  //Maybe assign this to a temporary variable so that I don't have to keep referring back and grabbing the value by index
      }
      if(this.r){
        this.pos.x+=settingsMenuE.sliders[2].sliderVal;
      }
      if(this.u){
        this.pos.y-=settingsMenuE.sliders[2].sliderVal;
      }
      if(this.d){
        this.pos.y+=settingsMenuE.sliders[2].sliderVal;
      }
      //</Movement things with menu slider values accounted for>
      if(this.pos.x+img.width>width){  //No moving outside of the screen
        this.r = false;
      }
      if(this.pos.x<0){
        this.l = false;
      }
      if(this.pos.y<0){
        this.u = false;
      }
      if(this.pos.y+img.height>height){
        this.d = false;
      }
      if(isEnemy){
        float tLowX = enemyPC.pos.x+enemy.width*0.1;  //Hitbox adjustment to account for possibly-deceptive images for the characters
        float tHighX = enemyPC.pos.x+enemy.width*0.55;
        for(int i=0; i<poisonCloud.length; i++){  //Poison Cloud Collision
          if(poisonCloud[i].pos.x>tLowX && poisonCloud[i].pos.x<tHighX && poisonCloud[i].pos.y>this.pos.y && poisonCloud[i].pos.y<this.pos.y+enemy.height && this.invulnTimer > 100){
            this.isPoisoned = true;
            this.poisonTimer = 0;
          }
        }
        if(this.isPoisoned){  //Poison ticks
          this.health-= 0.1;
          this.poisonTimer++;
        }
        if(this.poisonTimer>100){  //Poison wears off after 100 frames
          this.isPoisoned = false;
        }
        this.pos.x-=cos(atan2(this.pos.y-player.pos.y,this.pos.x-player.pos.x))*settingsMenuE.sliders[1].sliderVal;  //Teemo's chase code, hooray trigonometry
        this.pos.y-=sin(atan2(this.pos.y-player.pos.y,this.pos.x-player.pos.x))*settingsMenuE.sliders[1].sliderVal;  //Teemo's chase code, hooray trigonometry
      }
    }
    if(!isEnemy){
      float lowX = this.pos.x+img.width*0.2; //Hitbox adjustment to account for possibly-deceptive images for the characters
      float highX = this.pos.x+img.width*0.7;
      int dartlen = darts.length;
      float dartTexW = dartTex.width;
      float dartTexH = dartTex.height;
      for(int k=0; k<dartlen; k++){  //Check each point on the texture of each dart to see if it is within the player's model. This might be replaceable with a dist() to be a bit faster.
        for(int i=0; i<dartTexW; i++){
          for(int j=0; j<dartTexH; j++){
             if(darts[k].pos.x+i>lowX && darts[k].pos.x+1<highX && darts[k].pos.y+j>this.pos.y && darts[k].pos.y+j<this.pos.y+img.height && darts[k].alive){  //Hit detection
              this.health-=1;
              darts[k].alive = false;
              darts[k].pos = new PVector(-1000,-1000);  //Move it off screen because it doesn't exist if you can't see it ;]
              oof.play();
            }
          }
        }
      }
      for(int i=0; i<enemy.width*0.55; i++){  //Same there here, but enemy collision.
        for(int j=0; j<enemy.height; j++){
          if(enemyPC.pos.x+enemy.width*0.1+i>lowX && enemyPC.pos.x+enemy.width*0.1+i<highX && enemyPC.pos.y+j>this.pos.y && enemyPC.pos.y+j<this.pos.y+img.height && this.invulnTimer > 100 && enemyPC.alive){
            this.health-=1;
            this.invulnTimer=0;
            oof.play();
          }
        }
      }
      int mushLen = mushrooms.length;
      int shroomW = shroom.width;
      int shroomH = shroom.height;
      for(int k=0; k<mushLen; k++){ //Mushroom collision
        for(int i=0; i<shroomW; i++){
          for(int j=0; j<shroomH; j++){
            if(mushrooms[k].pos.x+i>lowX && mushrooms[k].pos.x+1<highX && mushrooms[k].pos.y+j>this.pos.y && mushrooms[k].pos.y+j<this.pos.y+img.height){
              this.health-=1;
              mushrooms[k].pos = new PVector(-1000,-1000);
              oof.play();
            }
          }
        }
      }
    }
  }
  void shroom(){  //Enemy function to place a mushroom trap
    if(this.alive){
      PVector temp = new PVector(this.pos.x+enemy.width/2+random(-settingsMenuE.sliders[0].sliderVal,settingsMenuE.sliders[0].sliderVal),this.pos.y+enemy.height/2+random(-settingsMenuE.sliders[0].sliderVal,settingsMenuE.sliders[0].sliderVal)); //Temp value for the mushroom position
      if(shroomNumber<mushrooms.length){
        mushrooms[shroomNumber].pos = new PVector(temp.x,temp.y);
        shroomNumber++;
      }else{
        shroomNumber = 0;
        mushrooms[shroomNumber].pos = new PVector(temp.x,temp.y);
      }
      tLaugh.play();
    }
  }
  void dart(){
    if(this.alive){
      if(dartNumber<darts.length){
        darts[dartNumber].pos = new PVector(this.pos.x,this.pos.y);
        darts[dartNumber].alive = true;
        darts[dartNumber].angle = atan2(this.pos.y-player.pos.y,this.pos.x-player.pos.x);
        PVector tempPPos = new PVector(player.pos.x, player.pos.y);
        if(player.r){  //Is this AI?
          tempPPos.x += teemoAimCompens;
        }
        if(player.l){ //Is this AI?
          tempPPos.x -= teemoAimCompens;
        }
        if(player.u){ //Is this AI?
          tempPPos.y -= teemoAimCompens;
        }
        if(player.d){ //Is this AI?
          tempPPos.y += teemoAimCompens;
        }
        //No that's not AI
        darts[dartNumber].setMom(new PVector(this.pos.x,this.pos.y),tempPPos);
        dartNumber++;
      }else{
        dartNumber = 0;
      }
    }
  }
  void poison(){  //Place down that poison (For the player only)
    PVector temp = new PVector(this.pos.x+img.width+random(0,15)-15,this.pos.y+10);
    for(int i=0; i<poisonDensity; i++){  //Higher poison density = more poison particles spawned per frame = denser-looking cloud
      poisonCloud[poisonCounter+i].pos = new PVector(temp.x,temp.y);
      poisonCloud[poisonCounter+i].life = poisonParts/poisonDensity;  //Has to do with the visual fade out effect on the poison
    }
  }
  void show(){  //Show the pc
    if(this.isEnemy && this.alive){
      if(this.isPoisoned){
        tint(0,200,0);  //"You're looking a little green!"
      }else{
        tint(255,255,255);  //Wow looking healthy
      }
      image(enemy,enemyPC.pos.x,enemyPC.pos.y);
    }else{
      switch(chosenSkin){  //Change which image is used dependent upon which skin is selected. All hail switch-case for making this not take an unreasonable number of lines!
        case 0:
          tint(255,255,255);
          image(img,player.pos.x,player.pos.y);
          break;
        case 1:
          tint(255,255,255);
          image(hTSinged,player.pos.x,player.pos.y);
          break;
        case 2:
          tint(255,255,255);
          image(bsPC,player.pos.x,player.pos.y);
          break;
        case 3:
          tint(255,255,255);
          image(sswPC,player.pos.x,player.pos.y);
          break;
        case 4:
          tint(255,255,255);
          image(beePC,player.pos.x,player.pos.y);
          break;
        case 5:
          tint(255,255,255);
          image(snoPC,player.pos.x,player.pos.y);
          break;
        case 6:
          tint(255,255,255);
          image(mscPC,player.pos.x,player.pos.y);
          break;
        case 7:
          tint(255,255,255);
          image(surPC,player.pos.x,player.pos.y);
          break;
        case 8:
          tint(255,255,255);
          image(augPC,player.pos.x,player.pos.y);
          break;
        default:
          tint(255,255,255);
          image(img,player.pos.x,player.pos.y);
          break;
      }
    }
  }
}
shroom[] mushrooms = new shroom[100];
projectile[] darts = new projectile[100];
poison[] poisonCloud = new poison[poisonParts];
pc enemyPC = new pc();
pc player = new pc();
//<Graphics and audio declaration>
PImage skinMenuBG;
PImage diffSetBG;
PImage beeSplash;
PImage bsSplash;
PImage sswSplash;
PImage snoSplash;
PImage mscSplash;
PImage surSplash;
PImage augSplash;
PImage riotSplash;
PImage img;
PImage Singed;
PImage hTSinged;
PImage bsPC;
PImage sswPC;
PImage beePC;
PImage snoPC;
PImage mscPC;
PImage surPC;
PImage augPC;
PImage htSingedSplash;
PImage shroom;
PImage enemy;
PImage menuBG;
PImage dartTex;
PImage youLose;
PImage youWin;
PImage playingBG;
SoundFile scrapes;
SoundFile oof;
String oofFName = "rscs/oof.mp3";
String oofPath;
String scrapesFName = "rscs/realmusic.mp3";
String scrapesPath;
SoundFile tLaugh;
String tLaughFName = "rscs/teemoLaugh.mp3";
String tLaughPath;
//</Graphics and audio declaration>
boolean gameOver; // OnO
void setup(){
  initializeMenus();
  textFont(cS);
  oofPath = sketchPath(oofFName);
  oof = new SoundFile(this,oofPath);
  scrapesPath = sketchPath(scrapesFName);
  scrapes = new SoundFile(this,scrapesPath);
  tLaughPath = sketchPath(tLaughFName);
  tLaugh = new SoundFile(this,tLaughPath);
  oof.amp(2);
  scrapes.amp(0);
  tLaugh.amp(0.4);
  scrapes.play();
  scrapes.stop();
  scrapes.loop();
  for(int i=0; i<mushrooms.length; i++){  //Initialize them boys
    mushrooms[i] = new shroom();
  }
  player.health = settingsMenuE.sliders[4].sliderVal;
  for(int i=0; i<darts.length; i++){  //Initialize them boys
    darts[i] = new projectile();
  }
  for(int i=0; i<poisonCloud.length; i++){ //Initialize them boys
    poisonCloud[i] = new poison();
    poisonCloud[i].cloudMom = new PVector(random(-0.5,0.5),random(-0.5,0.5));
    poisonCloud[i].pos = new PVector(-1000,-1000);
  }
  enemyPC.isEnemy = true;
  size(1000,1000);
  //<Graphics and Audio loading>
  playingBG = loadImage("rscs/map.png");
  playingBG.resize(1000,1000);
  youLose = loadImage("rscs/youLose.png");
  youLose.resize(1000,400);
  youWin = loadImage("rscs/youWin.png");
  youWin.resize(1000,400);
  menuBG = loadImage("rscs/menuBG.png");
  menuBG.resize(1000,1000);
  shroom = loadImage("rscs/shroom.png");
  shroom.resize(60,60);
  hTSinged = loadImage("rscs/hT.PNG");
  hTSinged.resize(100,150);
  img = loadImage("rscs/sing.png");
  img.resize(100,150);
  bsPC = loadImage("rscs/bsPC.png");
  bsPC.resize(100,150);
  sswPC = loadImage("rscs/sswPC.png");
  sswPC.resize(100,150);
  beePC = loadImage("rscs/beePC.png");
  beePC.resize(100,150);
  snoPC = loadImage("rscs/snoPC.png");
  snoPC.resize(100,150);
  mscPC = loadImage("rscs/mscPC.png");
  mscPC.resize(100,150);
  surPC = loadImage("rscs/surPC.png");
  surPC.resize(100,150);
  augPC = loadImage("rscs/augPC.png");
  augPC.resize(100,150);
  skinMenuBG = loadImage("rscs/noxus.png");
  skinMenuBG.resize(1778,1000);
  diffSetBG = loadImage("rscs/diffSetBG.png");
  diffSetBG.resize(1962,1200);
  Singed = loadImage("rscs/SingedSplash.jpg");
  bsSplash = loadImage("rscs/bsSplash.jpg");
  htSingedSplash = loadImage("rscs/hTSplash.jpg");
  sswSplash = loadImage("rscs/sswSplash.jpg");
  beeSplash = loadImage("rscs/beeSplash.png");
  snoSplash = loadImage("rscs/snoSplash.jpg");
  mscSplash = loadImage("rscs/mscSplash.png");
  surSplash = loadImage("rscs/surSplash.png");
  augSplash = loadImage("rscs/augSplash.jpg");
  riotSplash = loadImage("rscs/riotsquad.png");
  dartTex = loadImage("rscs/dart.png");
  dartTex.resize(25,25);
  enemy = loadImage("rscs/enemy.png");
  enemy.resize(100,100);
  //</Graphics and Audio loading>
  player.pos = new PVector(width/2,height-img.height);
}
void draw(){  //Do this 60 times per second
  if(mainMenu){  //About the menus, it would probably have been much more robust and elegant to put them all into an array then just index them, but this will work for now. Do it the array way next time though
    background(255);
    tint(255,255,255,255);
    image(menuBG,0,0);
    mainMenuE.display();
  }else if(gameRunning){  //The actual game
    endMenu = !enemyPC.alive || !player.alive;
    if(shroomCounter<settingsMenuE.sliders[3].sliderVal){
      shroomCounter++;
    }else{
      enemyPC.shroom();
      shroomCounter = 0;
    }
    if(useDarts){
      if(dartCounter<settingsMenuE.sliders[6].sliderVal){
        dartCounter++;
      }else{
        enemyPC.dart();
        dartCounter = 0;
      }
    }
    player.poison();
    if(poisonCounter>=poisonCloud.length-poisonDensity){
      poisonCounter=0;
    }else{
      poisonCounter+=poisonDensity;
    }
    background(255);
    image(playingBG,0,0);
    player.update();
    enemyPC.update();
    enemyPC.show();
    for(int i=0; i<poisonCloud.length; i++){  //Poison upkeep
      poisonCloud[i].update();
      poisonCloud[i].show();
      fill(0,255,0);
    }
    for(int i=0; i<darts.length; i++){  //Dart upkeep
      if(darts[i].alive){
        darts[i].update();
        darts[i].show();
      }
    }
    for(int i=0; i<mushrooms.length; i++){  //Mushroom show
      mushrooms[i].show();
    }
    player.show();
    textSize(30);
    fill(100,255,0);
    textAlign(LEFT);
    text("Life: ",0,30);
    text((int)player.health,20,60);
    if(player.health<=0){
      lost = true;
    }else if(enemyPC.health<=0){
      won = true;
    }
  }else if(settingsMenu){
    image(diffSetBG,0,0);
    settingsMenuE.display();
  }else if(creditsMenu){
    textAlign(CENTER);
    background(0);
    fill(255,0,255);
    textSize(14);
    text("Created by Aaron 'On All Twos' Willis; 17 y/o and self-taught at coding", width/2, 100);
    text("No game engine or borrowed code used, completely hand-written in Processing (a form of Java)", width/2,200);
    text("No UI elements were imported. ALL buttons, sliders, menus, and game mechanics are entirely original code.", width/2,300);
    text("Coded over the course of approximately 20 hours across a few weeks", width/2,400);
    text("Please give me Riot Squad Singed, I feel incomplete without him :[",width/2,500);
    text("This application's source code is included in this file under the /source folder",width/2,700);
    text("<3",width/2,800);
    text("-On All Twos",width/2,900);
    text("No art, music, or sound used in this game belongs to me. My intellectual property claims lie solely in the game mechanics and code.",width/2,1000);
    fill(255,255,255);
    textAlign(LEFT);
    creditsMenuE.display();
  }else if(skinsMenu){
    image(skinMenuBG,width/2-skinMenuBG.width/2,0);
    skinsMenuE.display();
    switch(round(skinsMenuE.sliders[0].sliderVal)){
      case 0:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(Singed);
        break;
      case 1:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(htSingedSplash);
        break;
      case 2:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(bsSplash);
        break;
      case 3:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(sswSplash);
        break;
      case 4:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(beeSplash);
        break;
      case 5:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(snoSplash);
        break;
      case 6:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(mscSplash);
        break;
      case 7:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(surSplash);
        break;
      case 8:
        makeDeal = false;
        skinsMenuE.buttons[1].setImage(augSplash);
        break;
      case 9:
        skinsMenuE.buttons[1].setImage(riotSplash);
        break;
    }
    if(makeDeal){  //Gotta guilt trip them, gotta get that sweet virtual skin
      textAlign(CENTER);
      textSize(20);
      text("Oh No, it's locked!",width/2,height*0.55);
      text("Look at him, struggling to break free! How sad!",width/2,height*0.6);
      text("But YOU can save him!",width/2,height*0.65);
      text("Unlock him on my league account, and only then can I unlock him on here.",width/2,height*0.7);
      text("Seems like an easy decision to me!",width/2,height*0.75);
    }
  }if(endMenu){
    tint(255,255,255);
    if(endRotation<360){
      endRotation+=2;
    }else{
      endRotation=0;
    }
    pushMatrix();
    if(lost){  //Omegalul
      translate(width/2,youLose.height/2);
      rotate(radians(endRotation));
      image(youLose,-width/2,-youLose.height/2);
    }else{  //POGGERS
      translate(width/2,youWin.height/2);
      rotate(radians(endRotation));
      image(youWin,-width/2,-youLose.height/2);
    }
    popMatrix();
    endMenuE.display();
  }
}
void mouseDragged(){ //Aaaaaaaa this is why we use arrays for menuuuuuuus
  int slidelen = mainMenuE.sliders.length;
  for(int i=0; i<slidelen; i++){
    if((mouseX>mainMenuE.sliders[i].pos.x  && mouseX<mainMenuE.sliders[i].pos.x+mainMenuE.sliders[i].len && mouseY>mainMenuE.sliders[i].pos.y && mouseY<mainMenuE.sliders[i].pos.y+10)||(mainMenuE.sliders[i].sliderPos >= 0 && mainMenuE.sliders[i].sliding && mainMenuE.sliders[i].sliderPos<=mainMenuE.sliders[i].len)){
      mainMenuE.sliders[i].sliderPos = mouseX-mainMenuE.sliders[i].pos.x;
      if(mainMenuE.sliders[i].sliderPos<0){
        mainMenuE.sliders[i].sliderPos=0;
      }
      if(mainMenuE.sliders[i].sliderPos>mainMenuE.sliders[i].len){
        mainMenuE.sliders[i].sliderPos=mainMenuE.sliders[i].len;
      }
      mainMenuE.sliders[i].sliding = true;
    }
  }
  slidelen = settingsMenuE.sliders.length;
  for(int i=0; i<slidelen; i++){
    if((mouseX>settingsMenuE.sliders[i].pos.x  && mouseX<settingsMenuE.sliders[i].pos.x+settingsMenuE.sliders[i].len && mouseY>settingsMenuE.sliders[i].pos.y && mouseY<settingsMenuE.sliders[i].pos.y+10)||(settingsMenuE.sliders[i].sliderPos >= 0 && settingsMenuE.sliders[i].sliding && settingsMenuE.sliders[i].sliderPos<=settingsMenuE.sliders[i].len)){
      settingsMenuE.sliders[i].sliderPos = mouseX-settingsMenuE.sliders[i].pos.x;
      if(settingsMenuE.sliders[i].sliderPos<0){
        settingsMenuE.sliders[i].sliderPos=0;
      }
      if(settingsMenuE.sliders[i].sliderPos>settingsMenuE.sliders[i].len){
        settingsMenuE.sliders[i].sliderPos=settingsMenuE.sliders[i].len;
      }
      settingsMenuE.sliders[i].sliding = true;
    }
  }
  slidelen = skinsMenuE.sliders.length;
  for(int i=0; i<slidelen; i++){
    if((mouseX>skinsMenuE.sliders[i].pos.x  && mouseX<skinsMenuE.sliders[i].pos.x+skinsMenuE.sliders[i].len && mouseY>skinsMenuE.sliders[i].pos.y && mouseY<skinsMenuE.sliders[i].pos.y+10)||(skinsMenuE.sliders[i].sliderPos >= 0 && skinsMenuE.sliders[i].sliding && skinsMenuE.sliders[i].sliderPos<=skinsMenuE.sliders[i].len)){
      skinsMenuE.sliders[i].sliderPos = mouseX-skinsMenuE.sliders[i].pos.x;
      if(skinsMenuE.sliders[i].sliderPos<0){
        skinsMenuE.sliders[i].sliderPos=0;
      }
      if(skinsMenuE.sliders[i].sliderPos>skinsMenuE.sliders[i].len){
        skinsMenuE.sliders[i].sliderPos=skinsMenuE.sliders[i].len;
      }
      skinsMenuE.sliders[i].sliding = true;
    }
  }
}

void mouseReleased(){
  int slidelen = mainMenuE.sliders.length;
  for(int i=0; i<slidelen; i++){
    mainMenuE.sliders[i].sliding = false;
  }
  slidelen = settingsMenuE.sliders.length;
  for(int i=0; i<slidelen; i++){
    settingsMenuE.sliders[i].sliding = false;
  }
  slidelen = skinsMenuE.sliders.length;
  for(int i=0; i<slidelen; i++){
    skinsMenuE.sliders[i].sliding = false;
  }
}
void mousePressed(){ //This is also why we use arrays for menus!
  if(mainMenu){
    int buttlen = mainMenuE.buttons.length;
    for(int i=0; i<buttlen; i++){
      if(mouseX>mainMenuE.buttons[i].pos.x  && mouseX<mainMenuE.buttons[i].pos.x+mainMenuE.buttons[i].size.x && mouseY>mainMenuE.buttons[i].pos.y && mouseY<mainMenuE.buttons[i].pos.y+mainMenuE.buttons[i].size.y){
        buttonFunctions(i);
      }
    }
  }
  if(settingsMenu){
    int buttlen = settingsMenuE.buttons.length;
    for(int i=0; i<buttlen; i++){
      if(mouseX>settingsMenuE.buttons[i].pos.x  && mouseX<settingsMenuE.buttons[i].pos.x+settingsMenuE.buttons[i].size.x && mouseY>settingsMenuE.buttons[i].pos.y && mouseY<settingsMenuE.buttons[i].pos.y+settingsMenuE.buttons[i].size.y){
        buttonFunctions(i);
      } 
    }
  }
  if(skinsMenu){
    int buttlen = skinsMenuE.buttons.length;
    for(int i=0; i<buttlen; i++){
      if(mouseX>skinsMenuE.buttons[i].pos.x  && mouseX<skinsMenuE.buttons[i].pos.x+skinsMenuE.buttons[i].size.x && mouseY>skinsMenuE.buttons[i].pos.y && mouseY<skinsMenuE.buttons[i].pos.y+skinsMenuE.buttons[i].size.y){
        buttonFunctions(i);
      } 
    }
  }
  if(endMenu){
    int buttlen = endMenuE.buttons.length;
    for(int i=0; i<buttlen; i++){
      if(mouseX>endMenuE.buttons[i].pos.x  && mouseX<endMenuE.buttons[i].pos.x+endMenuE.buttons[i].size.x && mouseY>endMenuE.buttons[i].pos.y && mouseY<endMenuE.buttons[i].pos.y+endMenuE.buttons[i].size.y){
        buttonFunctions(i);
      } 
    }
  }
  if(creditsMenu){
    int buttlen = creditsMenuE.buttons.length;
    for(int i=0; i<buttlen; i++){
      if(mouseX>creditsMenuE.buttons[i].pos.x  && mouseX<creditsMenuE.buttons[i].pos.x+creditsMenuE.buttons[i].size.x && mouseY>creditsMenuE.buttons[i].pos.y && mouseY<creditsMenuE.buttons[i].pos.y+creditsMenuE.buttons[i].size.y){
        buttonFunctions(i);
      }
    }
  }
}
void keyPressed(){ //Player controls
  switch(key){
    case 'd':
    if(player.pos.x+5+img.width<width){
      player.r = true;
    }
      break;
    case 'a':
    if(player.pos.x-5>0){
      player.l = true;
    }
      break;
    case 'w':
    if(player.pos.y-5>0){
      player.u = true;
    }
      break;
    case 's':
    if(player.pos.y+5+img.height<height){
      player.d = true;
    }
      break;
  }
}

void keyReleased(){ //Also player controls
  switch(key){
    case 'd':
      player.r = false;
      break;
    case 'a':
      player.l = false;
      break;
    case 'w':
      player.u = false;
      break;
    case 's':
      player.d = false;
      break;
  }
}
