import 'dart:math';
import 'package:meditation/game/puzzlegame/PuzzleShape/shapes.dart';
import '../PuzzleShape/pieces.dart';

//create game board
List<List<TetrominoShapes?>> gameBoard = List.generate(
    columnLength,
    (i) => List.generate(
          rowLength,
          (j) => null,
        ));

Piece currentPiece = Piece(type: TetrominoShapes.L);

int currentScore = 0;
bool gameOver = false;

bool checkCollision(Direction direction) {
  //loop through each position of the current piece
  for (int i = 0; i < currentPiece.position.length; i++) {
    //calculate the row and column of current position
    int row = (currentPiece.position[i] / rowLength).floor(); 
    int column = currentPiece.position[i] % rowLength;
    // adjust row and column based on the direction
    if (direction == Direction.left) {
      column -= 1;
    } else if (direction == Direction.right) {
      column += 1;
    } else if (direction == Direction.down) {
      row += 1;
    }
    //check if the piece is out of bounds
    if (row >= columnLength || column < 0 || column >= rowLength) {
      return true; //collision, puzzle cannot move in that direction
    }
  }
  return false; //no collision
}

void checkLanding() {
  //if going down is occupied
  if (checkCollision(Direction.down) || checkLanded()) {
    // mark position as occupied in the game board
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calculate the row and column of current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int column = currentPiece.position[i] % rowLength;
      if (row >= 0 && column >= 0) { //wtihin bounds of the gameboard
        gameBoard[row][column] = currentPiece.type;
      }
    }
    // once landed, create the next piece
    createNewPiece();
  }
}

bool checkLanded() {
  // loop through each position of the current piece
  for (int i = 0; i < currentPiece.position.length; i++) {
    int row = (currentPiece.position[i] / rowLength).floor(); //check current piece de location in the game board
    int col = currentPiece.position[i] % rowLength;
    if (row + 1 < columnLength && row >= 0 && gameBoard[row + 1][col] != null) {  //It checks if the cell below the current piece is within the game board bounds (row + 1 < columnLength), and if the current piece is not at the bottom row (row >= 0).
//If the condition is true, and the cell below is occupied (gameBoard[row + 1][col] != null), it indicates a collision with a landed piece, and the function returns true.
      return true; // collision with a landed piece
    }
  }

  return false; // no collision with landed pieces
}

// clear line
void clearLine() {
  // 1) loop through each row of game board from the bottom to the top
  for (int row = columnLength - 1; row >= 0; row--) {
    // 2) initialize variable to track if row is full
    bool rowIsFull = true;
    // 3) check if the row is full ( all columns in the row are filled with pieces )
    for (int col = 0; col < rowLength; col++) {
      // if there is an empty column, set rowIsFull is false and break the loop
      if (gameBoard[row][col] == null) {
        rowIsFull = false;
        break;
      }
    }
    // 4) if row is full, clear the row and shift rows down
    if (rowIsFull) {
      // 5) move all rows above the cleared row down by one position
      for (int r = row; r > 0; r--) {
        // copy the above row to the current row
        gameBoard[r] = List.from(gameBoard[r - 1]);
      }
      // 6) set the top row to empty
      gameBoard[0] = List.generate(row, (index) => null);
      // 7) increase the score
      currentScore++;
    }
  }
}

bool isGameOver() {
  for (int col = 0; col < rowLength; col++) {
    if (gameBoard[0][col] != null) { //gameboard[0] is first row
      return true;
    }
  }
  // if the top row is empty, the fame not over
  return false;
}

void createNewPiece() {
// create a random object to generate a random shape
  Random random = Random();
  // create  a new piece withe random type
  TetrominoShapes randomShape =
      TetrominoShapes.values[random.nextInt(TetrominoShapes.values.length)];
  currentPiece = Piece(type: randomShape);
  currentPiece.intializePiece();

  if (isGameOver()) {
    gameOver = true;
  }
}
