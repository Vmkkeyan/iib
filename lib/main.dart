import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

void main() {
  runApp(IIBApp());
}

class IIBApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IIB - International Innovator Bridge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: AgentHomePage(),
    );
  }
}

class AgentHomePage extends StatefulWidget {
  @override
  _AgentHomePageState createState() => _AgentHomePageState();
}

class _AgentHomePageState extends State<AgentHomePage> {
  late Razorpay _razorpay;
  int totalEarnings = 0;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout({required int amount, required String planName, String currency = 'INR'}) {
    var options = {
      'key': 'rzp_live_YOUR_KEY_HERE', 
      'amount': amount * 100, 
      'currency': currency,
      'name': 'IIB - International Innovator Bridge',
      'description': planName + ' (Yearly)',
      'prefill': {'contact': '9876543210', 'email': 'agent@iib.com'},
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      totalEarnings += 500;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Success: ${response.paymentId} - Amount will go to YOUR Bank!"), backgroundColor: Colors.green),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}"), backgroundColor: Colors.red),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("IIB Agent App"), centerTitle: true, backgroundColor: Color(0xFF0A1931), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Color(0xFF0A1931),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text("Total Earnings", style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 5),
                      Text("₹ $totalEarnings", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ]),
                    Icon(Icons.account_balance_wallet, color: Colors.white, size: 40)
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("IIB Premium Plan - Yearly", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            // A PLAN YEARLY - SINGLE CARD
            Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.workspace_premium, color: Color(0xFF0A1931), size: 36),
                      SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text("IIB Premium - Yearly", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text("For Students, Job Seekers, Investors - USA, UK, Germany, Australia, Full Support - 1 Year Valid", style: TextStyle(fontSize: 12)),
                      ])),
                    ]),
                    SizedBox(height: 16),
                    Row(children: [
                      Expanded(child: ElevatedButton(onPressed: () => openCheckout(amount: 1999, planName: "IIB Premium India", currency: "INR"), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF0A1931), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 12)), child: Text("Pay ₹1999 / Year"))),
                      SizedBox(width: 10),
                      Expanded(child: ElevatedButton(onPressed: () => openCheckout(amount: 27, planName: "IIB Premium International", currency: "USD"), style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700, foregroundColor: Colors.black, padding: EdgeInsets.symmetric(vertical: 12)), child: Text("Pay \$27 / Year"))),
                    ]),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(8)),
              child: Text("Note: Yearly Plan! ₹1999 India, \$27 International. Razorpay Live Key add செய்த பிறகு Client Pay பணம் நேரடியாக உங்கள் Bank Account-க்கு வரும்.", style: TextStyle(fontSize: 12)),
            )
          ],
        ),
      ),
    );
  }
}
