// Global Variables
int[][] window = new int[4][4]; // 4*4 Array for all coordinates of the grid.
int[][] c; // Colors
int score = 0; // Initial Score = 0
int gamestate = 0;
boolean tileMoved = false; // Has any tile moved?
boolean isRunning = true; // Can a new turn start?
boolean GameOver = false; // Is the game over?
boolean endless = false; // Is endless mode enabled?
boolean darkmode = false; // Is darkmode enabled?
PFont font; // Custom fonts
PFont headline;
PShape sun;
PShape moon;

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
	sun = loadShape("sun.svg");
	moon = loadShape("moon.svg");
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

	selectColors();
	generateNew((int) random(1, 2.99)); // Generate 1 or 2 new numbers at the start of the game.
	generateBackground(); // Generate the background
}

void draw()
{
	/*
	 * Check if drawing is still enabled
	 * Check if the game is over
	 */

	selectColors();
	drawButtons();
	switch(gamestate)
	{
		case 0:
			{
				// Startscreen
				// println(mouseX, mouseY);
				rectMode(CENTER);
				fill(c[0][0], c[0][1], c[0][2], 12);
				rect(width/2, height/2+40, 600, 600, 10, 10, 10, 10);

				textFont(headline);
				textAlign(CENTER);
				fill(c[1][0], c[1][1], c[1][2]);
				textSize(48);
				text("Welcome", width/2, height/2-165);

				fill(c[2][0], c[2][1], c[2][2], 12);
				textSize(32);
				text("Thanks for choosing to play \nour game, the simple 2048 classic! \nYou win when a tile reaches '2048'\n\nYou can move with:\nArrow Keys / WASD / Mouse", width/2, height/2-95);
				break;
			}
		case 1:
			{
				if (!GameOver && isRunning) // If the game is not over and drawing i
				{
					drawSquares(12); // Draw squares with the specific alpha value
				}

				if (GameOver) // If the game is over
				{
					isRunning = false; // Disable Drawing

					rectMode(CENTER);
					fill(c[0][0], c[0][1], c[0][2], 12);
					rect(width/2, height/2+40, 520, 520, 10, 10, 10, 10);

					textFont(headline);
					textAlign(CENTER);
					fill(c[4][0], c[4][1], c[4][2], 36);
					textSize(48);
					text("Game Over", width/2, height/2+10);

					fill(c[2][0], c[2][1], c[2][2], 12);
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
	if (gamestate == 0 && (mouseX >= 160 && mouseX <= 515 && mouseY >= 645 && mouseY <= 745))
	{
		gamestate=1;
		generateBackground();
	}
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
		} else
		{
			// Match mouse coordinates with specifc pressed key codes.
			if (mouseX < width / 4) keyCode = LEFT;
			if (mouseX > width * 3 / 4) keyCode = RIGHT;
			if (mouseY < 240) keyCode = UP;
			if (mouseY > height * 3 / 4) keyCode = DOWN;
			if (keyCode>0) move(); // If it was set correctly, go on to the move() function.
		}
	}
	if (mouseX >= 790 && mouseX <= 830 && mouseY >= 65 && mouseY <= 110)
	{
		println("Goodbye!");
		exit(); // Exit the program
	}
	if (gamestate == 0 && (mouseX >= 560 && mouseX <= 685 && mouseY >= 650 && mouseY <= 755))
	{
		darkmode = !darkmode;
		selectColors();
		generateBackground();
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

	background(c[0][0], c[0][1], c[0][2]); // White background
	if(gamestate==1) drawButtons();

	textFont(headline);
	textAlign(CENTER); // Text alignment in the center
	fill(c[1][0], c[1][1], c[1][2]); // Light blue
	textSize(66);
	text("2048", 100, 90); // Headline "2048"

	textAlign(CENTER, CENTER); // Align text at the top left
	textSize(30);
	if (endless) fill(c[4][0], c[4][1], c[4][2]);
	text("Score: " + score, width/2, 65); // Score Headline

	textFont(font);
	fill(c[1][0], c[1][1], c[1][2]);
	rectMode(CENTER); // Align rectangles at the center
	rect(435, 535, 820, 820, 10, 10, 10, 10); // Outer rectangle

	textFont(headline);
	fill(c[2][0], c[2][1], c[2][2]);
	textSize(10);
	text("press r to reset", 80, 960);

	for (int x=0; x<4; x++) // Loop for 4*4 grid
	{
		for (int y=0; y<4; y++)
		{
			fill(c[3][0], c[3][1], c[3][2]); // Dark blue
			rect(140+195*x, 240+195*y, 160, 160, 20); // Empty squares
		}
	}

	noStroke();
	textFont(headline);
	textAlign(CENTER);
	fill(c[2][0], c[2][1], c[2][2]);
	textSize(20);
	text("Endless mode", 710, 47);
	text("Stop the game", 705, 97);
	textAlign(CENTER, CENTER);
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
				fill(c[2][0], c[2][1], c[2][2]); // Black
				textSize(48);
				textAlign(CENTER, CENTER); // Align text at the center of the screen
				text(window[x][y], 140+195*x, 240+195*y); // Set the number at the specific position
			}
		}
	}
}

