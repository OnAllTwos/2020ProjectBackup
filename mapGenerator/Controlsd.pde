void mouseWheel(MouseEvent event){
  float dir = event.getCount();
  if(dir>0){
    cameraZoom-=0.1;
  }else{
    cameraZoom+=0.1;
  }
}

void keyPressed(){
  switch(key){
    case 'w':
    if(cameraOff.y>0){
      cameraOff.y-=tileSize;
    }
      break;
    case 'a':
    if(cameraOff.x>0){
      cameraOff.x-=tileSize;
    }
      break;
    case 's':
    if(cameraOff.y<height){
      cameraOff.y+=tileSize;
    }
      break;
    case 'd':
    if(cameraOff.x<width){
      cameraOff.x+=tileSize;
    }
      break;
    case 'i':
      cameraZoom+=0.1;
      break;
    case 'o':
      cameraZoom-=0.1;
      break;
  }
}
