import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_view_packaging/service/MessagingService.dart';

Future<void> subscribeToAllTopic() async {
  await FirebaseMessaging.instance.subscribeToTopic('all');
  print('Subscribed to all topic');
}

void getFcmToken() async {
  // FCM 토큰 받기
  String? token = await FirebaseMessaging.instance.getToken();
  print("tokentokentoken ${token}");
  if (token != null) {
    print('FCM Token: $token');
  }
}

// 백그라운드 메시지 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // 백그라운드 메시지 핸들러 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 포그라운드 메시지 핸들링
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  subscribeToAllTopic();

  // getFcmToken();
  // print("apnsToken ${apnsToken}");
  // if (apnsToken != null) {
  //   // Proceed with FCM operations

  // }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  InAppWebViewController? webViewController;
  final messagingService = MessagingService();

  @override
  void initState() {
    super.initState();
    messagingService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: InAppWebView(
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url;
            if (uri != null && uri.scheme == 'mailto') {
              // `mailto:` 링크 처리
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
                return NavigationActionPolicy.CANCEL; // WebView 로드 취소
              } else {
                print("Could not launch mail app.");
              }
            }

            return NavigationActionPolicy.ALLOW; // 기본 WebView 동작
          },
          initialUrlRequest: URLRequest(
            url: WebUri("https://www.bidding.sale"), // 파일 업로드를 지원하는 URL
          ),
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
        ),
      ),
    );
  }
}
