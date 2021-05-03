import 'game_list_response_data.dart';

class GameListResponseModel {
  List<GameListData> data;
  String message;
  bool status;

  GameListResponseModel({this.data, this.message, this.status});

  GameListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<GameListData>();
      json['data'].forEach((v) {
        data.add(new GameListData.fromJson(v));
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
