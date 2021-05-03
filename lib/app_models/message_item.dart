import 'package:flutter/material.dart';

class MessageItem {
  String senderId;
  String body;
  bool isRead;

  MessageItem(
      {@required this.senderId, @required this.body, @required this.isRead});

  MessageItem.fromJson(Map<String, dynamic> json) {
    senderId = json['senderId'];
    body = json['body'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['senderId'] = this.senderId;
    data['body'] = this.body;
    data['isRead'] = this.isRead;

    return data;
  }
}
