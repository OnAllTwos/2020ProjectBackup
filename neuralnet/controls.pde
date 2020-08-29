void mouseWheel(MouseEvent event){
  int e = event.getCount();
  if(e>0 && scale>0){
    //scale-=0.1;
  }else if(e<0){
    // scale+=0.1;
  }
  println(e + " " + scale);
}
int panX;
int panY;
int clickPosx;
int clickPosy;
void mousePressed(){
  if(!mP){
    //clickPosx = mouseX;
    //clickPosy = mouseY;
  }
  mP = true;
}

void mouseReleased(){
  if(mP){
    //panX += clickPosx-mouseX;
    //panY += clickPosy-mouseY;
  }
  mP = false;
}
