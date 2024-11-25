import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    await _fcm.requestPermission();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: $message");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("onMessageOpenedApp: $message");
    });
    final topic = "all";

    // if (Platform.isIOS) {
    //   String? apnsToken = await _fcm.getAPNSToken();
    //   print("apnsToken ${apnsToken}");
    // }
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("fcmTokenfcmToken ${fcmToken}");

    // if (Platform.isIOS) {
    //   String? apnsToken = await _fcm.getAPNSToken();
    //   print("apnsToken ${apnsToken}");
    //   if (apnsToken != null) {
    //     await _fcm.subscribeToTopic(topic);
    //   } else {
    //     await Future<void>.delayed(
    //       const Duration(
    //         seconds: 3,
    //       ),
    //     );
    //     apnsToken = await _fcm.getAPNSToken();
    //     print("apnsToken ${apnsToken}");
    //     if (apnsToken != null) {
    //       await _fcm.subscribeToTopic(topic);
    //     }
    //   }
    // } else {
    //   await _fcm.subscribeToTopic(topic);
    // }

    // String? token = await _fcm.getToken();
    // print("${token} tokentokentoken");
    // print("tokentokentoken ${token}");
    // if (token != null) {
    //   print('FCM Token: $token');
    // }
  }
}
