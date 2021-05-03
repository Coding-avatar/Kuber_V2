class GameListData {
  int pkGameId;
  String gamename;
  String typeOfGame;

  GameListData({this.pkGameId, this.gamename, this.typeOfGame});

  GameListData.fromJson(Map<String, dynamic> json) {
    pkGameId = json['pk_GameId'];
    gamename = json['gamename'];
    typeOfGame = json['typeOfGame'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_GameId'] = this.pkGameId;
    data['gamename'] = this.gamename;
    data['typeOfGame'] = this.typeOfGame;
    return data;
  }
}
