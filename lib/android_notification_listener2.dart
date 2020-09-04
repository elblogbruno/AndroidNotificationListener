import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;

/// Custom Exception for the plugin,
/// thrown whenever the plugin is used on platforms other than Android
class NotificationExceptionV2 implements Exception {
  String _cause;

  NotificationExceptionV2(this._cause);

  @override
  String toString() {
    return _cause;
  }
}

class NotificationEventV2 {
  String packageMessage;
  String packageName;
  String packageExtra;
  String packageText;
  String category;
  DateTime timeStamp;

  NotificationEventV2({this.packageName, this.packageMessage, this.timeStamp , this.packageExtra , this.packageText,this.category});

  factory NotificationEventV2.fromMap(Map<dynamic, dynamic> map) {
    DateTime time = DateTime.now();
    String name = map['packageName'];
    String message = map['packageMessage'];
    String text = map['packageText'];
    String extra =  map['packageExtra'];
    String category = map['category'];
    return NotificationEventV2(packageName: name, packageMessage: message, timeStamp: time,packageText: text , packageExtra: extra,category: category);
  }

  @override
  String toString() {
    return "Notification Event \n Package Name: $packageName \n - Timestamp: $timeStamp \n - Package Message: $packageMessage";
  }
}

NotificationEventV2 _notificationEvent(dynamic data) {
  return new NotificationEventV2.fromMap(data);
}

class AndroidNotificationListener {
  static const EventChannel _notificationEventChannel =
  EventChannel('notifications.eventChannel');

  Stream<NotificationEventV2> _notificationStream;

  Stream<NotificationEventV2> get notificationStream {
    if (Platform.isAndroid) {

      if (_notificationStream == null) {
        _notificationStream = _notificationEventChannel
            .receiveBroadcastStream()
            .map((event) => _notificationEvent(event));
      }
      return _notificationStream;
    }
    throw NotificationExceptionV2(
        'Notification API exclusively available on Android!');
  }
}
