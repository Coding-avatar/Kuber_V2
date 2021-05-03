import 'jackpot_response_data.dart';

class JackpotResponseModel {
  List<JackpotResponseData> data;
  String message;
  bool status;

  JackpotResponseModel({this.data, this.message, this.status});

  JackpotResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<JackpotResponseData>();
      json['data'].forEach((v) {
        data.add(new JackpotResponseData.fromJson(v));
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
