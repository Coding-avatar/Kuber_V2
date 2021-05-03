import 'package:flutter/material.dart';

class PlayedGameModel {
  int index;
  int gameId;
  String gameName;
  int playedDigit;
  int pointsPlayed;
  String gameDate;
  String gameTime;
  String finalAmount;

  PlayedGameModel(
      {@required this.index,
      @required this.gameId,
      @required this.gameName,
      @required this.playedDigit,
      @required this.pointsPlayed,
      @required this.gameDate,
      @required this.gameTime,
      @required this.finalAmount});

  PlayedGameModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    gameId = json['gameId'];
    gameName = json['gameName'];
    playedDigit = json['playedDigit'];
    pointsPlayed = json['pointsPlayed'];
    gameDate = json['gameDate'];
    gameTime = json['gameTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['gameId'] = this.gameId;
    data['gameName'] = this.gameName;
    data['playedDigit'] = this.playedDigit;
    data['pointsPlayed'] = this.pointsPlayed;
    data['gameDate'] = this.gameDate;
    data['gameTime'] = this.gameTime;
    return data;
  }
}
