import 'package:kuber_starline/network/models/winning_history_response_data.dart';

class WinningHistoryResponseModel {
  List<WinningHistoryResponseData> data;
  String message;
  bool status;

  WinningHistoryResponseModel({this.data, this.message, this.status});

  WinningHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<WinningHistoryResponseData>();
      json['data'].forEach((v) {
        data.add(new WinningHistoryResponseData.fromJson(v));
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
