import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentGateway extends StatefulWidget {
  const PaymentGateway({super.key});

  @override
  State<PaymentGateway> createState() => _PaymentGatewayState();
}

class _PaymentGatewayState extends State<PaymentGateway> {
  late Razorpay _razorpay;
  TextEditingController amountController =TextEditingController();

  void openCheckout(int amount) async {
    var options = {
      'key': 'yourkeyhere',
      'amount': amount * 100,
      'name': 'Saniya Mhamulkar',
      'description': 'Test Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'saniyamhamulkar51@gmail.com',
      },
      'method': {
        'upi': true,
        'card': true,
        'netbanking': true,
        'wallet': true,
      },
      'external': {
        'wallets': ['paytm'],
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }



  void handlePaymentSuccess(PaymentSuccessResponse response) {
    debugPrint('✅ Payment Successful: ${response.paymentId}');
    Fluttertoast.showToast(
      msg: "Payment Successful! Payment ID: ${response.paymentId}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    debugPrint('❌ Error Code: ${response.code}, Message: ${response.message}');
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.message}",
      toastLength: Toast.LENGTH_LONG,
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('💳 External Wallet: ${response.walletName}');
    Fluttertoast.showToast(
      msg: "External Wallet Selected: ${response.walletName}",
      toastLength: Toast.LENGTH_LONG,
    );
  }


  void handlePayementError(PaymentFailureResponse response){
    Fluttertoast.showToast(msg: "Payment Error"+response.message!,toastLength:Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    _razorpay.clear();
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //   title: const Text("Payment Gateway"),
      //   centerTitle: true,
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF141E30), Color(0xFF243B55)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/012/947/435/non_2x/creative-digital-payment-card-template-logo-design-fast-digital-payment-wallet-logos-for-web-business-brand-and-payments-free-vector.jpg'),
                  ),
                  const SizedBox(height: 20),

                  // Welcome Text
                  const Text(
                    "Welcome to RazorPayment",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    "Secure and Fast Payment Gateway",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // Amount Input Field
                  TextFormField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white12,
                      hintText: "Enter amount",
                      hintStyle: const TextStyle(color: Colors.white54),
                      labelText: "Amount (₹)",
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.currency_rupee, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white70, width: 2.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.tealAccent, width: 2.0),
                      ),
                      errorStyle: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Payment Button
                  ElevatedButton.icon(
                    onPressed: () {
                      if (amountController.text.isNotEmpty) {
                        int amount = int.parse(amountController.text);
                        if (amount > 0) {
                          openCheckout(amount);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter a valid amount")),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      "Make Payment",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.tealAccent[400],
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      shadowColor: Colors.tealAccent[700],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Footer
                  const Text(
                    "Your transactions are 100% secure",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
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
