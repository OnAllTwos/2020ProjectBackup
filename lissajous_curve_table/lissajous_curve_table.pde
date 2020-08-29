/*
  Based off of the concept of Lissa Jous Curve Tables
  Well, it's basically a recreation, but it's really cool!
  Also, this version is expandable if you just change the sizes of the two arrays below.
*/
rotator[] rows = new rotator[10];
rotator[] columns = new rotator[15];
class rotator{
  PVector pos;
  float speed=0.01;
  float size=50;
  float rotation;
  PVector point;
  void show(){
    this.rotation+=this.speed;
    ellipse(this.pos.x,this.pos.y,this.size,this.size);
    point = new PVector(this.pos.x+cos(this.rotation)*this.size/2,this.pos.y+sin(this.rotation)*this.size/2);
    ellipse(this.point.x,this.point.y,this.size/5,this.size/5);
  }
}
void setup(){
  size(1920,1080);
  for(int i=0; i<columns.length; i++){
    columns[i] = new rotator();
    columns[i].pos = new PVector(2*columns[i].size+columns[i].size*i*2,columns[i].size);
    if(i!=0){
      columns[i].speed = columns[i-1].speed*1.2;
    }
  }
  for(int i=0; i<rows.length; i++){
    rows[i] = new rotator();
    rows[i].pos = new PVector(rows[i].size,2*rows[i].size+rows[i].size*i*2);
    if(i!=0){
      rows[i].speed = rows[i-1].speed*1.2;
    }
  }
}

void draw(){
  //background(255);
  for(int i=0; i<columns.length; i++){
    columns[i].show();
    //line(columns[i].point.x,0,columns[i].point.x,height);
  }
  for(int i=0; i<rows.length; i++){
    rows[i].show();
    //line(0,rows[i].point.y,width,rows[i].point.y);
  }
  for(int i=0; i<columns.length; i++){
    for(int j=0; j<rows.length; j++){
      point(columns[i].point.x,rows[j].point.y);
    }
  }
}
