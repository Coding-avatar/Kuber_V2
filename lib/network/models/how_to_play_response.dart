import 'how_to_play_data.dart';

class HowToPlayResponse {
  List<HowToPlayData> data;
  String message;
  bool status;

  HowToPlayResponse({this.data, this.message, this.status});

  HowToPlayResponse.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<HowToPlayData>();
      json['data'].forEach((v) {
        data.add(new HowToPlayData.fromJson(v));
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
