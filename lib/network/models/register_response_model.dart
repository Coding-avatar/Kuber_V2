class RegisterResponse {
  String message;
  bool status;
  String token;
  String password;
  String username;

  RegisterResponse(
      {this.message, this.status, this.token, this.password, this.username});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    token = json['token'];
    password = json['password'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    data['token'] = this.token;
    data['Password'] = this.password;
    data['username'] = this.username;
    return data;
  }
}
