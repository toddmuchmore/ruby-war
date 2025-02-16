# What is this?

I have recently been playing the card game "War" with my kids and the games never end because they take so long. I thought it would be interesting to create a Ruby script that would take inputs for the players and number of games to play and output some stats about the games.

I started look into this and then realized that this might be a perfect use for Cursor.

I created the `rules.md` file and then asked it to generate the game based on that. It works pretty well!

The below is what Cursor generated for this projects readme.

---


# Ruby War Card Game

A command-line implementation of the classic card game "War".

## Description

This is a command-line version of the classic card game "War". Two players compete by playing cards, with the higher card winning all cards in play. The game continues until one player has collected all the cards.

## How to Play

1. Make sure you have Ruby installed on your system
2. Clone this repository
3. Make the game file executable:
   ```bash
   chmod +x war.rb
   ```
4. Run the game:
   ```bash
   ./war.rb
   ```
5. Follow the prompts to enter the players' names

## Game Rules

- The deck is divided equally between two players
- Each round, both players flip one card face-up
- The player with the higher card wins and collects all cards in play
- Card ranking from highest to lowest: A K Q J 10 9 8 7 6 5 4 3 2

### War Rules
When players flip matching cards, they go to "War":
1. Each player places 3 cards face down
2. Each player flips a 4th card face up
3. The player with the higher 4th card wins all cards in play
4. If the 4th cards match, another war begins
5. If a player doesn't have enough cards for war (4 cards), they lose the game

### Winning
- The game ends when one player has collected all the cards
- The game tracks and displays the total number of rounds played 