import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
      iosConfiguration: IosConfiguration(onForeground: onStart, onBackground: onIOSBackground),
      androidConfiguration:
          AndroidConfiguration(onStart: onStart, isForegroundMode: true));

  await service.startService();
}

@pragma("vm:entry-point")
Future<bool> onIOSBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  debugPrint('IOS Background Service is running');
  return true;
}

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  debugPrint('${service is IOSServiceInstance} the service is IOS');
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      debugPrint("Foreground service invoked $event");
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      debugPrint("Background service invoked $event");
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 2), (timer) async {
    
    if (service is AndroidServiceInstance) {
      ///debugPrint("Timer Ran and service is android instance");
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(title: "Ecofy", content: "upload pic at ${DateTime.now()}");
      }
    }
  });
}
