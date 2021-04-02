// LICENSED UNDER MIT (SEE ROOT/DATA DIRECTORY)
import processing.sound.*;

// Global Variables
int[][] window = new int[4][4]; // 4*4 Array for all coordinates of the grid.
int[][] c; // Colors
int score = 0; // Initial Score = 0
int gamestate = 0;
int highscore;
boolean tileMoved = false; // Has any tile moved?
boolean isRunning = true; // Can a new turn start?
boolean GameOver = false; // Is the game over?
boolean cheatmode = false; // Is cheatmode mode enabled?
boolean darkmode = false; // Is darkmode enabled?
boolean sound = true; // Is sound enabled?
PFont font; // Custom fonts
PFont headline;
PShape sun;
PShape moon;
PShape crown;
PShape speaker;
PShape mute;
SoundFile soundtrack;
SoundFile merge;
SoundFile select;
SoundFile deselect;
SoundFile completed;
SoundFile over;

void settings()
{
	/*
	 * Code that is only ran once when the game starts.
	 * Useful, so it doesn't repeat the soundtrack and doesn't reload
	 * the highscore everytime a player resets the game.
	 */

	size(435, 490); // Setting the size
	pixelDensity(displayDensity()); // Define the pixel size depending on the display size (HiDPI compatibility)
	soundtrack = new SoundFile(this, "soundtrack.wav"); // Load our soundtrack
	soundtrack.play(1, 0.3); // Start playing it at 1x speed and 30% volume.
	soundtrack.loop(); // Loop the track
	highScore(); // Load any previous highscore
}

void setup()
{
	/*
	 * All the code that is for the designing and mandatory frontend and backend reasons. Especially:
	 * General look
	 * Loading all external elements
	 * Resetting the array and other variables
	 * Getting the colors depending on if darkmode is enabled
	 * Generating the first number in our array
	 */

	sun = loadShape("sun.svg");
	moon = loadShape("moon.svg");
	speaker = loadShape("audio.svg");
	mute = loadShape("mute.svg");
	crown = loadShape("crown.svg");
	font = loadFont("Consolas-40.vlw");
	headline = loadFont("URWGothic-Demi-48.vlw");
	merge = new SoundFile(this, "merge.wav");
	select = new SoundFile(this, "select.wav");
	deselect = new SoundFile(this, "deselect.wav");
	completed = new SoundFile(this, "completed.wav");
	over = new SoundFile(this, "over.wav");
	textFont(font);

	if (keyCode == 82 || GameOver)
	{
		if (keyCode == 82) cheatmode = false;
		if (!cheatmode) score = 0; // Resetting the score
		gamestate = 1;
		GameOver = false;
		isRunning = true;
	}

	for (int x=0; x<4; x++) // Loop for 4*4 grid, resets all values to zero when the game starts over.
	{
		for (int y=0; y<4; y++)
		{
			window[x][y] = 0;
		}
	}

	selectColors();
	if (gamestate==1) generateNew((int) random(1, 2.99)); // Generate 1 or 2 new numbers at the start of the game.
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
		case 0: // Startscreen
			{
				rectMode(CENTER); // Inner Rectangle
				fill(c[0][0], c[0][1], c[0][2], 15);
				rect(width/2, height/2+20, 300, 300, 5);

				textFont(headline); // "Welcome"
				textAlign(CENTER);
				fill(c[1][0], c[1][1], c[1][2]);
				textSize(24);
				text("Welcome", width/2, height/2-82);

				fill(c[2][0], c[2][1], c[2][2], 12); // Subtext
				textSize(16);
				text("Thanks for choosing to play \nour game, the simple 2048 classic! \nYou win when a tile reaches '2048'\n\nYou can move with:\nArrow Keys / WASD / Mouse", width/2, height/2-47);
				break;
			}
		case 1: // Running Game
			{
				if (!GameOver && isRunning) // If the game is not over and drawing is enabled
				{
					drawSquares(12); // Draw squares with the specific alpha value
				}

				if (GameOver) gamestate = 2; // If the game is over
				break;
			}
		case 2: // Game Over
			{
				isRunning = false; // Disable Drawing

				rectMode(CENTER); // Inner Rectangle
				fill(c[0][0], c[0][1], c[0][2], 30);
				rect(width/2, height/2+20, 260, 260, 5);

				textFont(headline); // "Game Over"
				textAlign(CENTER);
				fill(c[4][0], c[4][1], c[4][2], 38);
				textSize(24);
				text("Game Over", width/2, height/2+5);

				fill(c[2][0], c[2][1], c[2][2], 32); // Subtext
				textSize(16);
				text("Click anywhere to restart!", width/2, height/2+35);
				break;
			}
		case 3: // Game Completed
			{
				rectMode(CENTER); // Inner Rectangle
				fill(c[0][0], c[0][1], c[0][2], 15);
				rect(width/2, height/2+20, 260, 260, 5);

				textFont(headline); // "Game Completed"
				textAlign(CENTER);
				fill(c[1][0], c[1][1], c[1][2], 36);
				textSize(24);
				text("Game Completed", width/2, height/2-67);

				fill(c[2][0], c[2][1], c[2][2], 12); // Subtext
				textSize(16);
				text("Congratulations!\nYou finished the game.\nCurrent score: " + score, width/2, height/2+30);
				textSize(17);
				text("Click the mouse to continue!", width/2, height/2+102);

				shape(crown, width/2-25, height/2-50, 50, 40);
				break;
			}
		default: println("Invalid gamestate " + gamestate + "! Report this to the developer!");
	}

	if (!soundtrack.isPlaying() && !GameOver && sound) soundtrack.play(); // Used to play and pause the soundtrack when it's supposed to.
	else if (soundtrack.isPlaying() && (GameOver || !sound)) soundtrack.pause();
}

