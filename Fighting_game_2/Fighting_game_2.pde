/*
  Okay this is a VERY AMBITITOUS start. So much of objects pointing to objects and stuff, I hope that I can eventually get all of this to come together.
  The idea is to turn this into a fighting game like Street Fighter, Smash Brothers, Tekken, or the like
  Currently there is a lot of object framework but I'm struggling as to where to actually start going from framework to game.
  Such is the fate of someone with such lofty ambitions, but that's alright :]
*/
Player[] players = new Player[2];
void setup(){
  for(int i=0; i<players.length; i++){
    players[i] = new Player();
  }
  for(int i=0; i<fighters.length; i++){
    fighters[i] = new character();
  }
  loadProto();
  players[0].Char=(character) fighters[0].clone();;
}
void draw(){
  println(players[0].Char.name);
}
