library paypal_checkout;

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
enum CheckOutType {paypal, card}
class PayPalPaymentScreen extends StatefulWidget {
  final bool sandboxMode;
  final CheckOutType checkOutType;
  final String clientId;
  final String secretKey;
  final String currency;
  final String amount;
  final String returnURL;
  final String cancelURL;
  final Function(Map<String, dynamic>) onSuccess;
  final Function(String) onError;
  final Function() onCancel;

  const PayPalPaymentScreen({
    super.key,
     this.sandboxMode =true,
     this.checkOutType =CheckOutType.paypal,
    required this.clientId,
    required this.secretKey,
    required this.currency,
    required this.amount,
    required this.returnURL,
    required this.cancelURL,
    required this.onSuccess,
    required this.onError,
    required this.onCancel,
  });

  @override
  State<PayPalPaymentScreen> createState() => _PayPalPaymentScreenState();
}

class _PayPalPaymentScreenState extends State<PayPalPaymentScreen> {
  late final WebViewController _controller;
  late String baseUrl;
  String? accessToken;
  String? approvalUrl;
  String? orderId;

  @override
  void initState() {
    super.initState();
    baseUrl = widget.sandboxMode ? "https://api.sandbox.paypal.com" : "https://api.paypal.com";
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _initializePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text(widget.checkOutType==CheckOutType.card?'pay with Debit or Credit card':"Pay with PayPal")),
      body: approvalUrl == null
          ? const Center(child: CircularProgressIndicator())
          : WebViewWidget(controller: _controller),
    );
  }

  Future<void> _initializePayment() async {
    accessToken = await _getAccessToken();
    if (accessToken == null) return;
    _createOrder();
  }

  Future<String?> _getAccessToken() async {
    String auth = base64Encode(utf8.encode("${widget.clientId}:${widget.secretKey}"));
    final response = await http.post(
      Uri.parse("$baseUrl/v1/oauth2/token"),
      headers: {
        "Authorization": "Basic $auth",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: "grant_type=client_credentials",
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)["access_token"];
    }
    widget.onError("Failed to get PayPal Access Token");
    return null;
  }

  Future<void> _createOrder() async {
    final response = await http.post(
      Uri.parse("$baseUrl/v2/checkout/orders"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "intent": "CAPTURE",
        "purchase_units": [
          {"amount": {"currency_code": widget.currency, "value": widget.amount}},
        ],
        "application_context": {
          "return_url": widget.returnURL,
          "cancel_url": widget.cancelURL,
          "brand_name": "YourApp",
          "user_action": "PAY_NOW",
        },
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      orderId = responseBody["id"];
      if(widget.checkOutType==CheckOutType.card){
        approvalUrl = responseBody["links"]
            .firstWhere((link) => link["rel"] == "approve")["href"];
        approvalUrl = "$approvalUrl&fundingSource=card";
      }else{
        approvalUrl = responseBody["links"].firstWhere((link) => link["rel"] == "approve")["href"];

      }
      setState(() {});
    } else {
      widget.onError("Failed to create PayPal Order: ${response.body}");
    }
  }

  Future<void> _capturePayment() async {
    final response = await http.post(
      Uri.parse("$baseUrl/v2/checkout/orders/$orderId/capture"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      String paymentId = responseBody["purchase_units"][0]["payments"]["captures"][0]["id"];
      widget.onSuccess({"payment_id": paymentId, "status": "COMPLETED"});
      Get.back();
    } else {
      widget.onError("Payment Capture Failed: ${response.body}");
    }
  }
}