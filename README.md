# 2048
[![Processing Build & Export](https://github.com/InklingSplasher/2048/actions/workflows/build-and-export.yml/badge.svg)](https://github.com/InklingSplasher/2048/actions/workflows/build-and-export.yml)
<img src="/development/2048-Bright.png" alt="2048 Bright" width="320" height="380" align="right">

## Computer Science Project 2021
Programmed by Lukas Klärchen & Jan Klotz

## Features
* Full-featured 2048-game.
* Soundtrack & Sounds (can toggle)
* Darkmode
* Score & Saved Highscore
* Easily programmed to understand easily.
* Cheat- / Easy-Mode

## Installing
### With Processing installed:
Just download the archive, extract, open the main/main.pde with Processing and install the Sound library under "Add tools".
### Without Processing installed:
#### Latest Release:
Download the latest software from the releases page corresponding to your OS and just run the executable.
#### Latest (Unstable) Build:
Go into the [Actions](https://github.com/InklingSplasher/2048/actions/workflows/build-and-export.yml) tab, go to the latest run and download your corresponding artifact (Linux/Windows).

## How to Play
### Playing
The goal of 2048 is to merge same powers of 2 to higher and higher numbers until you are able to merge 2 numbers into 2048.
You can move all numbers to how far they can go by using the arrow keys, WASD or just clicking the mouse at N E S W.
The game is over when the 4\*4 tile is full and no number can move any further.
### Cheat Mode
The Cheat Mode is like an easy mode for just trying out the game. Your highscore won't be saved and you are able to click on specific tiles to delete the numbers in them for an always-ongoing game.

## To-Do
Sorted from top (important) to bottom (not/less important)

* - [x] Fix square values
    1. Fix value coords
    2. Fix Switch/Case
    3. Bug: Sometimes it's not doing anything and overwriting an existing tile. (rarely)
* - [x] Add Merge Mechanics
    1. Fix old numbers not disappearing
    2. Fix numbers disappearing when using for example right at the complete right.
    3. Proper movement, checking for numbers in front
    4. Merging
    5. Bug: Number a skips to the last tile even though there are numbers in between.
    6. Bug: Sometimes the array is partially reset.
* - [x] Add Score
* - [x] Add reset and stop actions (press 'r' / press 's')
* - [x] Animations
* - [x] Startscreen
* - [x] "Game Completed" / Game Over Status
* - [x] Option for score to be continued (Endless mode)
* - [x] Easter Eggs?
* - [x] -> Dark Mode (game completed?)
* - [x] Game Sounds

## References
Icons made by [Freepik](https://www.freepik.com) from [Flaticon](https://www.flaticon.com/)
