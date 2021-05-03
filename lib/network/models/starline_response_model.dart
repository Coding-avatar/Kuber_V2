import 'package:kuber_starline/network/models/starline_response_data.dart';

class StarlineResponseModel {
  List<StarlineResponseData> data;
  String message;
  bool status;

  StarlineResponseModel({this.data, this.message, this.status});

  StarlineResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<StarlineResponseData>();
      json['data'].forEach((v) {
        data.add(new StarlineResponseData.fromJson(v));
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
