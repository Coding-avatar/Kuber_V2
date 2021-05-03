import 'package:kuber_starline/network/models/notifications_response_data.dart';

class NotificationsResponseModel {
  List<NotificationsResponseData> data;
  String message;
  bool status;

  NotificationsResponseModel({this.data, this.message, this.status});

  NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<NotificationsResponseData>();
      json['data'].forEach((v) {
        data.add(new NotificationsResponseData.fromJson(v));
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
