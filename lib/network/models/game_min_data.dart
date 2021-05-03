class MinData {
  String minbetamount;
  String gametype;

  MinData({this.minbetamount, this.gametype});

  MinData.fromJson(Map<String, dynamic> json) {
    minbetamount = json['minbetamount'];
    gametype = json['gametype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['minbetamount'] = this.minbetamount;
    data['gametype'] = this.gametype;
    return data;
  }
}
