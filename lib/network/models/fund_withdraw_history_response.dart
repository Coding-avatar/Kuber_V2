import 'fund_withdraw_history_data.dart';

class FundWithdrawHistoryResponse {
  List<FundWithdrawHistoryData> data;
  String message;
  bool status;

  FundWithdrawHistoryResponse({this.data, this.message, this.status});

  FundWithdrawHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FundWithdrawHistoryData>();
      json['data'].forEach((v) {
        data.add(new FundWithdrawHistoryData.fromJson(v));
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
