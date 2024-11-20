import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

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
                return NavigationActionPolicy.ALLOW;
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
