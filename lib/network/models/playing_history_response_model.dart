import 'package:kuber_starline/network/models/playing_history_response_data.dart';

class PlayingHistoryResponseModel {
  List<PlayingHistoryResponseData> data;
  String message;
  bool status;

  PlayingHistoryResponseModel({this.data, this.message, this.status});

  PlayingHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<PlayingHistoryResponseData>();
      json['data'].forEach((v) {
        data.add(new PlayingHistoryResponseData.fromJson(v));
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
