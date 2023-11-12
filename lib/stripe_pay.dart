import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:payment_stripe/main.dart';

class StripeService {
  Map<String, dynamic>? paymentIntentData;

  Future<bool?> makePayment({
    required String amount,
    required String currency,
  }) async {
    try {
      debugPrint("Start Payment");
      paymentIntentData = await createPaymentIntent(amount, currency);

      debugPrint("After payment intent");
      print(paymentIntentData);
      if (paymentIntentData != null) {
        debugPrint(" payment intent is not null .........");
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
          customFlow: true,
          merchantDisplayName: 'Prospects',
          customerId: paymentIntentData!['customer'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92'),
          googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: '+92', testEnv: true),
          style: ThemeMode.dark,
        ));
        debugPrint(" initPaymentSheet  .........");
        try {
          await Stripe.instance.presentPaymentSheet();
          return true;
        } on Exception catch (e) {
          if (e is StripeException) {
            debugPrint("Error from Stripe: ${e.error.localizedMessage}");
          } else {
            debugPrint("Unforcen Error: $e");
          }
        } catch (e) {
          debugPrint("Exception $e");
        }
      }
    } catch (e, s) {
      debugPrint("After payment intent Error: ${e.toString()}");
      debugPrint("After payment intent s Error: ${s.toString()}");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculate(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      debugPrint("Start Payment Intent http rwq post method");
      var response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization": "Bearer $secretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          });
      debugPrint("End Payment Intent http rwq post method");
      debugPrint(response.body.toString());
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('err charging user: ${e.toString()}');
    }
  }

  calculate(String amount) {
    final a = (double.parse(amount)) * 100;
    return a.toStringAsFixed(0);
  }
}
