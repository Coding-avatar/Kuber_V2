import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomNotificationPlugin {
  static const MethodChannel _channel =
      const MethodChannel('custom_notification_plugin');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  Future<bool> showCustomNotificationLayout(
      {@required String gameTitle, @required String gameResult}) async {
    await _channel.invokeMethod('showCustomNotification', {
      "gameTitle": gameTitle,
      "gameResult": gameResult,
    });

    return true;
  }
}
