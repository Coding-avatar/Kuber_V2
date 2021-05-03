class NotificationsResponseData {
  String notification;

  NotificationsResponseData({this.notification});

  NotificationsResponseData.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    return data;
  }
}
