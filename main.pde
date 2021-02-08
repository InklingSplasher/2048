int window[][] = new int[4][4];
void setup()
{
  size(1028,1028);
  background(#347B8D);
  generateNew();
}

void draw(){}

void keyPressed()
{
  if(keyCode==RIGHT) 
  {
    for(int i=3; i>=0; i--) //tmp values
    {
      int y = 2;
      if(window[i][y]==0)
      {
        int x = i;
        println(x,y);
        break;
      }
    }
  }
  if(keyCode==LEFT) 
  {
  }
  if(keyCode==UP) 
  {
  }
  if(keyCode==DOWN) 
  {
  }
  
  if(keyCode==RIGHT || keyCode==LEFT || keyCode==UP || keyCode==DOWN)
  generateNew();
}

/*void newCoords()
{
  for(int i=3; i>=0; i--)
    {
      int y = 2;
      if(window[i][y]==0)
      {
        int x = i;
      }
    }
}*/


void generateNew()
{
  int x, y, n;
  n = 0;
  do {
    x = (int) random(0,3);
    y = (int) random(0,3);
    println("Coords: " + x + " " + y + "\nContent: " + window[x][y]);
  } while (window[x][y] != 0 && n++ < 9);
  window[x][y] = 2;
}
