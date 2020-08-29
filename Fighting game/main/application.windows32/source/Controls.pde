void keyReleased(){          //Key released + key pressed allows for multiple buttons to be used at the same time.
    if(key == 'a' || key == 'A'){
      test.movingR = false;
    }
    if(key == 'd' || key == 'D'){
      test.movingL = false;
    }
    if(key == 'w' || key == 'W'){
      test.slowFalling = false;
    }
    if(key == 's' || key == 'S'){
      test.fastFalling = false;
    }
}
void keyPressed(){
    if(keyCode == LEFT && test.onGround){
      test.use(jabr);
    }
    if(key == 'w' || key == 'W'){
      test.slowFalling = true;
      test.idleFalling = false;
      if(!test.onGround) test.use(slowfall);
    }
    if(key == ' '){
      test.jump();
    }
    if(key == 'a' || key == 'A'){
      test.movingR = true;
      if(!test.moveProg && test.onGround) test.use(walkR);
    }
    if(key == 'd' || key == 'D'){
      test.movingL = true;
      if(!test.moveProg && test.onGround) test.use(walkL);
    }
    if(key == 's' || key == 'S'){
      test.fastFalling = true;
    }
}