void drawButtons()
{
	if (endless || mouseX >= 790 && mouseX <= 830 && mouseY >= 10 && mouseY <= 60) fill(c[2][0], c[2][1], c[2][2]);
	else fill(c[0][0], c[0][1], c[0][2]);
	rect(810, 40, 40, 40, 10);

	if (mouseX >= 790 && mouseX <= 830 && mouseY >= 65 && mouseY <= 110) fill(c[2][0], c[2][1], c[2][2]);
	else fill(c[0][0], c[0][1], c[0][2]);

	rect(810, 90, 40, 40, 10);
	if (gamestate == 0 && (mouseX >= 560 && mouseX <= 685 && mouseY >= 650 && mouseY <= 755)) fill(c[2][0], c[2][1], c[2][2]);
	else
		fill(c[0][0], c[0][1], c[0][2]);

	if (gamestate==0) rect(625, 705, 120, 100, 10);

	if (gamestate == 0 && (mouseX >= 160 && mouseX <= 515 && mouseY >= 650 && mouseY <= 755)) fill(c[2][0], c[2][1], c[2][2]);
	else fill(c[0][0], c[0][1], c[0][2]);

	if (gamestate==0)
	{
		rect(340, 705, 350, 100, 10);
		if ((mouseX >= 160 && mouseX <= 515 && mouseY >= 645 && mouseY <= 745)) fill(c[0][0], c[0][1], c[0][2]);
		else fill(c[2][0], c[2][1], c[2][2]);
		text("PLAY", 335, 720);
	}

	strokeWeight(2.5);
	stroke(c[2][0], c[2][1], c[2][2]);
	fill(c[2][0], c[2][1], c[2][2], 0);
	rect(810, 40, 40, 40, 10);
	rect(810, 90, 40, 40, 10);
	if (gamestate==0)
	{
		rect(340, 705, 350, 100, 10);
		rect(625, 705, 120, 100, 10);
		if (!darkmode) shape(sun, 592, 672, 65, 65);
		if (darkmode) shape(moon, 592, 672, 65, 65);
	}
	noStroke();
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
		case UP:
		case 87: // UP/W
			{
				// Commented only UP, all following are basically programmed the same way, just in other orders.
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
		case 83: // DOWN/S
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
		case 65: // LEFT/A
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
		case 68: // RIGHT/D
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

void selectColors()
{
	if (darkmode)
	{
		// The colors used for darkmode. Always R,G,B
		// Background, Headline Text, Button Subtext...
		c = new int[][] {{0, 0, 0}, {17, 169, 216}, {255, 255, 255}, {27, 178, 223}, {231, 75, 74}};
	} else
	{
		// Default colors. Always R,G,B
		// Background (White), Headline Text (Light Blue), Button + Subtext (Black), Squares (Dark Blue), Game Over (Light Red)
		c = new int[][] {{255, 255, 255}, {19, 182, 236}, {64, 64, 64}, {0, 174, 227}, {231, 75, 74}};
	}
}

void determineColor(int x, int y)
{
	/*
	 * Simple function used to set colors depending on the number
	 * Passes the number x and the alpha value y
	 * and gets the color depending on it. TODO: Make this a one-liner
	 * 1 << 2
	 */

	if (darkmode)
	{
		switch(x)
		{
			case 2: fill(#11A9D8, y); break;
			case 4: fill(#0E9CC8, y); break;
			case 8: fill(#0A8EB7, y); break;
			case 16: fill(#0780A4, y); break;
			case 32: fill(#047294, y); break;
			case 64: fill(#006482, y); break;
			case 128: fill(#D27313, y); break;
			case 256: fill(#C95413, y); break;
			case 512: fill(#C13513, y); break;
			case 1024: fill(#B71413, y); break;
			case 2048: fill(#BF0E93, y); break;
			case 4096: fill(#A6149A, y); break;
			case 8192: fill(#8C1AA2, y); break;
			case 16384: fill(#721FAA, y); break;
			case 32768: fill(#5925B1, y); break;
			case 65536: fill(#3E2BB9, y); break;
			case 131072: fill(#2531C1, y); break;
			default: fill(#11A9D8, y); break;
		}
	} else
	{
		switch(x)
		{
			case 2: fill(#5ECAED, y); break;
			case 4: fill(#74D1F0, y); break;
			case 8: fill(#8AD9F3, y); break;
			case 16: fill(#A0E1F6, y); break;
			case 32: fill(#B8E9F9, y); break;
			case 64: fill(#CEF1FC, y); break;
			case 128: fill(#EDA761, y); break;
			case 256: fill(#EB8559, y); break;
			case 512: fill(#E96D53, y); break;
			case 1024: fill(#E74B4A, y); break;
			case 2048: fill(#E047BA, y); break;
			case 4096: fill(#CB40CB, y); break;
			case 8192: fill(#B138DF, y); break;
			case 16384: fill(#9830F2, y); break;
			case 32768: fill(#7E3BEF, y); break;
			case 65536: fill(#6247EB, y); break;
			case 131072: fill(#4852E8, y); break;
			default: fill(#5ECAED, y); break;
		}
	}
}
