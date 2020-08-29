void makeBaby(PVector pos_, bug parent){  //Deepcopy the parent org
  bug newBug = new bug();
  newBug.pos = pos_;
  newBug.Brain.layers = new layer[parent.Brain.layers.length];
  for(int i=0;i<parent.Brain.layers.length;i++){
    newBug.Brain.layers[i] = new layer();
    newBug.Brain.layers[i].nodes = new node[parent.Brain.layers[i].nodes.length];
    for(int j=0;j<parent.Brain.layers[i].nodes.length;j++){
      newBug.Brain.layers[i].nodes[j] = new node();
      if(i!=3){
        newBug.Brain.layers[i].nodes[j].weights = new float[parent.Brain.layers[i].nodes[j].weights.length];
        for(int k=0;k<parent.Brain.layers[i].nodes[j].weights.length;k++){
          //println(i + ", " +j);
          newBug.Brain.layers[i].nodes[j].weights[k] = parent.Brain.layers[i].nodes[j].weights[k] + mutate(10,0.1,0.2);
          if(!baby){
          println();
          baby = true;
          }
        }
      }
    }
  }
  newBug.energy = parent.eggEnergy;
  newBug.isEgg = true;
  newBug.tSize = parent.tSize + mutate(15,1,4);
  newBug.eyeAngle = parent.eyeAngle + mutate(10,radians(5),radians(10));
  newBug.tSpeed = parent.tSpeed + mutate(10,0.5,1.5);
  newBug.eggGest = parent.eggGest + mutate(10,30,300);
  newBug.eggEnergy = parent.eggEnergy + mutate(10,20,200);
  newBug.maturity = parent.maturity + mutate(10,300,600);
  for(int i=0; i<newBug.eyes.length; i++){
    newBug.eyes[i] = new eye();
    newBug.eyes[i].eyeDist = parent.eyes[i].eyeDist + mutate(10,5,15);;
  }
  bugs = (bug[]) append(bugs,newBug);
  println("BABY");
  baby = true;
}

float mutate(float chance, float minChange, float maxChange){
  float toBeat = random(0,100);
  if(chance>toBeat){
    int pm = (int)random(0,1);
    switch(pm){
      case 0:
        return random(minChange, maxChange);
      case 1:
        return -1*random(minChange, maxChange);
    }
  }
  return 0;
}

boolean mutBool(float chance){
  float toBeat = random(0,100);
  if(chance>toBeat){
    return true;
  }
  return false;
}
