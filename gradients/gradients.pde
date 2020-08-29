//Gradient generator... Not much more to say here! Just thought it'd be neat to see the different ways
//in which I could generate gradients.
color one = color(random(255),random(255),random(255));
color two = color(random(255),random(255),random(255));
color three = color(random(255),random(255),random(255));
color four = color(random(255),random(255),random(255));
float rIv, gIv, bIv, rIv3, gIv3, bIv3, tempRone, tempGone, tempBone, rIv4, gIv4, bIv4, tempRtwo, tempGtwo,tempBtwo;
void setup(){
  size(500,500);
  rIv = ((red(one)-red(two))/width); 
  gIv = ((green(one)-green(two))/width);
  bIv = ((blue(one)-blue(two))/width);
  background(255);
}
void draw(){
  loadPixels();
  rIv = ((red(one)-red(two))/width); 
  gIv = ((green(one)-green(two))/width);
  bIv = ((blue(one)-blue(two))/width);
  for(int j=0; j<width; j++){
    for(int i=0; i<height; i++){
      color temp = color(red(one)-rIv*j, green(one)-gIv*j, blue(one)-bIv*j);
      setColor(j,i,temp);
    }
  }
  if(red(one)!=red(three) || green(one)!=green(three) || blue(one)!=blue(three)){
      tempRone-=rIv3;
      tempGone-=gIv3;
      tempBone-=bIv3;
      one = color(tempRone, tempGone, tempBone);
  }if(abs(red(one)-red(three))<2){
    one = color(red(three),green(one),blue(one));
  }if(abs(green(one)-green(three))<2){
    one = color(red(one),green(three),blue(one));
  }if(abs(blue(one)-blue(three))<2){
    one = color(red(one),green(one),blue(three));
  }if(red(one)==red(three) && green(one)==green(three) && blue(one)==blue(three)){
      three = color(random(255),random(255),random(255));
  }  
  rIv3 = ((red(one)-red(three))/5); 
  gIv3 = ((green(one)-green(three))/5);
  bIv3 = ((blue(one)-blue(three))/5);
  //Gradient for color two
  
  if(red(two)!=red(four) || green(two)!=green(four) || blue(two)!=blue(four)){
      tempRtwo-=rIv4;
      tempGtwo-=gIv4;
      tempBtwo-=bIv4;
      two = color(tempRtwo, tempGtwo, tempBtwo);
  }if(abs(red(two)-red(four))<2){
    two = color(red(four),green(two),blue(two));
  }if(abs(green(two)-green(four))<2){
    two = color(red(two),green(four),blue(two));
  }if(abs(blue(two)-blue(four))<2){
    two = color(red(two),green(two),blue(four));
  }if(red(two)==red(four) && green(two)==green(four) && blue(two)==blue(four)){
      four = color(random(255),random(255),random(255));
  }  
  rIv4 = ((red(two)-red(four))/5); 
  gIv4 = ((green(two)-green(four))/5);
  bIv4 = ((blue(two)-blue(four))/5);
  updatePixels();
}
void setColor(int x, int y, color c){
  pixels[(y*width)+x] = c;
}
