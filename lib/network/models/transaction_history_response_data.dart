class TransactionHistoryResponseData {
  String comment;
  String amount;
  String status;
  String datetime;
  String balance;

  TransactionHistoryResponseData(
      {this.comment, this.amount, this.status, this.datetime, this.balance});

  TransactionHistoryResponseData.fromJson(Map<String, dynamic> json) {
    comment = json['comment'];
    amount = json['amount'];
    status = json['status'];
    datetime = json['datetime'];
    balance = json['balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment'] = this.comment;
    data['amount'] = this.amount;
    data['status'] = this.status;
    data['datetime'] = this.datetime;
    data['balance'] = this.balance;
    return data;
  }
}