void keyPressed()
{
	if (gamestate==1) move(); // If the game is running, initiate move.
}

void mousePressed()
{
	boolean buttonPressed = false; // Variable to check if any button was pressed before initiating the mouse-movement.
	if (mouseX >= 396 && mouseX <= 414 && mouseY >= 3 && mouseY <= 20) // Exit button
	{
		if (sound) select.play(1, 0.3);
		delay(50);
		println("Goodbye!");
		exit(); // Exit the program
		buttonPressed = true;
	} else if (mouseX >= 396 && mouseX <= 414 && mouseY >= 24 && mouseY <= 39 && !cheatmode) // cheatmode button
	{
		if (sound) select.play(1, 0.3);
		cheatmode = true; // Turn cheatmode mode on
		generateBackground();
		drawSquares(12);
		buttonPressed = true;
	} else if (mouseX >= 396 && mouseX <= 414 && mouseY >= 44 && mouseY <= 61) // Music button
	{
		if (sound)
		{
			select.play(1, 0.1);
			sound = false;
		} else
		{
			deselect.play(1, 0.1);
			sound = true;
		}
		buttonPressed = true;
	} else if (GameOver) // When the game is over and the mouse is pressed, restart the game.
	{
		buttonPressed = true;
		setup(); // Run the setup again and therefore reset everything.
	}

	switch(gamestate) // Buttons actions that should only be ran in a specific gamemode.
	{
		case 0: // Startscreen
			{
				if (mouseX >= 80 && mouseX <= 257 && mouseY >= 322 && mouseY <= 372) // Play Button
				{
					if (sound) select.play(1, 0.3);
					gamestate=1; // Set gamestate to running mode
					generateNew((int) random(1, 2.99)); // Generate 1 or 2 new numbers at the start of the game.
					generateBackground(); // Regenerate the background
				}
				if (mouseX >= 280 && mouseX <= 342 && mouseY >= 325 && mouseY <= 377) // Darkmode Button
				{
					if (!darkmode && sound) select.play(1, 0.3);
					else if (sound) deselect.play(1, 0.3);
					darkmode = !darkmode; // Switch the variable over
					selectColors(); // Rewrite the colors
					generateBackground(); // Regenerate the background
				}
				break;
			}
		case 1: // Running Game
			{
				if (cheatmode)
				{
					for(int x=0; x<=3; x++)
					{
						for(int y=0; y<=3; y++)
						{
							if (mouseX>=30+97*x && mouseX <= 120+97*x && mouseY>= 80+97*y && mouseY <= 160+97*y) // If the mouse is in one of the squares
							{
								window[x][y] = 0; // Use the defined square x y to reset the tile to 0
								generateBackground(); // and regenerate the background to show the changes.
							}
						}
					}
				}
				// Match mouse coordinates with specifc pressed key codes.
				else if (!buttonPressed)
				{
					if (mouseX < width / 4) keyCode = LEFT;
					if (mouseX > width * 3 / 4) keyCode = RIGHT;
					if (mouseY < 240) keyCode = UP;
					if (mouseY > height * 3 / 4) keyCode = DOWN;
					if (keyCode>0) move(); // If it was set correctly, go on to the move() function.
				}
				break;
			}
		case 3: // If the game is completed, on mouse click:
			{
				gamestate = 1; // Set the gamestate back to normal playing
				generateBackground(); // Regenerate the background
				break;
			}
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
	noStroke(); // Remove the stroke
	if (gamestate==1) drawButtons();

	textFont(headline);
	textAlign(CENTER); // Text alignment in the center
	fill(c[1][0], c[1][1], c[1][2]); // Light blue
	textSize(33);
	text("2048", 50, 45); // Headline "2048"

	textAlign(CENTER, CENTER); // Align text at the top left
	textSize(15);
	if (cheatmode) fill(c[4][0], c[4][1], c[4][2]);
	text("Score: " + score, width/2, 22); // Score Headline
	fill(c[1][0], c[1][1], c[1][2]);
	text("High Score: " + highscore, width/2, 40);

	textFont(font);
	rectMode(CENTER); // Align rectangles at the center
	rect(217, 267, 410, 410, 5); // Outer rectangle

	textFont(headline);
	fill(c[2][0], c[2][1], c[2][2]);
	textSize(8);
	text("press r to reset", 40, 480);

	for (int x=0; x<4; x++) // Loop for 4*4 grid
	{
		for (int y=0; y<4; y++)
		{
			fill(c[3][0], c[3][1], c[3][2]); // Dark blue
			rect(70+97*x, 120+97*y, 80, 80, 10); // Empty squares
		}
	}

	fill(c[2][0], c[2][1], c[2][2]);
	textSize(10);
	text("Stop the game", 355, 11);
	text("Cheat Mode", 355, 31);
	text("Sound", 355, 51);
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
				rect(70+97*x, 120+97*y, 67, 67, 5); // Set a rectangle at the specific coordinates.
				fill(c[2][0], c[2][1], c[2][2]); // Black
				textSize(24);
				textAlign(CENTER, CENTER); // Align text at the center of the screen
				text(window[x][y], 70+97*x, 120+97*y); // Set the number at the specific position
			}
		}
	}
}

