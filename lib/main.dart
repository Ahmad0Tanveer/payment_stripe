import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:payment_stripe/stripe_pay.dart';

String secretKey = "sk_test_51Kxl3LHHqLWDkBrH2KX0QJmMBDHuPnBRKEO3ug2gUtMr8KdiDHt7DUAifZimVUTP63FUITXNuSOJhdmNYYt9dk5300LDmypwXT";
String publishKey =  "pk_test_51Kxl3LHHqLWDkBrHmP7NQFf4Wtvj1I20Qnt0jPNeRSUIhb8r5MCSYH8BmfMIvmofAxrxBydF2xZV9OB57Hfru2Aj00vauqC1dg";


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
           bool success =  await StripeService().makePayment(amount: "20", currency: "usd")??false;
           if(success) {
             Fluttertoast.showToast(
               msg: "Payment Successfully ",
               backgroundColor: Colors.green,
               fontSize: 15,
               textColor: Colors.white,
               timeInSecForIosWeb: 4,
             );
           } else {
             Fluttertoast.showToast(
               msg: "Payment Failed",
               backgroundColor: Colors.red,
               fontSize: 15,
               textColor: Colors.white,
               timeInSecForIosWeb: 4,
             );
           }
          },
          child: Text("Pay Now"),
        ),
      ),
    );
  }
}
