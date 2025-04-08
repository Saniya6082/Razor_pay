import 'package:flutter/material.dart';
import 'package:payment_gateway/rozrar_gateway.dart';
void main() {
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Payment Gateway',

      home: const PaymentGateway(),
    );
  }
}