void drawButtons()
{
	if (mouseX >= 396 && mouseX <= 414 && mouseY >= 3 && mouseY <= 20) fill(c[2][0], c[2][1], c[2][2]);
	else fill(c[0][0], c[0][1], c[0][2]);
	rect(405, 11, 15, 15, 5); // Exit button

	if (cheatmode || (mouseX >= 396 && mouseX <= 414 && mouseY >= 24 && mouseY <= 39)) fill(c[2][0], c[2][1], c[2][2]);
	else fill(c[0][0], c[0][1], c[0][2]);
	rect(405, 31, 15, 15, 5); // cheatmode button

	fill(c[0][0], c[0][1], c[0][2]);
	rect(405, 51, 15, 15, 5); // Music button

	if (gamestate==0) // Buttons on the startscreen
	{

		if (mouseX >= 280 && mouseX <= 342 && mouseY >= 325 && mouseY <= 377) fill(c[2][0], c[2][1], c[2][2]);
		else fill(c[0][0], c[0][1], c[0][2]);
		rect(312, 352, 60, 50, 5); // Dark mode button

		if (mouseX >= 80 && mouseX <= 257 && mouseY >= 322 && mouseY <= 372) fill(c[2][0], c[2][1], c[2][2]);
		else fill(c[0][0], c[0][1], c[0][2]);
		rect(170, 352, 175, 50, 5); // Play button

		if ((mouseX >= 80 && mouseX <= 257 && mouseY >= 322 && mouseY <= 372)) fill(c[0][0], c[0][1], c[0][2]);
		else fill(c[2][0], c[2][1], c[2][2]);
		textSize(16);
		text("PLAY", 166, 360); // "PLAY" text
	}

	strokeWeight(1.25);
	stroke(c[2][0], c[2][1], c[2][2]);
	fill(c[2][0], c[2][1], c[2][2], 0);
	rect(405, 11, 15, 15, 5); // Exit button
	rect(405, 31, 15, 15, 5); // Cheatmode button
	rect(405, 51, 15, 15, 5); // Music button

	if (sound) shape(speaker, 399, 45, 12, 12);
	else shape(mute, 399, 45, 12, 12);
	if (gamestate==0)
	{
		rect(170, 352, 175, 50, 5);
		rect(312, 352, 60, 50, 5);
		if (!darkmode) shape(sun, 296, 336, 32, 32);
		if (darkmode) shape(moon, 296, 336, 32, 32);
	}
	noStroke();
}

