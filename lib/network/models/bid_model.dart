class BidModel {
  String date;
  String gameTime;
  String gameId;
  String gametype;
  String betamount;
  String betpoints;
  String finalAmount;

  BidModel(
      {this.date,
      this.gameTime,
      this.gameId,
      this.gametype,
      this.betamount,
      this.betpoints,
      this.finalAmount});

  BidModel.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    gameTime = json['GameTime'];
    gameId = json['GameId'];
    gametype = json['Gametype'];
    betamount = json['Betamount'];
    betpoints = json['Betpoints'];
    finalAmount = json['FinalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['GameTime'] = this.gameTime;
    data['GameId'] = this.gameId;
    data['Gametype'] = this.gametype;
    data['Betamount'] = this.betamount;
    data['Betpoints'] = this.betpoints;
    data['FinalAmount'] = this.finalAmount;
    return data;
  }
}
