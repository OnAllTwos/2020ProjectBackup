class move{
  float angle;
  int startUp;  //How many frames to active?
  boolean instantCancel;
  int animationStages = 30;
  int hBnum;
  PVector active; //x=first frame, y=last frame
  int[] hBFrames = new int[hBnum]; //Time between each hitbox
  int recovery;  //Frames to standing
  int ID;
  float[][] animation = new float[100][10];  //First element = Which set of positions, second element = which part to position, value of element = position
  hitBox[] hitboxes = new hitBox[hBnum];
  float[] go(int phase, player player){
    return animation[phase];
  }
}

class hitBox{      //BIG work in progress!
  PVector pos;
  PVector size;
  float angle;
  boolean attached = true;
  int bone = 0;  //Limb to which to attach the hitbox
  int hitAngle;
  int damage;
  void show(player parent){
    pushMatrix();
    if(this.attached){
      translate(parent.limbs[bone].pos.x,parent.limbs[bone].pos.y);
    }else{
      translate(this.pos.x,this.pos.y);
    } 
    rotate(radians(this.angle));
    rect(0,0,this.size.x,this.size.y);
    popMatrix();
  }
  boolean checkCollide(player parent, player player){ //This player is that player which might be hit
    noStroke();
    fill(parent.hitBoxColor);          //Overlapping colors used for hit detection!
    rect(0,0,2,2);                     //This area in the code makes a small sample of what overlapping hurtboxes and hitboxes would look like
    this.show(parent);
    fill(player.hurtBoxColor);
    rect(0,0,2,2);
    player.renderHurtbox();
    color expected = get(1,1);         
    background(100);
    fill(player.hitBoxColor);
    this.show(parent);
    fill(0,0,255,128);
    player.renderHurtbox();
    pushMatrix();
    translate(this.pos.x,this.pos.y);
    rotate(radians(this.angle)); 
    loadPixels();
    for(int i=0; i<(int)this.size.x; i++){
      for(int j=0; j<(int)this.size.y; j++){
        float newPosX = (int)((this.pos.x+i-this.pos.x)*cos(radians(this.angle))-(this.pos.y+j-this.pos.y)*sin(radians(this.angle))+this.pos.x);
        float newPosY = (int)((this.pos.x+i-this.pos.x)*sin(radians(this.angle))+(this.pos.y+j-this.pos.y)*cos(radians(this.angle))+this.pos.y);
        color test = get((int)newPosX,(int)newPosY);
        fill(test);
        //rect(0,0,10,10);    //This rectangle is for testing the value recieved by the get() function
        if(red(test) == red(expected) && green(test) == green(expected) && blue(test) == blue(expected) && alpha(test) == alpha(expected)){
          popMatrix();
          background(100);  //Make hitboxes invisible
          return true;
        }
      }
    }
    popMatrix();
    background(100);  //Make hitboxes invisible
    return false;
  }
}