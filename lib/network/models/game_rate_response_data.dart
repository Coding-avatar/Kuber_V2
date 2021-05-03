class GameRateResponseData {
  String minbetamount;
  String gametype;
  String bhouAmt;
  String gameName;

  GameRateResponseData(
      {this.minbetamount, this.gametype, this.bhouAmt, this.gameName});

  GameRateResponseData.fromJson(Map<String, dynamic> json) {
    minbetamount = json['minbetamount'];
    gametype = json['gametype'];
    bhouAmt = json['bhouAmt'];
    gameName = json['gameName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minbetamount'] = this.minbetamount;
    data['gametype'] = this.gametype;
    data['bhouAmt'] = this.bhouAmt;
    data['gameName'] = this.gameName;
    return data;
  }
}
