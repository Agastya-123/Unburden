import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

List<String> fillSourceArray() {
  return [
    'assets/animalspics/1.png',
    'assets/animalspics/1.png',
    'assets/animalspics/2.png',
    'assets/animalspics/2.png',
    'assets/animalspics/3.png',
    'assets/animalspics/3.png',
    'assets/animalspics/4.png',
    'assets/animalspics/4.png',
    'assets/animalspics/5.png',
    'assets/animalspics/5.png',
    'assets/animalspics/6.png',
    'assets/animalspics/6.png',
    'assets/animalspics/7.png',
    'assets/animalspics/7.png',
    'assets/animalspics/8.png',
    'assets/animalspics/8.png',
    'assets/animalspics/9.png',
    'assets/animalspics/9.png',
  ];
}

List getSourceArray(String level) {
  List<String> levelAndKindList = [];
  List sourceArray = fillSourceArray();
  if (level == "hard") {
    for (int i = 0; i < 18; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  } else if (level == "medium") {
    for (int i = 0; i < 12; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  } else if (level == "easy") {
    for (int i = 0; i < 6; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  }
  levelAndKindList.shuffle();
  return levelAndKindList;
}

List<bool> getInitialItemState(String level) {
  List<bool> initialItemState = [];
  if (level == "hard") {
    for (int i = 0; i < 18; i++) {
      initialItemState.add(true);
    }
  } else if (level == "medium") {
    for (int i = 0; i < 12; i++) {
      initialItemState.add(true);
    }
  } else if (level == "easy") {
    for (int i = 0; i < 6; i++) {
      initialItemState.add(true);
    }
  }
  return initialItemState;
}

List<GlobalKey<FlipCardState>> getCardStateKeys(String level) {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  if (level =="hard") {
    for (int i = 0; i < 18; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level =="medium") {
    for (int i = 0; i < 12; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == "easy") {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }
  return cardStateKeys;
}
