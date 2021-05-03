import 'package:kuber_starline/network/models/transaction_history_response_data.dart';

class TransactionHistoryResponseModel {
  List<TransactionHistoryResponseData> data;
  String message;
  bool status;

  TransactionHistoryResponseModel({this.data, this.message, this.status});

  TransactionHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<TransactionHistoryResponseData>();
      json['data'].forEach((v) {
        data.add(new TransactionHistoryResponseData.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
