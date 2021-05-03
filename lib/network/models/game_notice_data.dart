class GameNoticeData {
  int pkNotice;
  String heading;
  String description;
  String photo;

  GameNoticeData({this.pkNotice, this.heading, this.description, this.photo});

  GameNoticeData.fromJson(Map<String, dynamic> json) {
    pkNotice = json['pk_Notice'];
    heading = json['heading'];
    description = json['description'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_Notice'] = this.pkNotice;
    data['heading'] = this.heading;
    data['description'] = this.description;
    data['photo'] = this.photo;
    return data;
  }
}
