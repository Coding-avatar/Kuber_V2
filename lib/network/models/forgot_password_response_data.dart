class ForgotPasswordResponseData {
  String password;

  ForgotPasswordResponseData({this.password});

  ForgotPasswordResponseData.fromJson(Map<String, dynamic> json) {
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    return data;
  }
}
