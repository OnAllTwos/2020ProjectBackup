//Oh man this is old and not very good... I wasn't very sure how I would go about implementing
//hitboxes and stuff back when I made this, so I didn't really get anywhere with this in particular
//and decided instead to do something simpler first.
Tile[] Tiles;
class Tile{
  boolean overTile;
  int xPos=0;
  int yPos=0;
  int size= 200;
}
class Roomba{
  int xPos=0;
  int yPos=0;
  int knifePos=0;
}
class Knife{
  int xPos=0;
  int yPos=0;
}
  Roomba roomba1=new Roomba();
  Roomba roomba2=new Roomba();
  Knife knife1=new Knife();
  Knife knife2=new Knife();
void setup(){
  size(900,900);
 //<Grid generation>
  Tiles=new Tile[100];
  for(int i=0;i<10;i++){
    Tiles[i]=new Tile();
    Tiles[i].xPos=i*100;
  }
  for(int i=0;i<10;i++){
    int modi=i+10;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=100;
  }
    for(int i=0;i<10;i++){
    int modi=i+20;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=200;
  }
    for(int i=0;i<10;i++){
    int modi=i+30;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=300;
  }
    for(int i=0;i<10;i++){
    int modi=i+40;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=400;
  }
    for(int i=0;i<10;i++){
    int modi=i+50;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=500;
  }
    for(int i=0;i<10;i++){
    int modi=i+60;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=600;
  }
    for(int i=0;i<10;i++){
    int modi=i+70;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=700;
  }
    for(int i=0;i<10;i++){
    int modi=i+80;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=800;
  }
    for(int i=0;i<10;i++){
    int modi=i+90;
    Tiles[modi]=new Tile();
    Tiles[modi].xPos=i*100;
    Tiles[modi].yPos=900;
  }
  //</Grid generation>
  roomba1.xPos=Tiles[48].xPos;
  roomba1.yPos=Tiles[48].yPos+50;
}

void draw(){
  knife1.xPos=roomba1.xPos+10;
  knife1.yPos=roomba1.yPos-10;
  for(int i=0;i<100;i++){
    rect(Tiles[i].xPos,Tiles[i].yPos,100,100);
  }
  checkmouse();
  ellipse(roomba1.xPos+50,roomba1.yPos,50,50);
  rect(knife1.xPos,knife1.yPos,40,20);
}
void mousePressed(){
  for(int i=0;i<100;i++){
    if(Tiles[i].overTile==true){
      if(roomba1.xPos==Tiles[i].xPos || roomba1.yPos==Tiles[i].yPos+50){
        roomba1.xPos=Tiles[i].xPos;
        roomba1.yPos=Tiles[i].yPos-50;
        }
      }
     }
  }
void checkmouse(){
  for(int i=0;i<100;i++){
    if (mouseX > Tiles[i].xPos-100 && mouseX < Tiles[i].xPos+100 && mouseY > Tiles[i].yPos-100 && mouseY < Tiles[i].yPos+100){
      Tiles[i].overTile=true;
    }
    else{
      Tiles[i].overTile=false;
    }
  }
}