void move()
{
	/*
	 * Function used for all moving mechanics.
	 * Game-Over Check
	 * Moving
	 * Merging
	 */

	int oldScore = score;
	isRunning = false; // Reset the variable
	GameOver = isGameOver(); // Check if the game is over and save it into a variable to save computing power

	/*
	 * This loop is used to check if any numbers are falsely moving
	 * For this, we basically copy the old values of the array to the new one.
	 * Later on, we then check if there was any movement.
	 */
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
		case UP: case 87: // UP/W
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
								if (window[x][y] == 1024)
								{
									gamestate = 3;
									if (sound) completed.play(1, 0.8);
								}
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
		case DOWN: case 83: // DOWN/S
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
								if (window[x][y] == 1024)
								{
									gamestate = 3;
									if (sound) completed.play(1, 0.8);
								}
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
		case LEFT: case 65: // LEFT/A
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
								if (window[x][y] == 1024)
								{
									gamestate = 3;
									if (sound) completed.play(1, 0.8);
								}
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
		case RIGHT: case 68: // RIGHT/D
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
								if (window[x][y] == 1024)
								{
									gamestate = 3;
									if (sound) completed.play(1, 0.8);
								}
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
				setup();
				return;
			}
		default: println("This key is not used!", keyCode);
	}
	highScore();

	if (oldScore < score && !merge.isPlaying() && sound) merge.play(1, 0.3); // Play the merging sound when it's not currently playing and the score changed.

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
	if (GameOver && sound) // On GameOver, play the specific sound.
	{
		over.play(1, 0.3);
	}
}

void highScore()
{
	File f = dataFile("highscore.txt"); // Specify file in data directory
	String filePath = f.getPath(); // Save the path to a String
	if (f.isFile()) // If the file is present
	{
		String[] lines = loadStrings(filePath);
		int savedhighscore = Integer.parseInt(lines[0]); // Save the value into savedhighscore
		if (score > savedhighscore && !cheatmode) // Then, if the current score is higher and cheatmode is not turned on
		{
			String[] newscore = new String[1];
			newscore[0] = String.valueOf(score); // Transfer the String to an int
			saveStrings(filePath, newscore); // save it
			highscore = score; // and set the new highscore in-game.
		} else highscore = savedhighscore; // Else, just use the old highscore
	} else // Create the file if there is none
	{
		highscore = 0; // Set the highscore to 0
		String[] empty = {"0"};
		saveStrings(filePath, empty); // Save it to the file and create it.
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
		c = new int[][] {{13, 13, 13}, {39, 46, 124}, {255, 255, 255}, {29, 35, 104}, {183, 20, 10}};
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
	 * and gets the color depending on it.
	 * 1 << 2 Bitshifting :)
	 */

	if (darkmode)
	{
		switch(x)
		{
			case 1<<2: fill(#047294, y); break;
			case 1<<3: fill(#0780A4, y); break;
			case 1<<4: fill(#0A8EB7, y); break;
			case 1<<5: fill(#0E9CC8, y); break;
			case 1<<6: fill(#11A9D8, y); break;
			case 1<<7: fill(#D27313, y); break;
			case 1<<8: fill(#C95413, y); break;
			case 1<<9: fill(#C13513, y); break;
			case 1<<10: fill(#B71413, y); break;
			case 1<<11: fill(#BF0E93, y); break;
			case 1<<12: fill(#A6149A, y); break;
			case 1<<13: fill(#8C1AA2, y); break;
			case 1<<14: fill(#721FAA, y); break;
			case 1<<15: fill(#5925B1, y); break;
			case 1<<16: fill(#3E2BB9, y); break;
			case 1<<17: fill(#2531C1, y); break;
			default: fill(#006482, y); break;
		}
	} else
	{
		switch(x)
		{
			case 1<<2: fill(#74D1F0, y); break;
			case 1<<3: fill(#8AD9F3, y); break;
			case 1<<4: fill(#A0E1F6, y); break;
			case 1<<5: fill(#B8E9F9, y); break;
			case 1<<6: fill(#CEF1FC, y); break;
			case 1<<7: fill(#EDA761, y); break;
			case 1<<8: fill(#EB8559, y); break;
			case 1<<9: fill(#E96D53, y); break;
			case 1<<10: fill(#E74B4A, y); break;
			case 1<<11: fill(#E047BA, y); break;
			case 1<<12: fill(#CB40CB, y); break;
			case 1<<13: fill(#B138DF, y); break;
			case 1<<14: fill(#9830F2, y); break;
			case 1<<15: fill(#7E3BEF, y); break;
			case 1<<16: fill(#6247EB, y); break;
			case 1<<17: fill(#4852E8, y); break;
			default: fill(#5ECAED, y); break;
		}
	}
}
