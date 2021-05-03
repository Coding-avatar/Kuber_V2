import 'banner_response_data.dart';

class BannerResponseModel {
  List<BannerResponseData> data;
  String message;
  bool status;

  BannerResponseModel({this.data, this.message, this.status});

  BannerResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<BannerResponseData>();
      json['data'].forEach((v) {
        data.add(new BannerResponseData.fromJson(v));
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
