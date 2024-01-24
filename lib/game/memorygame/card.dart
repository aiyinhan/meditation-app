import 'package:flutter/cupertino.dart';
import 'package:flip_card/flip_card.dart';

enum Level {
  Easy,
  Hard
}

List<String> fillSourceArray() {
  return [
    'gameImage/circle.png',
    'gameImage/circle.png',
    'gameImage/star.png',
    'gameImage/star.png',
    'gameImage/heart.png',
    'gameImage/heart.png',
    'gameImage/triangle.png',
    'gameImage/triangle.png',
  ];
}

List<String> HardsourceArray() {
  return [
    'gameImage/circle.png',
    'gameImage/circle.png',
    'gameImage/star.png',
    'gameImage/star.png',
    'gameImage/heart.png',
    'gameImage/heart.png',
    'gameImage/triangle.png',
    'gameImage/triangle.png',
  ];
}

List getSourceArray(
    Level level,
    ) {
  List<String> levelAndKindList = <String>[];
  List sourceArray = fillSourceArray();
  if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  } else if (level == Level.Hard) {
    List sourceArray = HardsourceArray();
    for (int i = 0; i < 8; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  }

  levelAndKindList.shuffle();
  return levelAndKindList;
}

//add true to all item, the card is facing up
List<bool> getInitialItemState(Level level) {
  List<bool> initialItemState = <bool>[];
  if (level == Level.Easy) {
    for (int i = 0; i <6; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.Hard) {
    for (int i = 0; i < 8; i++) {
      initialItemState.add(true);
    }
  }
  return initialItemState;
}

List<GlobalKey<FlipCardState>> getCardStateKeys(Level level) {
  List<GlobalKey<FlipCardState>> cardStateKeys =
  <GlobalKey<FlipCardState>>[]; //store key for managing state of each flipcard

  if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }print(cardStateKeys);
  } else if (level == Level.Hard) {
    for (int i = 0; i < 8; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
    print(cardStateKeys);
  }
  return cardStateKeys;
}