import 'package:kuber_starline/network/models/game_notice_data.dart';

class GameNoticeResponse {
  List<GameNoticeData> data;
  String message;
  bool status;

  GameNoticeResponse({this.data, this.message, this.status});

  GameNoticeResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<GameNoticeData>();
      json['data'].forEach((v) {
        data.add(new GameNoticeData.fromJson(v));
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
