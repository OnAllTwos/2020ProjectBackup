character[] fighters = new character[1];
class character implements Cloneable{
  int charID = 0;
  String name = "";
  public Object clone(){
    try{
      return super.clone();
    }catch(Exception e){
      return null;
    }
  }
}
