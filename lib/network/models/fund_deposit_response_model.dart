import 'package:kuber_starline/network/models/fund_deposit_response_data.dart';

class FundDepositHistoryResponse {
  List<FundDepositResponseData> data;
  String message;
  bool status;

  FundDepositHistoryResponse({this.data, this.message, this.status});

  FundDepositHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<FundDepositResponseData>();
      json['data'].forEach((v) {
        data.add(new FundDepositResponseData.fromJson(v));
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
