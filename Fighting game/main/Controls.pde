void keyReleased(){          //Key released + key pressed allows for multiple buttons to be used at the same time.
    if(key == 'a' || key == 'A'){
      players[0].movingR = false;
    }
    if(key == 'd' || key == 'D'){
      players[0].movingL = false;
    }
    if(key == 'w' || key == 'W'){
      players[0].slowFalling = false;
    }
    if(key == 's' || key == 'S'){
      players[0].fastFalling = false;
    }
}
void keyPressed(){
    if(keyCode == LEFT && players[0].onGround){
      players[0].use(jabr);
    }
    if(key == 'w' || key == 'W'){
      players[0].slowFalling = true;
      players[0].idleFalling = false;
      if(!players[0].onGround) players[0].use(slowfall);
    }
    if(key == ' '){
      players[0].jump();
    }
    if(key == 'a' || key == 'A'){
      players[0].movingR = true;
      if(!players[0].moveProg && players[0].onGround) players[0].use(walkR);
    }
    if(key == 'd' || key == 'D'){
      players[0].movingL = true;
      if(!players[0].moveProg && players[0].onGround) players[0].use(walkL);
    }
    if(key == 's' || key == 'S'){
      players[0].fastFalling = true;
    }
}