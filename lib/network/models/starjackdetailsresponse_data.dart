class StarJackDetailsResponseData {
  String starname;
  String jackname;
  String whatsappno;

  StarJackDetailsResponseData({this.starname, this.jackname, this.whatsappno});

  StarJackDetailsResponseData.fromJson(Map<String, dynamic> json) {
    starname = json['starname'];
    jackname = json['jackname'];
    whatsappno = json['whatsappno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['starname'] = this.starname;
    data['jackname'] = this.jackname;
    data['whatsappno'] = this.whatsappno;
    return data;
  }
}
