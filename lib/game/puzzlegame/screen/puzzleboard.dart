import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meditation/pages/mindGame.dart';
import '../PuzzleShape/shapes.dart';
import '../logic/logicPuzzle.dart';
import '../pixel.dart';

// The gameBoard is a 2D list that represents the game grid.
// a non empty space will have the color to represent the landing piece

class GameBoard extends StatefulWidget {
  static String id = "GameBoard";
  const GameBoard({Key? key}) : super(key: key);
  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Timer? _gameLoopTimer;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    currentPiece.intializePiece();
    gameLoop();
  }

  void gameLoop() {
    if (_gameLoopTimer != null) {
      _gameLoopTimer?.cancel();
    }

    _gameLoopTimer = Timer.periodic(Duration(milliseconds: 900), (timer) {
      setState(() {
        //clear lines
        clearLine();
        //check landing
        checkLanding();
        // check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverMessageDialog();
        }
        //move currentPieceDown
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  void showGameOverMessageDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    10.0), // Change the border radius as desired
              ),
              title: Text(
                'GAME OVER',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              content: Container(
                width: double.minPositive, // Adjust the width as desired
                child: Text(
                  '\nYour score is : $currentScore',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              actions: [
                // to reset the game
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          resetGame();
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Play Again',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        )),
                    TextButton(
                        onPressed: () {
                          resetGame();
                          Navigator.pushNamed(context, mindGame.id);
                        },
                        child: Text(
                          'Back',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 20),
                        )),
                  ],
                )
              ],
            ));
  }

  void resetGame() {
    gameBoard = List.generate(
        columnLength,
        (i) => List.generate(
              rowLength,
              (j) => null,
            ));
    // new game
    currentScore = 0;
    gameOver = false;

    createNewPiece();
    startGame();
  }

  // move piece
  void moveLeft() {
    //make sure the piece of valid before moving
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    //make sure the piece of valid before moving
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  void dispose(){
    super.dispose();
    _gameLoopTimer?.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Puzzle'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
           child: Column(
          //alignment: Alignment.bottomCenter,
            children: [
             GridView.builder(
                shrinkWrap: true,
                itemCount: rowLength * columnLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.2, crossAxisCount: rowLength),
                itemBuilder: (context, index) {
                  //get row and column for each piece
                  int row = (index / rowLength).floor();
                  int column = index % rowLength;

                  if (currentPiece.position.contains(index)) {
                    return Pixels(
                      color: currentPiece.color,
                    );
                  } else if (gameBoard[row][column] != null) {
                    TetrominoShapes? tetrominoShape = gameBoard[row][column];
                    return Pixels(
                      color: tetrominoColor[tetrominoShape],
                    );
                  }
                  //landed pieces
                  else {
                    return Pixels(
                      color: Colors.grey[900],
                    );
                  }
                }),
            // GAME SCORE
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  'Score : $currentScore',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              // GAME CONTROL
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //left
                  IconButton(
                      onPressed: moveLeft,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 40,
                      )),
                  //rotate
                  IconButton(
                      onPressed: rotatePiece,
                      icon: Icon(
                        Icons.rotate_right_rounded,
                        color: Colors.white,
                        size: 40,
                      )),
                  //right
                  IconButton(
                      onPressed: moveRight,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 40,
                      )),
                ],
              )
            ]),
          ],
        ),
      )),
    );
  }
}
