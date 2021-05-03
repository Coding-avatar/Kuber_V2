import 'game_rate_response_data.dart';

class GameRateResponseModel {
  List<GameRateResponseData> data;
  String message;
  bool status;

  GameRateResponseModel({this.data, this.message, this.status});

  GameRateResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<GameRateResponseData>();
      json['data'].forEach((v) {
        data.add(new GameRateResponseData.fromJson(v));
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
