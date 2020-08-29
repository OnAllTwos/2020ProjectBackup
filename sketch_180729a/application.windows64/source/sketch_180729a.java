import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class sketch_180729a extends PApplet {

/* 
This is a League of Legends fan game
Started in August 2018
The only library used here is the sound library,
all of the menu elements are of my own spaghetti'd design
*/
  //So that I can play sound files
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
  public void setMom(PVector source, PVector target){
    this.mom = new PVector(cos(atan2(source.y-target.y,source.x-target.x))*dartMS,sin(atan2(source.y-target.y,source.x-target.x))*dartMS);  //Shiny new way of calculating proper trajectory of dart towards player :]
    //this.pos.x-=cos(atan2(this.pos.y-player.pos.y,this.pos.x-player.pos.x))*teemoMS;  <---Old, inefficient way of doing it :[
    //this.pos.y-=sin(atan2(this.pos.y-player.pos.y,this.pos.x-player.pos.x))*teemoMS;  <---|
  }
  public void update(){  //Move the dart in accordance with its momentum
    this.alive = !(this.pos.x<0 || this.pos.x > width || this.pos.y < 0 || this.pos.y > height);
    if(this.alive){
      this.pos.x -= this.mom.x;
      this.pos.y -= this.mom.y;
    }
  }
  public void show(){  //Show the dart
    tint(255,255,255);
    image(dartTex,this.pos.x,this.pos.y);
  }
}
class shroom{  //Mushroom trap class
  PVector pos = new PVector(-1000,-1000);
  public void show(){
    tint(255,255,255);
    image(shroom,this.pos.x,this.pos.y);
  }
}
class poison{  //Player poison trail class
  PVector pos = new PVector(0,0);
  PVector cloudMom = new PVector(0,0);
  int life = 255;
  public void update(){
    this.pos.x+=cloudMom.x;
    this.pos.y+=cloudMom.y;
  }
  public void show(){
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
  public void update(){  //Oh boy this is a big one
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
        float tLowX = enemyPC.pos.x+enemy.width*0.1f;  //Hitbox adjustment to account for possibly-deceptive images for the characters
        float tHighX = enemyPC.pos.x+enemy.width*0.55f;
        for(int i=0; i<poisonCloud.length; i++){  //Poison Cloud Collision
          if(poisonCloud[i].pos.x>tLowX && poisonCloud[i].pos.x<tHighX && poisonCloud[i].pos.y>this.pos.y && poisonCloud[i].pos.y<this.pos.y+enemy.height && this.invulnTimer > 100){
            this.isPoisoned = true;
            this.poisonTimer = 0;
          }
        }
        if(this.isPoisoned){  //Poison ticks
          this.health-= 0.1f;
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
      float lowX = this.pos.x+img.width*0.2f; //Hitbox adjustment to account for possibly-deceptive images for the characters
      float highX = this.pos.x+img.width*0.7f;
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
      for(int i=0; i<enemy.width*0.55f; i++){  //Same there here, but enemy collision.
        for(int j=0; j<enemy.height; j++){
          if(enemyPC.pos.x+enemy.width*0.1f+i>lowX && enemyPC.pos.x+enemy.width*0.1f+i<highX && enemyPC.pos.y+j>this.pos.y && enemyPC.pos.y+j<this.pos.y+img.height && this.invulnTimer > 100 && enemyPC.alive){
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
  public void shroom(){  //Enemy function to place a mushroom trap
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
  public void dart(){
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
  public void poison(){  //Place down that poison (For the player only)
    PVector temp = new PVector(this.pos.x+img.width+random(0,15)-15,this.pos.y+10);
    for(int i=0; i<poisonDensity; i++){  //Higher poison density = more poison particles spawned per frame = denser-looking cloud
      poisonCloud[poisonCounter+i].pos = new PVector(temp.x,temp.y);
      poisonCloud[poisonCounter+i].life = poisonParts/poisonDensity;  //Has to do with the visual fade out effect on the poison
    }
  }
  public void show(){  //Show the pc
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
public void setup(){
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
  tLaugh.amp(0.4f);
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
    poisonCloud[i].cloudMom = new PVector(random(-0.5f,0.5f),random(-0.5f,0.5f));
    poisonCloud[i].pos = new PVector(-1000,-1000);
  }
  enemyPC.isEnemy = true;
  
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
public void draw(){  //Do this 60 times per second
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
      text("Oh No, it's locked!",width/2,height*0.55f);
      text("Look at him, struggling to break free! How sad!",width/2,height*0.6f);
      text("But YOU can save him!",width/2,height*0.65f);
      text("Unlock him on my league account, and only then can I unlock him on here.",width/2,height*0.7f);
      text("Seems like an easy decision to me!",width/2,height*0.75f);
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
public void mouseDragged(){ //Aaaaaaaa this is why we use arrays for menuuuuuuus
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

public void mouseReleased(){
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
public void mousePressed(){ //This is also why we use arrays for menus!
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
public void keyPressed(){ //Player controls
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

public void keyReleased(){ //Also player controls
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
class menu{  //Menu class!
  button[] buttons;
  slider[] sliders;
  public void display(){
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
  int textColor = color(0,0,0);
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
  public void getSliderVal(){  //Used to make sure all values are set to their defaults without ever needing to open the settings menu
    sliderVal = map(sliderPos,0,len,mapMin,mapMax);
  }
  public void show(){  //You know how it be
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
  int selectColor = color(0,200,0);
  int textColor = color(10,10,10);
  int rectColor = color(255,255,255,200);
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
  button(String text_,float posX_, float posY_, float sizeX_, float sizeY_, int textColor_, int rectColor_){  //Colorful buttons
    this.text = text_;
    this.pos = new PVector(posX_,posY_);
    this.size = new PVector(sizeX_,sizeY_);
    this.textColor = textColor_;
    this.rectColor = rectColor_;
  }
  public void setImage(PImage image){
    this.buttonImg = image;
    buttonImg.resize((int)this.size.x,(int)this.size.y);
  }
  public void setImage(String path){
    this.buttonImg = loadImage(path);
    buttonImg.resize((int)this.size.x,(int)this.size.y);
  }
  public void show(){
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
public void initializeMenus(){
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
  endMenuE.buttons[0] = new button("Play again",(width-400)/2,height*0.4f,400,100);
  endMenuE.buttons[0].rectColor = color(0,255,0,200);
  endMenuE.buttons[1] = new button("Main Menu",(width-400)/2,height*0.4f+100,400,100);
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
public void buttonFunctions(int id){  //Function called by mousePressed to perform the actions assigned to each button. The "id" value is the array position for the button in a menu.
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

public void refreshGame(){  //Resets most values to their defaults, essentially resetting the game
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
  public void settings() {  size(1000,1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "sketch_180729a" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
