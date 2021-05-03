import 'package:kuber_starline/network/models/add_funds_request_history_response_data.dart';

class AddFundsRequestHistoryResponse {
  List<AddFundsHistoryResponseData> data;
  String message;
  bool status;

  AddFundsRequestHistoryResponse({this.data, this.message, this.status});

  AddFundsRequestHistoryResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AddFundsHistoryResponseData>();
      json['data'].forEach((v) {
        data.add(new AddFundsHistoryResponseData.fromJson(v));
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
