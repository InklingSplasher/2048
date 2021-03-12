// Global Variables //<>//
int[][] window = new int[4][4]; // 4*4 Array for all coordinates of the grid.
int score = 0; // Initial Score = 0
int gamestate = 0;
boolean tileMoved = false; // Has any tile moved?
boolean isRunning = true; // Can a new turn start?
boolean GameOver = false; // Is the game over?
boolean endless = false; // Is endless mode enabled?
PFont font; // Custom fonts
PFont headline;

void setup()
{
  /*
   * All the code that is for the designing and mandatory backend reasons. Especially:
   * General look
   * Headline
   * Putting squares in the right places
   * Generating the first square in our 2D-array
   */

  size(870, 980); // Setting the size
  noStroke(); // Remove the stroke
  font = loadFont("Consolas-40.vlw");
  headline = loadFont("URWGothic-Demi-48.vlw");
  textFont(font);

  for (int x=0; x<4; x++) // Loop for 4*4 grid, resets all values to zero when the game starts over.
  {
    for (int y=0; y<4; y++)
    {
      window[x][y] = 0;
    }
  }

  generateNew((int) random(1, 2.99)); // Generate 1 or 2 new numbers at the start of the game.
  generateBackground(); // Generate the background
}

void draw()
{   
  /*
   * Check if drawing is still enabled
   * Check if the game is over
   */

  switch(gamestate)
  {
  case 0:
    {
      // Startscreen
        rectMode(CENTER); 
        fill(#FFFFFF, 12);
        rect(width/2, height/2+40, 520, 520, 10, 10, 10, 10);

        textFont(headline);
        textAlign(CENTER);
        fill(19, 182, 236);
        textSize(48);
        text("Welcome", width/2, height/2-125);

        fill(#000000, 12);
        textSize(32);
        text("Press s to start the Game", width/2, height/2-50);
        
        drawButtons();
        noStroke();
        fill(255);
        rect(810,65,50,100);
        drawButtons();
        noStroke();
      break;
    }    
  case 1:
    {
      if (!GameOver && isRunning) // If the game is not over and drawing i
      {
        drawSquares(12); // Draw squares with the specific alpha value
        fill(255);
        rect(810,65,50,100);
        drawButtons();
        noStroke();
      }

      if (GameOver) // If the game is over
      {
        isRunning = false; // Disable Drawing

        rectMode(CENTER); 
        fill(#FFFFFF, 12);
        rect(width/2, height/2+40, 520, 520, 10, 10, 10, 10);

        textFont(headline);
        textAlign(CENTER);
        fill(#ED3D3D, 36);
        textSize(48);
        text("Game Over", width/2, height/2+10);

        fill(#000000, 12);
        textSize(32);
        text("Click anywhere to restart!", width/2, height/2+70);
      }
      break;
    }
  }
}

void keyPressed() 
{
  if (gamestate==1) move();
  if (gamestate==0 && keyCode == 83) 
  {
    gamestate = 1;
    generateBackground(); 
  }
}

void mousePressed() 
{
  if (gamestate==1)
  {
    if (GameOver) // When the game is over and the mouse is pressed, restart the game.
    {
      if (!endless) score = 0; // Resetting the score
      GameOver = false; // Resetting the variables to actually spawn new numbers at the beginning.
      isRunning = true;
      setup(); // Run the setup again and therefore reset everything.
    } else if (mouseX >= 790 && mouseX <= 830 && mouseY >= 10 && mouseY <= 60 && !endless)
    {
      endless = true; // Turn endless mode on
      generateBackground();
    }
  }
  if (mouseX >= 790 && mouseX <= 830 && mouseY >= 65 && mouseY <= 110)
  {
    println("Goodbye!");
    exit(); // Exit the program
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

void generateBackground() 
{
  /*
   * Function to draw the empty squares without a value (0) / on all parts
   */

  background(255, 255, 255); // White background

  textAlign(CENTER); // Text alignment in the center
  fill(19, 182, 236); // Light blue
  textFont(headline);
  textSize(66);
  text("2048", 100, 90); // Headline "2048"

  textAlign(CENTER, CENTER); // Align text at the top left
  textSize(30);
  if (endless) fill(#fa0000);
  text("Score: " + score, width/2, 65); // Score Headline
  fill(19, 182, 236);
  textFont(font);

  rectMode(CENTER); // Align rectangles at the center
  rect(435, 535, 820, 820, 10, 10, 10, 10); // Outer rectangle
  
//  textFont(headline);
  fill(0);
  textSize(10);
  text("press r to reset",80,960);

  for (int x=0; x<4; x++) // Loop for 4*4 grid
  {
    for (int y=0; y<4; y++)
    {
      fill(17, 171, 217); // Dark blue
      rect(140+195*x, 240+195*y, 160, 160, 10); // Empty squares
    }
  }
  
  noStroke();
  textFont(headline);
  textAlign(CENTER);
  fill(0, 0, 0);
  textSize(20);
  text("Endless mode", 710, 47);
  text("Stop the game", 705, 97);
  textFont(font);
}

void drawSquares(int alpha) 
{
  /*
   * Drawing the squares with values over the
   * already generated background rectangles.
   * Variable 'a' is for the alpha colors of those.
   */

  for (int x=0; x<4; x++) // Loop for 4*4 grid
  {
    for (int y=0; y<4; y++) 
    {
      int j = window[x][y]; // Aid variable
      if (j != 0) // If the array at position i j has a value:
      { 
        determineColor(j, alpha); // Get the specified color depending on the number
        rect(140+195*x, 240+195*y, 135, 135, 10); // Set a rectangle at the specific saved coordinates.
        fill(#000000); // Black
        textSize(48);
        textAlign(CENTER, CENTER); // Align text at the center of the screen
        text(window[x][y], 140+195*x, 240+195*y); // Set the number at the specific position
      }
    }
  }
}

void drawButtons()
{
  if (endless || mouseX >= 790 && mouseX <= 830 && mouseY >= 10 && mouseY <= 60) 
  { 
    fill(0);
  }
  else 
  {
    fill(0,0);
  }
  rect(810, 40, 40, 40, 10);
  
  
  strokeWeight(2.5);
  stroke(0);
  rect(810, 40, 40, 40, 10);
  fill(0,0);
  rect(810, 90, 40, 40, 10);
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
  isRunning = false; // Reset the variable
  GameOver = isGameOver(); // Check if the game is over and save it into a variable to save computing power

  // This loop is used to check if any numbers are falsely moving
  // For this, we basically copy the old values of the array to the new one.
  // Later on, we then check if there was any movement.
  int[][] oldValues = {{0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}, {0, 0, 0, 0}};
  for (int x=0; x<4; x++) // Loop for 4*4 grid
  {
    for (int y=0; y<4; y++) 
    {
      oldValues[x][y] = window[x][y]; // Saving all old values into the oldValues array.
    }
  }

  switch (keyCode) // Depending on the pressed key, do the following:
  {
  case UP: // Commented only UP, all following are basically programmed the same way, just in other orders.
    {
      for (int x=0; x<4; x++) // Loop for 4*4 grid
      {
        for (int y=0; y<4; y++) // Inner loop for basic movement.
        {
          int count = 0; // Variable to get through the grid
          while (window[x][y] == 0 && count < 4) // As long as the value is 0 at that point and count is smaller than 4
          {
            count++; // Increase the count
            for (int k=0; k+y<3; k++) // As long as k+j is smaller than 3, set the new positions
            {
              window[x][y+k] = window[x][y+k+1]; // Set the new positions by going one step every turn
            }
            window[x][3] = 0; // Reset the old value
          }
        }
        for (int y=0; y<4; y++) // Entering the merging loop when the basic movement is completed.
        {
          if (y<3) 
          {
            if (window[x][y] == window[x][y+1]) // If the value right after the current value is equal
            {
              window[x][y] += window[x][y+1]; // Add those up &
              score += window[x][y]; // Increase the score
              for (int k=1; k<(3-y); k++) // As long as 
              {
                window[x][y+k] = window[x][y+k+1];
              }
              window[x][3] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  case DOWN: 
    {
      for (int x=0; x<4; x++) // Loop for 4*4 grid (Basic Moving)
      {
        for (int y=3; y>0; y--) 
        {
          int count = 0; // Variable to get through the grid
          while (window[x][y] == 0 && count < 4) 
          {
            count++;
            for (int k=0; y-k>0; k++) 
            {
              window[x][y-k] = window[x][y-k-1];
            }
            window[x][0] = 0; // Reset the old value
          }
        }
        for (int y=3; y>0; y--) // Merging
        {
          if (y>0) 
          {
            if (window[x][y] == window[x][y-1]) 
            {
              window[x][y] += window[x][y-1];
              score += window[x][y];
              for (int k=1; y-k>0; k++) 
              {
                window[x][y-k] = window[x][y-k-1];
              }
              window[x][0] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  case LEFT: 
    {
      for (int y=0; y<4; y++) // Loop for 4*4 grid (Basic Moving)
      {
        for (int x=0; x<4; x++) 
        {
          int count = 0; // Variable to get through the grid
          while (window[x][y] == 0 && count < 4) 
          {
            count++;
            for (int k=0; k+x<3; k++) 
            {
              window[x+k][y] = window[x+k+1][y];
            }
            window[3][y] = 0; // Reset the old value
          }
        }
        for (int x=0; x<4; x++) // Merging
        {
          if (x<3) 
          {
            if (window[x][y] == window[x+1][y]) 
            {
              window[x][y] += window[x+1][y];
              score += window[x][y];
              for (int k=1; k+x<3; k++) 
              {
                window[x+k][y] = window[x+k+1][y];
              }
              window[3][y] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  case RIGHT: 
    {
      for (int y=0; y<4; y++) // Loop for 4*4 grid (Basic Moving)
      {
        for (int x=3; x>0; x--) 
        {
          int count = 0; // Variable to get through the grid
          while (window[x][y] == 0 && count < 4) 
          {
            count++;
            for (int k=0; x-k>0; k++) 
            {
              window[x-k][y] = window[x-k-1][y];
            }
            window[0][y] = 0; // Reset the old value
          }
        }
        for (int x=3; x>0; x--) // Merging
        {
          if (x>0) 
          {
            if (window[x][y] == window[x-1][y]) 
            {
              window[x][y] += window[x-1][y];
              score += window[x][y];
              for (int k=1; x-k>0; k++) 
              {
                window[x-k][y] = window[x-k-1][y];
              }
              window[0][y] = 0; // Reset the old value
            }
          }
        }
      }
    }
    break;
  case 82: // 82 for "r" (restart)
    {
      score = 0; // Resetting the score
      endless = false;
      GameOver = false; // Resetting the variables to actually spawn new numbers at the beginning.
      isRunning = true;
      setup();
      return;
    }
  default:
    {
      println("This key is not used!", keyCode);
    }
  }

  for (int x=0; x<4; x++) // Loop for 4*4 grid
  {
    for (int y=0; y<4; y++) 
    {
      if (oldValues[x][y] != window[x][y]) // If any value is different
      {
        tileMoved = true; // Set move to true and allow a new turn
        break;
      }
      if (tileMoved) 
      {
        break; // Then go out of the loop
      }
    }
  }

  if (tileMoved) 
  {
    isRunning = true; // Making a new turn initiate
    tileMoved = false; // Resetting the variable
  }
  if (isRunning) // If the game is still running
  {
    generateBackground(); // Reset the background
    drawSquares(256); // Draw the inner squares
    generateNew(1); // And generate 1 new number.
  }
}

boolean isGameOver() 
{
  /* 
   *  Boolean function to check if the game is over.
   *  Checks specifically, if any of the arrays values, and the values after them are still 0
   *  If yes, return false, else true.
   */
  for (int x=0; x<4; x++) // Loop for 4*4 grid
  {
    for (int y=0; y<3; y++) 
    {
      if ( window[x][y]==0 || window[y][x]==0 || window[x][y+1]==0 || window[y+1][x]==0 || window[x][y]==window[x][y+1] || window[y][x]==window[y+1][x]) return false; // The game is not over, since values have changed or still can change.
    }
  }
  return true; // No values have changed or can change, the game is over.
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
