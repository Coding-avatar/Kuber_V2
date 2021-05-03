import 'forgot_password_response_data.dart';

class ForgotPasswordResponseModel {
  String message;
  bool status;
  ForgotPasswordResponseData data;

  ForgotPasswordResponseModel({this.message, this.status, this.data});

  ForgotPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new ForgotPasswordResponseData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}
