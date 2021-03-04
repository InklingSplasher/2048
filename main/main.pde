// Global Variables // //<>//
int window[][] = new int[4][4]; // 4*4 Array for all coordinates of the grid.
int score=0; // Initial Score = 0
int gridSize = window.length-1; // Array length
boolean tilesMoved = false;
PFont font;

void setup()
{
  /*
   * All the code that is for the designing and mandatory backend reasons. Especially:
   * General look
   * Headline
   * Putting squares in the right places
   * Generating the first square in our 2D-array
   * Initial Score
   */
  font = loadFont("Consolas-40.vlw");
  textFont(font);
  size(900, 1000); // Size of the tab.
  noStroke(); // Removes the stroke of forms.
  textAlign(CENTER); // Alligns text at the center.
  colorMode(RGB, 255, 255, 255); // Setting the color-mode
  textSize(66);
  background(255, 255, 255);
  fill(19, 182, 236);
  rect(70, 170, 760, 760, 10, 10, 10, 10); // Inner grid
  text("2048", 168, 118); // Headline

  fill(19, 182, 236);
  textSize(30);
  text("Score: " + score, 750, 105);

  generateNew(); // Generating our first entry in the array.
}

void draw()
{
  resetSquareDesigns();
  textSize(80);
  fill(255, 255, 255);
  setNumbers();
}

void keyPressed() // Actions ran when a key is pressed. (New turn)
{
  move();

  if (tilesMoved && (keyCode==RIGHT || keyCode==LEFT || keyCode==UP || keyCode==DOWN)) generateNew();
}


void generateNew()
{
  /*
   * Function used to generate new array entries if there currently is space on the
   * screen. Ran after every turn.
   */

  int x, y, number, n = 0;
  do 
  {
    x = (int) random(0, 4); // Get random values pointing to a spot to the array.
    y = (int) random(0, 4);
    // If the space is empty (0) and the maximum turns (40) isn't reached, run again.
  } 
  while (window[x][y] != 0 && n++ < 40); // (15÷16)÷40 ~= 2,344% Probability of not adding a two at last tile.
  if ((int) random(0, 100) <= 50) number = 2; 
  else number = 4; // Use either a 4 or a 2.
  window[x][y] = number; // Else, set a 2/4 at that position.
}

