import 'package:kuber_starline/network/models/starjackdetailsresponse_data.dart';

class StarJackDetailsResponseModel {
  String message;
  bool status;
  StarJackDetailsResponseData data;

  StarJackDetailsResponseModel({this.message, this.status, this.data});

  StarJackDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null
        ? new StarJackDetailsResponseData.fromJson(json['data'])
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
