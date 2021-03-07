// Global Variables
float[][] squaresX = new float[4][4]; // For drawing the outer
float[][] squaresY = new float[4][4]; // and inner squares
int[][] window = new int[4][4]; // 4*4 Array for all coordinates of the grid.
int score = 0; // Initial Score = 0
boolean move = false; // Has any tile moved?
boolean isRunning = true; // Can a new turn start?
boolean gameover = false; // Is the game over?
PFont font; // Custom font

void setup()
{
  /*
   * All the code that is for the designing and mandatory backend reasons. Especially:
   * General look
   * Headline
   * Putting squares in the right places
   * Generating the first square in our 2D-array
   */

  size(870, 975); // Setting the size
  noStroke(); // Remove the stroke
  strokeJoin(ROUND); // Make corners round
  font = loadFont("Consolas-40.vlw");
  textFont(font);
  
 for(int i=0;i<4;i++) // Loop for 4*4 grid, resets all values to zero when the game starts over.
 {
   for(int j=0;j<4;j++)
   {
     window[i][j] = 0;
     squaresX[i][j] = 0;
     squaresY[i][j] = 0;
   }
 }

  generateNew((int) random(1,2.99)); // Generate 1 or 2 new numbers at the start of the game.

  for (int i=0; i<4; i++) // Generate the inner squares
  {
    for (int j=0; j<4; j++)
    {
      float x = 140 + 195*i; // Edge + Distance to next square
      float y = 240 + 195*j; // ^
      squaresX[i][j] = x; // Set the x coordinate
      squaresY[i][j] = y; // Set the y coordinate
    }
  }

  generateBackground(); // Generate the background
}

void draw()
{
  /*
   * Constant loops to:
   * Check if drawing is still enabled
   * Check if the game is over
   * (If yes, initiate game-over-screen and mode)
   */

  if (isRunning == true && gameover == false) // If the game is not over and drawing is enabled:
  {
    drawSquares(12); // Draw squares with the specific alpha value
  }

  if (gameover==true) // If the game is over
  {
    isRunning = false; // Disable Drawing
  }
}

void generateBackground() 
{
  /*
   * Function to draw the empty squares without a value (0) / on all parts
   */
   
  background(255, 255, 255); // White background
  
  textAlign(CENTER); // Text alignment in the center
  textSize(66);
  fill(19, 182, 236); // Light blue
  text("2048", 100, 100); // Headline "2048"
  
  textAlign(LEFT, TOP); // Align text at the top left
  textSize(30);
  text("Score: " + score, 690, 80); // Score Headline
  
  rectMode(CENTER); // Align rectangles at the center
  rect(435, 535, 820, 820, 10, 10, 10, 10); // Outer rectangle

  for (int i=0; i<4; i++) // Loop for 4*4 grid
  {
    for (int j=0; j<4; j++)
    {
      fill(17, 171, 217); // Dark blue
      rect(squaresX[i][j], squaresY[i][j], 160, 160, 10); // Empty squares
    }
  }
}

