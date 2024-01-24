import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flip_card/flip_card.dart';
import 'package:meditation/game/memorygame/card.dart';
import 'package:meditation/pages/mindGame.dart';


class FlipCardGane extends StatefulWidget {
  final Level _level;

  FlipCardGane(this._level);
  @override
  _FlipCardGaneState createState() => _FlipCardGaneState(_level);
}

class _FlipCardGaneState extends State<FlipCardGane> {
  _FlipCardGaneState(this._level);

  int _previousIndex = -1;
  bool _flip = false;
  bool _start = true;
  bool _wait = false;
  Level _level;
  // ignore: unused_field
  var _left;
  late bool _isFinished;
  var _data;
  late List<bool> _cardFlips;
  late List<GlobalKey<FlipCardState>> _cardStateKeys;

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[100],
          boxShadow: const [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 3,
              spreadRadius: 0.8,
              offset: Offset(2.0, 1),
            )
          ],
          borderRadius: BorderRadius.circular(5)),
      margin: const EdgeInsets.all(4.0),
      child: Image.asset(_data[index]),
    );
  }


  void restart() {
    _data = getSourceArray(
      _level,
    );
    _cardFlips = getInitialItemState(_level);
    _cardStateKeys = getCardStateKeys(_level);
    _left = (_data.length ~/ 3); //number of pair 6/3=2
    _isFinished = false;
    if (mounted)
      setState(() {
        _start = true;
      });
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return _isFinished
        ? Scaffold(
            backgroundColor: Color(0xFFCBCFFF),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('images/win.png',),
                      width: 200,
                      height: 200,
                    )
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    if (mounted)
                      setState(() {
                        restart();
                      });
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFF8E97FD),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      //replay buton
                      "Replay",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                GestureDetector(
                  onTap: () {
                   Navigator.pushNamed(context, mindGame.id);
                  },
                  child: Container(
                    height: 50,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Text(
                      //replay buton
                      "Back",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ))
        : Scaffold(
            backgroundColor: Colors.indigo[50],
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Align(
                      alignment:Alignment(-1,-1) ,
                      child: IconButton(
                          onPressed: (){
                            Navigator.pushNamed(context, mindGame.id);
                          }, icon:Icon(Icons.close,size: 30,)),
                    ),
                    Text(
                      'MEMORY GAME',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Flip cards and find matching pair!',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Alegreya',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount( //control number of column
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) =>
                      _start ? FlipCard( // if _start = true, create flip card
                              key: _cardStateKeys[index],
                              onFlip: () {
                                if (!_flip) {  //flip=false
                                  _flip = true;
                                  _previousIndex = index;
                                  print("first index: $_previousIndex");
                                } else { //flip =true
                                  _flip = false;
                                  if (_previousIndex != index) {
                                    if (_data[_previousIndex] != _data[index]) {
                                      _wait = true; //Set _wait to true to prevent further card flipping
                                      Future.delayed(
                                          const Duration(milliseconds: 1500),
                                          () {
                                        _cardStateKeys[_previousIndex]
                                            .currentState
                                            ?.toggleCard(); 
                                        _previousIndex = index;
                                        print("second index: $_previousIndex");
                                        _cardStateKeys[_previousIndex]
                                            .currentState
                                            ?.toggleCard();
                                        Future.delayed(
                                            const Duration(milliseconds: 160),
                                            () {
                                          if (mounted)
                                            setState(() {
                                              _wait = false;
                                            });
                                        });
                                      });
                                    } else {
                                      _cardFlips[_previousIndex] = false;
                                      _cardFlips[index] = false;

                                      print(_cardFlips);
                                      if (mounted)
                                        setState(() {
                                          _left -= 1; //2-1=1 
                                        });

                                      if (_cardFlips.every((t) => t == false)) {
                                        print("Won");
                                        Future.delayed(
                                            const Duration(milliseconds: 160),
                                            () {
                                          if (mounted)
                                            setState(() {
                                              _isFinished = true;
                                              _start = false;
                                            });
                                        });
                                      }
                                    }
                                  }
                                }
                                if (mounted) setState(() {});
                              },
                              flipOnTouch: _wait ? false : _cardFlips[index], //_wait is true fliponTouch set to false, else set the flipontouch to the index
                              direction: FlipDirection.HORIZONTAL,
                              front: Container(
                                decoration: BoxDecoration(
                                    color: Colors.indigo[300],
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        spreadRadius: 0.8,
                                        offset: Offset(2.0, 1),
                                      )
                                    ]),
                                margin: const EdgeInsets.all(4.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "images/soru.jpg",
                                  ),
                                ),
                              ),
                              back: getItem(index)
                      )
                          : getItem(index),
                      itemCount: _data.length,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
