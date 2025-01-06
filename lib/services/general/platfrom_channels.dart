import 'package:ecofy/services/general/localstorage.dart';
import 'package:ecofy/services/general/main_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const notificationChannel = MethodChannel("ecofy/notification");

class NotificationHandler {
  final DatabaseService database;
  final String userId;
  final double width;
  final double height;
  final context;

  NotificationHandler(
      {required this.database,
      required this.userId,
      required this.width,
      required this.height,
      required this.context});

  Future<void> listenForNotifications() async {
    try {
      notificationChannel.setMethodCallHandler(_handleMethodCall);
    } on PlatformException catch (e) {
      print("Failed to set up notification listener: '${e.message}'.");
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'sendNotification') {
      String routeName = call.arguments['pageId'];
      debugPrint(routeName);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainNavigation(
                database: database,
                userId: userId,
                width: width,
                height: height)),
      );

      return "Received";
    } else {
      return "Unimplemented";
    }
  }
}
