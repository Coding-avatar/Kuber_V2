import 'add_point_request_data.dart';

class AddFundRequestModel {
  List<AddFundRequestData> data;
  String message;
  bool status;

  AddFundRequestModel({this.data, this.message, this.status});

  AddFundRequestModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<AddFundRequestData>();
      json['data'].forEach((v) {
        data.add(new AddFundRequestData.fromJson(v));
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
