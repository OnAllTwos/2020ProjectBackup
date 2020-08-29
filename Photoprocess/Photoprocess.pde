//Just messing around with photos a bit
PImage img;
PImage newImg;
float blurfactor=0;
void setup(){
  img=loadImage("Test.png");
  newImg=loadImage("Test.png");
  size(674, 337);
}

void draw(){
  blurfactor+=2;
  image(img,0,0);
  newImg.loadPixels();
  for(int i=0; i<img.width*img.height-(int)blurfactor;i+=100){
    if(i>(int)blurfactor){
      newImg.pixels[i-(int)blurfactor] = color((red(img.pixels[i])+red(img.pixels[i-(int)blurfactor]))/2,(green(img.pixels[i])+green(img.pixels[i-(int)blurfactor]))/2,(blue(img.pixels[i])+blue(img.pixels[i-(int)blurfactor]))/2);
      newImg.pixels[i+(int)blurfactor] = color((red(img.pixels[i])+red(img.pixels[i+(int)blurfactor]))/2,(green(img.pixels[i])+green(img.pixels[i+(int)blurfactor]))/2,(blue(img.pixels[i])+blue(img.pixels[i+(int)blurfactor]))/2);
    }
  }
  /*for(int i=0; i<img.width*img.height-(int)blurfactor*width;i+=1){
    if(i>(int)blurfactor*width){
      newImg.pixels[i-(int)blurfactor*width] = color((red(img.pixels[i])+red(img.pixels[i-(int)blurfactor*width]))/2,(green(img.pixels[i])+green(img.pixels[i-(int)blurfactor*width]))/2,(blue(img.pixels[i])+blue(img.pixels[i-(int)blurfactor*width]))/2);
      newImg.pixels[i+(int)blurfactor*width] = color((red(img.pixels[i])+red(img.pixels[i+(int)blurfactor*width]))/2,(green(img.pixels[i])+green(img.pixels[i+(int)blurfactor*width]))/2,(blue(img.pixels[i])+blue(img.pixels[i+(int)blurfactor*width]))/2);
    }
  }*/
  newImg.updatePixels();
  image(newImg,img.width,0);
}
