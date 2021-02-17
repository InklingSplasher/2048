int window[][] = new int[4][4];
int score=0;
int squareX=85;
int squareY=185;
int LetterX, LetterY;

void setup()
{
  /*
    All the code that is for the designing and mandatory backend reasons. Especially:
   * General look
   * Headline
   * Putting squares in the right places
   * Generating the first square in our 2D-array
   */

  size(900, 1000);
  noStroke();
  colorMode(RGB, 255, 255, 255);
  textSize(65);
  textAlign(CENTER);
  background(255, 255, 255);
  fill(19, 182, 236);
  rect(70, 170, 760, 760, 10, 10, 10, 10);
  text("2048", 70, 105);

  resetSquareDesigns(); // Putting our first squares into place.

  generateNew(); // Generating our first entry in the array.
}

void draw()
{
  textSize(80);
  fill(255, 255, 255);

  /*fill(19,182,236);
   textSize(30);
   text("Score:" + score,623,105);
   fill(255,255,255);
   rect(600,35,250,100);*/
}

void keyPressed() // Actions ran when a key is pressed. (New turn)
{
  if (keyCode==RIGHT)
  {
    setNumbers(); // For debugging at the moment.
  }
  if (keyCode==LEFT) 
  {
  }
  if (keyCode==UP) 
  {
  }
  if (keyCode==DOWN) 
  {
  }

  if (keyCode==RIGHT || keyCode==LEFT || keyCode==UP || keyCode==DOWN)
    generateNew();
}


void generateNew()
{
  /*
    Function used to generate new array entries if there currently is space on the
   screen. Ran after every turn.
   */

  int x, y, n;
  n = 0;
  do {
    x = (int) random(0, 3);
    y = (int) random(0, 3);
  } while (window[x][y] != 0 && n++ < 9);
  window[x][y] = 2;
  println("Coords: " + x + " " + y + "\nContent: " + window[x][y]);
}

void setNumbers()
{
  /*
    Function used to place existing numbers in the array
   on the black squares in-game.
   */

  for (int x=0; x<=3; x++) 
  {
    for (int y=0; y<=3; y++) 
    {
      if (window[x][y] != 0)
      {
        println("Not 0 found at: ", x, y);
        switch(x)
        {
        case 0:
          LetterX=85;
          break;
        case 1:
          LetterX=275;
          break;
        case 2:
          LetterX=465;
          break;
        case 3:
          LetterX=655;
          break;
        default:
          println("Error: Not Found");
          break;
        }
        switch(y)
        {
        case 0:
          LetterY=185;
          break;
        case 1:
          LetterY=375;
          break;
        case 2:
          LetterY=565;
          break;
        case 3:
          LetterY=755;
          break;
        default:
          println("Error: Not Found");
          break;
        }
        println(LetterX, LetterY);
        text(window[x][y], LetterX, LetterY);
      }
    }
  }
}

void resetSquareDesigns()
{
  /*
    Function used to generate the screen at the start of the game,
   and to reset them after every turn to make space for new squares.
   */

  while (squareY<=925) // 185*5=660
  {
    fill(0);
    square(squareX, squareY, 160);
    squareX=squareX+190;

    if (squareX>=660)
    {
      squareY=squareY+190;
      squareX=85;
    }
  }
}