void move() 
{
  /*
   * This function is used to properly move around the squares.
   * We are using self-made equations here, further described in our documentation.
   */
  boolean isSet = false;
  // Depending on the pressed key, use the corresponding function.
  switch (keyCode) 
  {
  case UP: case LEFT: 
    {
      for (int x = 0; x <= gridSize; x++) // Outer loop (left to right)
      {
        for (int y = 0; y <= gridSize; y++) // Inner loop (top to bottom)
        {
          if (window[x][y] != 0) // If the array's value at that position isn't zero:
          {
            int d = ((keyCode == UP) ? y : x); // d = distance. If key code is UP, use y, else x.
            int dd = 0; // Distance for merging
            if (keyCode == UP) 
            {
              while (window[x][y - d] != 0) 
              {
                while (window[x][y - d] == window[x][y] && dd<=3)
                {
                  if (window[x][y] == window[x][y - d] && y + d != y) // Merging
                  {
                    window[x][y - d] = window[x][y] + window[x][y - d];
                    isSet = true;
                    break;
                  }
                  if (y-dd<0 || window[x][y-dd] != window[x][y]) break;
                  dd++;
                }
                d--;

                if (y - d > gridSize || d < 0) 
                {
                  d = 0;
                  break;
                }
              }
              tilesMoved = d != 0 || isSet;
              if (!isSet) window[x][y - d] = window[x][y]; // If the key is UP, decrease y coordinate.
            }
            if (keyCode == LEFT) 
            {
              while (window[x - d][y] != 0) 
              {
                while (window[x - d][y] == window[x][y] && dd<=3)
                {
                  if (window[x][y] == window[x - d][y] && x - d != x) // Merging
                  {
                    window[x - d][y] = window[x][y] + window[x - d][y];
                    isSet = true;
                    break;
                  }
                  if (x-dd<0 || window[x-dd][y] != window[x][y]) break;
                  dd++;
                }
                d--;
                if (x - d > gridSize || d < 0) 
                {
                  d = 0;
                  break;
                }
              }
              tilesMoved = d != 0 || isSet;
              if (!isSet) window[x - d][y] = window[x][y]; // If the key is LEFT, decrease x coordinate.
            }

            if ((y != y - d) || isSet)
              window[x][y] = 0; // Then, reset value of old coordinates to zero, if the position has changed.
          }
        }
      }
    }
    break;
  case DOWN: case RIGHT: 
    {
      for (int x = gridSize; x >= 0; x--) // Outer loop (right to left)
      {
        for (int y = gridSize; y >= 0; y--) // Inner loop (bottom to top)
        {
          if (window[x][y] != 0) // If the array's value at that position isn't zero:
          {
            int d = gridSize - ((keyCode == DOWN) ? y : x); // d = distance. If key code is DOWN, use y, else x.
            int dd  = d; // Distance for merging
            if (keyCode == DOWN) 
            {
              while (window[x][y + d] != 0) 
              {
                while (window[x][y + d] == window[x][y] && dd<=3)
                {
                  if (window[x][y] == window[x][y + d] && y + d != y) // Merging
                  {
                    window[x][y + d] = window[x][y] + window[x][y + d];
                    isSet = true;
                    break;
                  }
                  if (y+dd>3 || window[x][y+dd] != window[x][y]) break;
                  dd++;
                }
                d--;

                if (y + d > gridSize || d < 0) 
                {
                  d = 0;
                  break;
                }
              }
              tilesMoved = d != 0 || isSet;
              if (!isSet) window[x][y + d] = window[x][y]; // If the key is DOWN, increase y coordinate.
            }
            if (keyCode == RIGHT) {
              while (window[x + d][y] != 0) {
                while (window[x + d][y] == window[x][y] && dd<=3)
                {
                  if (window[x][y] == window[x + d][y] && x + d != x) // Merging
                  {
                    window[x + d][y] = window[x][y] + window[x + d][y];
                    isSet = true;
                    break;
                  }
                  if (x+dd>3 || window[x+dd][y] != window[x][y]) break;
                  dd++;
                }
                d--;
                if (x + d > gridSize || d < 0) 
                {
                  d = 0;
                  break;
                }
              }
              tilesMoved = d != 0 || isSet;
              if (!isSet) window[x + d][y] = window[x][y]; // If the key is RIGHT, increase x coordinate.
            }

            if ((y != y + d) || isSet)
              window[x][y] = 0; // Then, reset value of old coordinates to zero, if the position has changed.
          }
        }
      }
    }
    break;
  default: 
    {
      println("Warning: This key is not used.");
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

  int LetterX, LetterY;
  for (int x=0; x<=gridSize; x++) // Outer loop (left to right)
  {
    for (int y=0; y<=gridSize; y++) // Inner loop (top to bottom)
    {
      if (window[x][y] != 0) // If the array's value at that position isn't zero:
      {
        // Define x coordinate in the grid depending on the array coordinate.
        switch (x) 
        {
        case 0: LetterX = 174; break;
        case 1: LetterX = 358; break;
        case 2: LetterX = 542; break;
        case 3: LetterX = 726; break;
        default: 
          {
            LetterX = 0;
            println("Error: Out of bounds!");
            break;
          }
        }
        // Define y coordinate in the grid depending on the array coordinate.
        switch (y) 
        {
        case 0: LetterY = 302; break;
        case 1: LetterY = 486; break;
        case 2: LetterY = 670; break;
        case 3: LetterY = 854; break;
        default: 
          {
            LetterY = 0;
            println("Error: Out of bounds!");
            break;
          }
        }
        text(window[x][y], LetterX, LetterY); // Set the specific number at the correct spot.
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

  int SquareX=94, SquareY=194; // Start coordinates of the inner squares
  while (SquareY<=925) // 185*5=660
  {
    fill(0xff0E4498); // dark blue
    square(SquareX, SquareY, 160);
    SquareX=SquareX+184;

    if (SquareX>=660) // When the inner square would be out of the outer square, increase the Y coordinate.
    {
      SquareY=SquareY+184;
      SquareX=94;
    }
  }
}