void drawSquares(int a) 
{
  /*
   * Drawing the squares with values over the
   * already generated background rectangles.
   * Variable 'a' is for the alpha colors of those.
   */

  for (int i=0; i<4; i++) // Loop for 4*4 grid
  {
    for (int j=0; j<4; j++) 
    {
      int x = window[i][j]; // Aid variable
      if (x != 0) // If the array at position i j has a value:
      { 
        determineColor(x, a); // Get the specified color depending on the number
        rect(squaresX[i][j], squaresY[i][j], 135, 135, 10); // Set a rectangle at the specific saved coordinates.
        fill(#000000); // Black
        textSize(48);
        textAlign(CENTER, CENTER); // Align text at the center of the screen
        text(window[i][j], squaresX[i][j], squaresY[i][j]); // Set the number at the specific position
      }
    }
  }
}

void move() 
{
  /*
   * Function used for all moving mechanics.
   * (This is where the real fun begins)
   * Contents:
   * Game-Over Check
   * Moving
   * Merging
   * Fading in
   */

  gameover = isGameOver(); // Check if the game is over

  // This loop is used to check if any numbers are falsely moving
  // For this, we basically copy the old values of the array to the new one.
  // Later on, we then check if there was any movement.
  int[][] oldValues = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}};
  for (int i=0; i<4; i++) // Loop for 4*4 grid
  {
    for (int j=0; j<4; j++) 
    {
      oldValues[i][j] = window[i][j]; // Saving all old values into the oldValues array.
    }
  }
  
  switch (keyCode) // Depending on the pressed key, do the following:
  {
  case UP:
    {
      for (int i=0; i<4; i++) // Loop for 4*4 grid (Basic Moving)
      {
        for (int j=0; j<4; j++) 
        {
          int count = 0; // Variable to get through the grid
          while (window[i][j] == 0 && count < 4) 
          {
            count++;
            for (int k=0; k+j<3; k++) 
            {
              window[i][j+k] = window[i][j+k+1]; // Set the new position
            }
            window[i][3] = 0; // Reset the old value
          }
        }
        for (int j=0; j<4; j++) // Merging
        {
          if (j<3) 
          {
            if (window[i][j] == window[i][j+1]) 
            {
              window[i][j] += window[i][j+1];
              score += window[i][j];
              for (int k=1; k<(3-j); k++) 
              {
                window[i][j+k] = window[i][j+k+1];
              }
              window[i][3] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  case DOWN: 
    {
      for (int i=0; i<4; i++) // Loop for 4*4 grid (Basic Moving)
      {
        for (int j=3; j>0; j--) 
        {
          int count = 0; // Variable to get through the grid
          while (window[i][j] == 0 && count < 4) 
          {
            count++;
            for (int k=0; j-k>0; k++) 
            {
              window[i][j-k] = window[i][j-k-1];
            }
            window[i][0] = 0; // Reset the old value
          }
        }
        for (int j=3; j>0; j--) // Merging
        {
          if (j>0) 
          {
            if (window[i][j] == window[i][j-1]) 
            {
              window[i][j] += window[i][j-1];
              score += window[i][j];
              for (int k=1; j-k>0; k++) 
              {
                window[i][j-k] = window[i][j-k-1];
              }
              window[i][0] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  case LEFT: 
    {
      for (int j=0; j<4; j++) // Loop for 4*4 grid (Basic Moving)
      {
        for (int i=0; i<4; i++) 
        {
          int count = 0; // Variable to get through the grid
          while (window[i][j] == 0 && count < 4) 
          {
            count++;
            for (int k=0; k+i<3; k++) 
            {
              window[i+k][j] = window[i+k+1][j];
            }
            window[3][j] = 0; // Reset the old value
          }
        }
        for (int i=0; i<4; i++) // Merging
        {
          if (i<3) 
          {
            if (window[i][j] == window[i+1][j]) 
            {
              window[i][j] += window[i+1][j];
              score += window[i][j];
              for (int k=1; k+i<3; k++) 
              {
                window[i+k][j] = window[i+k+1][j];
              }
              window[3][j] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  case RIGHT: 
    {
      for (int j=0; j<4; j++) // Loop for 4*4 grid (Basic Moving)
      {
        for (int i=3; i>0; i--) 
        {
          int count = 0; // Variable to get through the grid
          while (window[i][j] == 0 && count < 4) 
          {
            count++;
            for (int k=0; i-k>0; k++) 
            {
              window[i-k][j] = window[i-k-1][j];
            }
            window[0][j] = 0; // Reset the old value
          }
        }
        for (int i=3; i>0; i--) // Merging
        {
          if (i>0) 
          {
            if (window[i][j] == window[i-1][j]) 
            {
              window[i][j] += window[i-1][j];
              score += window[i][j];
              for (int k=1; i-k>0; k++) 
              {
                window[i-k][j] = window[i-k-1][j];
              }
              window[0][j] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  }

  for (int i=0; i<4; i++) // Loop for 4*4 grid
  {
    for (int j=0; j<4; j++) 
    {
      if (oldValues[i][j] != window[i][j]) // If any value is different
      {
        move = true; // Set move to true and allow a new turn
        break;
      }
      if (move==true) 
      {
        break; // Then go out of the loop
      }
    }
  }

  if (move==true) 
  {
    isRunning = true; // Making a new turn initiate
    move = false; // Resetting the variable
  }
  if (isRunning == true) // If the game is still running
  {
    generateBackground(); // Reset the background
    drawSquares(256); // Draw the inner squares
    generateNew(1); // And generate 1 new number.
  }
}

void determineColor(int x, int y) 
{
  /*
   * Simple function used to set colors depending on the number
   * Passes the number x and the alpha value y
   * and gets the color depending on it.
   */

  switch(x) 
  {
  case 2: 
    fill(#B5DDE6, y); 
    break;
  case 4: 
    fill(#95DDEF, y); 
    break;
  case 8: 
    fill(#7DDEF7, y); 
    break;
  case 16: 
    fill(#65DBF8, y); 
    break;
  case 32: 
    fill(#36D3FA, y); 
    break;
  case 64: 
    fill(#06C8F8, y); 
    break;
  case 128: 
    fill(#ECB2C1, y); 
    break;
  case 256: 
    fill(#EC93AB, y); 
    break;
  case 512: 
    fill(#EF7293, y); 
    break;
  case 1024: 
    fill(#F75F88, y); 
    break;
  case 2048: 
    fill(#F54272, y); 
    break;
  case 4096: 
    fill(#ECD8B2, y); 
    break;
  case 8192: 
    fill(#ECCE93, y); 
    break;
  case 16384: 
    fill(#EFC672, y); 
    break;
  case 32768: 
    fill(#F7C45F, y); 
    break;
  case 65536: 
    fill(#F5B942, y); 
    break;
  case 131072: 
    fill(#FF8B37, y); 
    break;
  default: 
    fill(#B5DDE6, y); 
    break;
  }
}

void generateNew(int turns)
{
  /*
   * Function used to generate new array entries if there currently is space on the
   * screen. Ran after every turn. The turns integer is used to generate a specified amount
   * of numbers.
   */

  for (int i=0; i<turns; i++)
  {
    int x, y, number, n = 0;
    do 
    {
      x = (int) random(0, 4); // Get random values pointing to a spot to the array.
      y = (int) random(0, 4);
      // If the space is empty (0) and the maximum turns (40) isn't reached, run again.
    } 
    while (window[x][y] != 0 && n++ < 40); // (15÷16)÷40 ~= 2,344% Probability of not adding a two at last tile.
    if ((int) random(0, 100) <= 50) number = 2;  // Use either a 4 or a 2.
    else number = 4;
    window[x][y] = number; // Else, set a 2/4 at that position.
  }
}


void keyPressed() 
{
  isRunning = false; // Reset the variable
  move();
}

void mousePressed() 
{
  if (gameover == true) // When the game is over and the mouse is pressed, restart the game.
  {
    setup(); // Run the setup again and therefore reset everything.
  }
}

boolean isGameOver() 
{
  /* 
   *  Boolean function to check if the game is over.
   *  Checks specifically, if any of the arrays values, and the values after them are still 0
   *  If yes, return false, else true.
   */
  for (int i=0; i<4; i++) // Loop for 4*4 grid
  {
    for (int j=0; j<3; j++) 
    {
      if ( window[i][j]==0 || window[j][i]==0 || window[i][j+1]==0 || window[j+1][i]==0 || window[i][j]==window[i][j+1] || window[j][i]==window[j+1][i]) return false; // The game is not over, since values have changed or still can change.
    }
  }
  return true; // No values have changed or can change, the game is over.
}
