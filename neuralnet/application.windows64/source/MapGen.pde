float[][] preMap = new float[1000][1000];
color[][] map = new color[1000][1000];
float continentalFactor = 0.015; //Higher = more split, Lower = less split; Double when doubling map size in order to increase resolution of map without changing the way they generate.
int seaLevel = 90;
void mapGen(){
  for(int j=0; j<map[0].length; j++){
    for(int i=0; i<map.length; i++){
      float temp = noise(i*continentalFactor,j*continentalFactor)*255;
      if(temp>seaLevel){
        map[i][j] = color(0,255*((temp-seaLevel)/temp)+seaLevel,0);
      }else{
        map[i][j] = color(0,0,temp+50);
      }
    }
  }
}
