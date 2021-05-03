class BannerResponseData {
  int pkBanner;
  String photo;
  String heading;
  String description;

  BannerResponseData(
      {this.pkBanner, this.photo, this.heading, this.description});

  BannerResponseData.fromJson(Map<String, dynamic> json) {
    pkBanner = json['pk_Banner'];
    photo = json['photo'];
    heading = json['heading'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pk_Banner'] = this.pkBanner;
    data['photo'] = this.photo;
    data['heading'] = this.heading;
    data['description'] = this.description;
    return data;
  }
}
