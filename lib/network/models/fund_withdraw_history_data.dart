class FundWithdrawHistoryData {
  int pkUserPoint;
  String transactionAmt;
  String transactionId;
  String orderID;
  String fundstatus;
  String date;
  String time;

  FundWithdrawHistoryData(
      {this.pkUserPoint,
      this.transactionAmt,
      this.transactionId,
      this.orderID,
      this.fundstatus,
      this.date,
      this.time});

  FundWithdrawHistoryData.fromJson(Map<String, dynamic> json) {
    pkUserPoint = json['pk_UserPoint'];
    transactionAmt = json['transactionAmt'];
    transactionId = json['transactionId'];
    orderID = json['orderID'];
    fundstatus = json['fundstatus'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_UserPoint'] = this.pkUserPoint;
    data['transactionAmt'] = this.transactionAmt;
    data['transactionId'] = this.transactionId;
    data['orderID'] = this.orderID;
    data['fundstatus'] = this.fundstatus;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}
