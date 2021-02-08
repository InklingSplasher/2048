int window[][] = new int[4][4];
int score=0000;
int squareX=85;
int squareY=185;

void setup()
{
  size(900,1000);
  noStroke();
  colorMode(RGB,255,255,255);
  textSize(65);
  background(255,255,255);
  fill(19,182,236);
  rect(70,170,760,760,10,10,10,10);
  text("2048",70,105);
  generateNew();
  score = score+64;
  
  while(squareY<660)
  {
    fill(0);
    square(squareX,squareY,160);
    squareX=squareX+190;
    if(squareX>=690)
    {
      squareY=squareY+190;
      squareX=85;
    }
  }
}

void draw()
{
  fill(19,182,236);
  textSize(30);
  text("Score:" + score,623,105);
  fill(255,255,255);
  rect(600,35,250,100);
}

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
