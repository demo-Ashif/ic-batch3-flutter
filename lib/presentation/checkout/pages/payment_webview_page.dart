import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  const PaymentWebViewPage({
    super.key,
    required this.paymentUrl,
    required this.paymentMethodName,
  });

  final String paymentUrl;
  final String paymentMethodName;

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading progress if needed
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                  _error = null;
                });
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
                _checkPaymentStatus(url);
              },
              onHttpError: (HttpResponseError error) {
                setState(() {
                  _isLoading = false;
                  _error = 'HTTP Error: ${error.response?.statusCode}';
                });
              },
              onWebResourceError: (WebResourceError error) {
                setState(() {
                  _isLoading = false;
                  _error = 'Web Error: ${error.description}';
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                // Check for payment completion URLs
                _checkPaymentStatus(request.url);
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  void _checkPaymentStatus(String url) {
    // Check for success indicators in the URL
    if (url.contains('PaymentSuccess')) {
      _showPaymentResult(true, 'Payment completed successfully!');
      return;
    }

    // Check for failure indicators in the URL
    if (url.contains('PaymentFail')) {
      _showPaymentResult(false, 'Payment was cancelled or failed.');
      return;
    }
  }

  void _showPaymentResult(bool isSuccess, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            icon: Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              color:
                  isSuccess
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.error,
              size: 64,
            ),
            title: Text(
              isSuccess ? 'Payment Successful!' : 'Payment Failed',
              style: TextStyle(
                color:
                    isSuccess
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Close WebView
                  Navigator.of(context).pop(); // Close checkout detail
                  Navigator.of(context).pop(); // Close checkout page
                },
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment - ${widget.paymentMethodName}'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_error != null)
            Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Payment Error',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineSmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _error!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _isLoading = true;
                        });
                        _controller.reload();
                      },
                      child: const Text('Retry'),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Go Back'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
