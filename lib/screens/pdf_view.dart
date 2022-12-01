import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LihatPDF extends StatefulWidget {
  @override
  State<LihatPDF> createState() => _LihatPDFState();
}

class _LihatPDFState extends State<LihatPDF> {
  // const LihatPDF({Key? key}) : super(key: key);
  String url = '';
  bool _isLoading = true;

  getUrl() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    url = pref.getString('url');
  }

  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
        initialUrl:
            'http://docs.google.com/viewer?url=https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf');
  }
}
