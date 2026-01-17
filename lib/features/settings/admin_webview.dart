import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lexnova/shared/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AdminWebView extends StatefulWidget {
  const AdminWebView({super.key});

  @override
  State<AdminWebView> createState() => _AdminWebViewState();
}

class _AdminWebViewState extends State<AdminWebView> {
  late final String _url;
  WebViewController? _controller;

  @override
  void initState() {
    super.initState();
    _url = AppConfig().adminUrl;

    // If on web, open in new tab immediately
    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _launchAdminUrl();
      });
    } else {
      // Initialize WebView for mobile
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000))
        ..loadRequest(Uri.parse(_url));
    }
  }

  Future<void> _launchAdminUrl() async {
    // Ensure URL has protocol
    String urlToOpen = _url;
    if (!urlToOpen.startsWith('http://') && !urlToOpen.startsWith('https://')) {
      urlToOpen = 'https://$urlToOpen';
    }

    final Uri uri = Uri.parse(urlToOpen);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open $urlToOpen')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening URL: $e')));
      }
    }

    // Go back after launching
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Portal')),
      body: kIsWeb
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Opening Admin Portal in new tab...'),
                ],
              ),
            )
          : _controller != null
          ? WebViewWidget(controller: _controller!)
          : const Center(child: Text('Loading...')),
    );
  }
}
