// Global Variables
int window[][] = new int[4][4]; // 4*4 Array for all coordinates of the grid.
int score=0; // Initial Score = 0
int gridSize = 3; // Array length

void setup()
{
  /*
    All the code that is for the designing and mandatory backend reasons. Especially:
   * General look
   * Headline
   * Putting squares in the right places
   * Generating the first square in our 2D-array
   * Initial Score
   */

  size(900, 1000); // Size of the tab.
  noStroke(); // Removes the stroke of forms.
  textAlign(CENTER); // Alligns text at the center.
  colorMode(RGB, 255, 255, 255); // Setting the color-mode
  textSize(66);
  background(255, 255, 255);
  fill(19, 182, 236);
  rect(70, 170, 760, 760, 10, 10, 10, 10); // Inner grid
  text("2048", 168, 118); // Headline
  
  fill(19,182,236);
  textSize(30);
  text("Score: " + score,750,105);
  generateNew(); // Generating our first entry in the array.
  resetSquareDesigns();
  
}

void draw()
{
  textSize(80);
  fill(255, 255, 255);
  
  setNumbers();
  resetSquareDesigns();
}

void keyPressed() // Actions ran when a key is pressed. (New turn)
{
  
  //move();
  
  if (keyCode==RIGHT || keyCode==LEFT || keyCode==UP || keyCode==DOWN) generateNew();
}


void generateNew()
{
  /*
   * Function used to generate new array entries if there currently is space on the
   * screen. Ran after every turn.
   */

  int x, y, n = 0;
  do {
    x = (int) random(0, 4); // Get random values pointing to a spot to the array.
    y = (int) random(0, 4);
    // If the space is empty (0) and the maximum turns (40) isn't reached, run again.
  } while (window[x][y] != 0 && n++ < 40); // (15÷16)÷40 ~= 2,344% Probability of not adding a two at last tile.
  window[x][y] = 2; // Else, set a 2 at that position.
}

void move() {
    /*
     * This function is used to properly move around the squares.
     * We are using self-made equations here, further described in our documentation.
     */
    
    switch (keyCode) 
    {
        case UP:
        case LEFT: 
        {
            for (int x = 0; x <= gridSize; x++) 
            {
                for (int y = 0; y <= gridSize; y++) 
                {
                    if (window[x][y] != 0)
                    {
                    int d = ((keyCode == UP) ? y : x); // if key code is UP, use y, else x
                    if (keyCode == UP) window[x][y-d] = window[x][y];
                    if (keyCode == LEFT) window[x-d][y] = window[x][y];
                    
                    window[x][y] = 0;
                    }
                }
            }
            break;
        }
        
        case DOWN:
        case RIGHT: 
        {
            for (int x = gridSize; x >= 0; x--) 
            {
                for (int y = gridSize; y >= 0; y--) 
                {
                    if (window[x][y] != 0)
                    {
                    int d = gridSize - ((keyCode == DOWN) ? y : x); // if key code is DOWN, use y, else x
                    if (keyCode == DOWN) window[x][y+d] = window[x][y];
                    if (keyCode == RIGHT) window[x+d][y] = window[x][y];
                    window[x][y] = 0;
                    }
                }
            }
            break;
        }
    }
}


void setNumbers()
{
  /*
   * Function used to place existing numbers in the array
   * on the black squares in-game.
   */

  int LetterX = 0, LetterY = 0;
  for (int x=0; x<=3; x++) 
  {
    for (int y=0; y<=3; y++) 
    {
      if (window[x][y] != 0)
      {
        // println("Not 0 found at: ", x, y);
        switch(x)
        {
        case 0:
          LetterX=174;
          break;
        case 1:
          LetterX=358;
          break;
        case 2:
          LetterX=542;
          break;
        case 3:
          LetterX=726;
          break;
        default:
          println("Error: Not Found");
          break;
        }
        switch(y)
        {
        case 0:
          LetterY=302;
          break;
        case 1:
          LetterY=486;
          break;
        case 2:
          LetterY=670;
          break;
        case 3:
          LetterY=854;
          break;
        default:
          println("Error: Not Found");
          break;
        }
        // println(LetterX, LetterY);
        // println(window[x][y],x,y);
        text(window[x][y], LetterX, LetterY);
      }
    }
  }
}

void resetSquareDesigns()
{
  /*
   * Function used to generate the screen at the start of the game,
   * and to reset them after every turn to make space for new squares.
   */

  int SquareX=94, SquareY=194;
  while (SquareY<=925) // 185*5=660
  {
    fill(#0E4498);
    square(SquareX, SquareY, 160);
    SquareX=SquareX+184;

    if (SquareX>=660)
    {
      SquareY=SquareY+184;
      SquareX=94;
    }
  }
}
