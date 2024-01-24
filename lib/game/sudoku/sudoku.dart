import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meditation/game/sudoku/BlockChar.dart';
import 'package:meditation/pages/mindGame.dart';
import 'package:quiver/iterables.dart';
import 'package:sudoku_solver_generator/sudoku_solver_generator.dart';

import 'boxInner.dart';
import 'focusClass.dart';

enum DifficultyLevel {
  easy,
  medium,
  hard,
}

class sudoku extends StatefulWidget {
  final DifficultyLevel difficultyLevel;

  sudoku({
    required this.difficultyLevel,
  });

  static String id = "sudoku";

  @override
  State<sudoku> createState() => _sudokuState();
}

class _sudokuState extends State<sudoku> {
  List<BoxInner> boxInners = [];
  FocusClass focusClass = FocusClass();
  bool isFinish = false;
  String? tapBoxIndex;
  late DifficultyLevel difficultyLevel;

  @override
  void initState() {
    difficultyLevel = widget.difficultyLevel;
    generateSudoku(difficultyLevel);
    super.initState();
  }


  void generateSudoku(DifficultyLevel level) {
    isFinish = false;
    focusClass = new FocusClass(); //track focused box
    tapBoxIndex = null;
    int emptySquares;
    switch (level) {
      case DifficultyLevel.easy:
        emptySquares = 10;
        break;
      case DifficultyLevel.medium:
        emptySquares = 20;
        break;
      case DifficultyLevel.hard:
        emptySquares = 25;
        break;
    }

    generatePuzzle(emptySquares);
    checkFinish();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // lets put on ui

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, mindGame.id);
                  },
                  icon: Icon(Icons.close_sharp)),
              IconButton(
                  onPressed: () {
                    generateSudoku(difficultyLevel);
                  },
                  icon: Icon(Icons.refresh)),
            ],
          ),
        ],
        backgroundColor: Color(0xFF8E97FD),
      ),
      backgroundColor: Color(0xFFCBCFFF),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(20),
                // height: 400,
                color: Colors.grey,
                padding: EdgeInsets.all(5),
                width: double.maxFinite,
                alignment: Alignment.center,
                child: GridView.builder(
                  itemCount: boxInners.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                  ),
                  physics: ScrollPhysics(),
                  itemBuilder: (buildContext, index) {
                    BoxInner boxInner = boxInners[index];

                    return Container(
                      //color: Colors.red.shade100,
                      alignment: Alignment.center,
                      child: GridView.builder(
                        itemCount: boxInner.blokChars.length,
                        //shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        physics: ScrollPhysics(),
                        itemBuilder: (buildContext, indexChar) {
                          BlokChar blokChar = boxInner.blokChars[indexChar];
                          Color? color = Colors.yellow.shade100; //
                          Color colorText = Colors.black;

                          if (isFinish)
                            color = Colors.green;
                          else if (blokChar.isFocus && blokChar.text != "")
                            color = Colors.brown.shade100;
                          else if (blokChar.isDefault) color = Colors.white;

                          if (tapBoxIndex == "${index}-${indexChar}" && //row and coloumn
                              !isFinish) color = Colors.blue.shade100;

                          if (this.isFinish)
                            colorText = Colors.white;
                          else if (blokChar.isExist) colorText = Colors.red;

                          return Container(
                            color: color,
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: blokChar.isDefault
                                  ? null
                                  : () => setFocus(index, indexChar),
                              child: Text(
                                "${blokChar.text}",
                                style: TextStyle(color: colorText),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        flex: 9,
                        child: GridView.builder(
                          itemCount: 9,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          physics: ScrollPhysics(),
                          itemBuilder: (buildContext, index) {
                            int row = index ~/ 3;
                            int col = index % 3;
                            int number = row + col * 3 + 1; //row 0 col 0, row 0 col 1
                            return ElevatedButton(
                              onPressed: (
                              ) => setInput(number), //set number
                              child: Text(
                                "$number",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 25),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            );
                          },
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () => setInput(null),
                            child: Container(
                              child: Text(
                                "Clear",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  generatePuzzle(emptySquares) {
    // install plugins sudoku generator to generate one
    boxInners.clear();
    var sudokuGenerator = SudokuGenerator(emptySquares: emptySquares); //54
    List<List<List<int>>> completes = partition(sudokuGenerator.newSudokuSolved,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList(); //partition the completed sudoku puzzle into smaller 3x3
    partition(sudokuGenerator.newSudoku,
            sqrt(sudokuGenerator.newSudoku.length).toInt())
        .toList()
        .asMap()
        .entries
        .forEach(
      (entry) {
        List<int> tempListCompletes =
            completes[entry.key].expand((element) => element).toList();// list of number of completed sudoku
        List<int> tempList = entry.value.expand((element) => element).toList();  //initial puzzle

        tempList.asMap().entries.forEach((entryIn) {
          int index =
              entry.key * sqrt(sudokuGenerator.newSudoku.length).toInt() +
                  (entryIn.key % 9).toInt() ~/ 3;//entry.key is row, entryIn.key is column

          if (boxInners.where((element) => element.index == index).length ==
              0) { //no existing boxInner objects in specific index, the length =0
            boxInners.add(BoxInner(index, []));  //create one
          }
          BoxInner boxInner =
              boxInners.where((element) => element.index == index).first;
          boxInner.blokChars.add(BlokChar(
            entryIn.value == 0 ? "" : entryIn.value.toString(), //set the prefilled number and empty space
            index: boxInner.blokChars.length,
            isDefault: entryIn.value != 0,
            isCorrect: entryIn.value != 0,
            correctText: tempListCompletes[entryIn.key].toString(),
          ));
        });
      },
    );
  }

  setFocus(int index, int indexChar) {
    tapBoxIndex = "$index-$indexChar";
    focusClass.setData(index, indexChar);
    showFocusCenterLine();
    setState(() {});
  }

  void showFocusCenterLine() {
    // set focus color for line vertical & horizontal
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;
    this.boxInners.forEach((element) => element.clearFocus());
    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach( //calculate 0-8/3  
        (e) => e.setFocus(focusClass.indexChar!, Direction.Horizontal)); //row
    boxInners
        .where((element) => element.index % 3 == colNoBox)
        .forEach((e) => e.setFocus(focusClass.indexChar!, Direction.Vertical)); //column
  }

  setInput(int? number) {
    // set input data based grid
    // or clear out data
    if (focusClass.indexBox == null) return;
    if (boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text ==
            number.toString() ||
        number == null) {
      boxInners.forEach((element) {
        element.clearFocus();
        element.clearExist();
      });
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setEmpty(); //number is null, user clear input
      tapBoxIndex = null;
      isFinish = false;
      showSameInputOnSameLine();
    } else {
      boxInners[focusClass.indexBox!]
          .blokChars[focusClass.indexChar!]
          .setText("$number");

      showSameInputOnSameLine();

      checkFinish();
    }

    setState(() {});
  }

  void showSameInputOnSameLine() {
    // show duplicate number on same line vertical & horizontal so player know he or she put a wrong value on somewhere
    int rowNoBox = focusClass.indexBox! ~/ 3;
    int colNoBox = focusClass.indexBox! % 3;
    String textInput =
        boxInners[focusClass.indexBox!].blokChars[focusClass.indexChar!].text!;

    boxInners.forEach((element) => element.clearExist());

    boxInners.where((element) => element.index ~/ 3 == rowNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Horizontal));

    boxInners.where((element) => element.index % 3 == colNoBox).forEach((e) =>
        e.setExistValue(focusClass.indexChar!, focusClass.indexBox!, textInput,
            Direction.Vertical));
    List<BlokChar> exists = boxInners
        .map((element) => element.blokChars)
        .expand((element) => element)
        .where((element) => element.isExist)
        .toList();
    if (exists.length == 1) exists[0].isExist = false;
  }

  void checkFinish() {
    int totalUnfinish = boxInners
        .map((e) => e.blokChars)
        .expand((element) => element)
        .where((element) => !element.isCorrect)
        .length;

    isFinish = totalUnfinish == 0;
  }
}
