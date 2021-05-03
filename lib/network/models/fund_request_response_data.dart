class FundRequestResponseData {
  int pkUserPoint;
  String transactionAmt;
  String transactionType;
  String transactionId;
  String comment;

  FundRequestResponseData(
      {this.pkUserPoint,
      this.transactionAmt,
      this.transactionType,
      this.transactionId,
      this.comment});

  FundRequestResponseData.fromJson(Map<String, dynamic> json) {
    pkUserPoint = json['pk_UserPoint'];
    transactionAmt = json['transactionAmt'];
    transactionType = json['transactionType'];
    transactionId = json['transactionId'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_UserPoint'] = this.pkUserPoint;
    data['transactionAmt'] = this.transactionAmt;
    data['transactionType'] = this.transactionType;
    data['transactionId'] = this.transactionId;
    data['comment'] = this.comment;
    return data;
  }
}
