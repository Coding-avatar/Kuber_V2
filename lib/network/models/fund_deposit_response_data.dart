class FundDepositResponseData {
  int pkUserPoint;
  String transactionAmt;
  String transactionId;
  String orderID;
  String fundstatus;

  FundDepositResponseData(
      {this.pkUserPoint,
      this.transactionAmt,
      this.transactionId,
      this.orderID,
      this.fundstatus});

  FundDepositResponseData.fromJson(Map<String, dynamic> json) {
    pkUserPoint = json['pk_UserPoint'];
    transactionAmt = json['transactionAmt'];
    transactionId = json['transactionId'];
    orderID = json['orderID'];
    fundstatus = json['fundstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_UserPoint'] = this.pkUserPoint;
    data['transactionAmt'] = this.transactionAmt;
    data['transactionId'] = this.transactionId;
    data['orderID'] = this.orderID;
    data['fundstatus'] = this.fundstatus;
    return data;
  }
}
