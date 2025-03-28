import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyWebViewWidget extends StatefulWidget {
  final String url;

  const MyWebViewWidget({Key? key, required this.url}) : super(key: key);

  @override
  State<MyWebViewWidget> createState() => _MyWebViewWidgetState();
}

class _MyWebViewWidgetState extends State<MyWebViewWidget> {
  InAppWebViewController? webViewController;

  double progress = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        progress < 1.0
            ? LinearProgressIndicator(value: progress)
            : Container(),
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(
              // url: Uri.parse("https://flutter.dev"),
              url: WebUri(widget.url),
            ),
            // initialOptions: InAppWebViewGroupOptions(
            //   crossPlatform: InAppWebViewOptions(
            //     useShouldOverrideUrlLoading: true,
            //     mediaPlaybackRequiresUserGesture: false,
            //   ),
            // ),
            onWebViewCreated: (InAppWebViewController controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              setState(() {
                progress = 0;
              });
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
        ),
      ],
    );
  }
}
