import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class TermsConditions extends StatefulWidget {
  final String title;
  final String url;

  const TermsConditions({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  late WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Delay the progress bar to show the loading animation.
            Future.delayed(const Duration(milliseconds: 500), () {
              // Update loading bar.
              setState(() {
                _progress = progress;
              });
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://${widget.url}'));
  }

  @override
  Widget build(BuildContext context) {
    WebViewPlatform.instance;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _progress < 100
              ? LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(kColorBottomContainer),
                  value: _progress / 100.0,
                )
              : WebViewWidget(controller: _controller),
        ),
      ),
    );
  }
}
