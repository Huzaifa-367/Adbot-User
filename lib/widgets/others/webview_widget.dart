import 'package:adbot/helper/admob_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class WebviewWidget extends StatelessWidget {
  const WebviewWidget(
      {Key? key, required this.mainUrl, required this.appBarTitle})
      : super(key: key);
  final String mainUrl;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          appBarTitle,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
          onTap: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: SizedBox(
          height: 50,
          child: AdWidget(
              ad: AdMobHelper.getBannerAd()..load(), key: UniqueKey())),
      body: InAppWebView(
        initialUrlRequest:
            URLRequest(url: Uri.parse(mainUrl)), // Replace with your URL
        onWebViewCreated: (InAppWebViewController controller) {
          // You can use the controller to interact with the WebView
        },
        initialOptions: InAppWebViewGroupOptions(
          android: AndroidInAppWebViewOptions(
            useWideViewPort: true,
          ),
          ios: IOSInAppWebViewOptions(
            allowsInlineMediaPlayback: true,
          ),
        ),
        onProgressChanged: (InAppWebViewController controller, int progress) {
          // Track progress changes if needed
        },
      ),
    );
  }
}
