import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Hitbox_demo extends PApplet {

hb test = new hb();

public void setup(){
  
}
class hb{
  PVector pos = new PVector(500,250);
  PVector size = new PVector(100,50);
  float angle = 45;
  public void show(){
    pushMatrix();
    translate(this.pos.x,this.pos.y);
    rotate(radians(this.angle));
    rect(0,0,this.size.x,this.size.y);
    popMatrix();
  }
  public boolean checkCollide(PVector point, PVector Psize){
    noStroke();
    fill(255,0,0,128);
    rect(0,0,2,2);
    this.show();
    fill(0,0,255,128);
    rect(0,0,2,2);
    rect(point.x,point.y,Psize.x,Psize.y);
    int expected = get(1,1);
    background(100);
    fill(255,0,0,128);
    this.show();
    fill(0,0,255,128);
    rect(point.x,point.y,Psize.x,Psize.y);
    pushMatrix();
    translate(this.pos.x,this.pos.y);
    rotate(radians(this.angle)); 
    this.angle+=1;
    loadPixels();
    for(int i=0; i<(int)this.size.x; i++){
      for(int j=0; j<(int)this.size.y; j++){
        float newPosX = (int)((this.pos.x+i-this.pos.x)*cos(radians(this.angle))-(this.pos.y+j-this.pos.y)*sin(radians(this.angle))+this.pos.x);
        float newPosY = (int)((this.pos.x+i-this.pos.x)*sin(radians(this.angle))+(this.pos.y+j-this.pos.y)*cos(radians(this.angle))+this.pos.y);
        int test = get((int)newPosX,(int)newPosY);
        fill(test);
        //rect(0,0,10,10);    //This rectangle is for testing the value recieved by the get() function
        if(red(test) == red(expected) && green(test) == green(expected) && blue(test) == blue(expected) && alpha(test) == alpha(expected)){
          popMatrix();
          return true;
        }
      }
    }
    popMatrix();
    text(red(expected)+"/"+green(expected)+"/"+blue(expected)+"/"+alpha(expected),200,200);
    int check = get((int)point.x,(int)point.y);
    //fill(check);
    return false;
  }
}
PVector testPoint = new PVector(510,280);
PVector testSize = new PVector(50,50);
public void draw(){
  background(100);
  //test.show();
  if(test.checkCollide(testPoint,testSize)){
    text("true",400,400);
  }else{
    text("false",400,400);
  }
}
  public void settings() {  size(1000,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Hitbox_demo" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
