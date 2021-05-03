class LoginResponseModel {
  String name;
  String mobile;
  String email;
  String message;
  bool status;
  String token;
  String username;

  LoginResponseModel(
      {this.name,
      this.mobile,
      this.email,
      this.message,
      this.status,
      this.token,
      this.username});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    message = json['message'];
    status = json['status'];
    token = json['token'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['message'] = this.message;
    data['status'] = this.status;
    data['token'] = this.token;
    data['username'] = this.username;
    return data;
  }
}
