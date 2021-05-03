class WinningHistoryResponseData {
  int pkHistoryid;
  String gametime;
  String betNo;
  String betamount;
  String gametype;
  String gamestatus;
  String balance;

  WinningHistoryResponseData(
      {this.pkHistoryid,
      this.gametime,
      this.betNo,
      this.betamount,
      this.gametype,
      this.gamestatus,
      this.balance});

  WinningHistoryResponseData.fromJson(Map<String, dynamic> json) {
    pkHistoryid = json['pk_Historyid'];
    gametime = json['gametime'];
    betNo = json['betNo'];
    betamount = json['betamount'];
    gametype = json['gametype'];
    gamestatus = json['gamestatus'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_Historyid'] = this.pkHistoryid;
    data['gametime'] = this.gametime;
    data['betNo'] = this.betNo;
    data['betamount'] = this.betamount;
    data['gametype'] = this.gametype;
    data['gamestatus'] = this.gamestatus;
    data['balance'] = this.balance;
    return data;
  }
}
