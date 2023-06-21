// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

import 'package:project/Import/imports.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class TechDonation extends StatefulWidget {
  const TechDonation({super.key});

  @override
  State<TechDonation> createState() => _TechDonationState();
}

void _navigateToHomeScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => HomeScreen(),
    ),
  );
}

class _TechDonationState extends State<TechDonation> {
  Map<String, dynamic>? paymentIntentData;
  final TextEditingController _amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF012630),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Donation',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _navigateToHomeScreen(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFD9D9D9),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Enter the amount to donate in USD',
                  hintStyle: const TextStyle(color: Colors.black87),
                  prefixIcon: const Icon(
                    Icons.money,
                    color: Colors.black,
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: makePayment,
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFD9D9D9)),
              ),
              child: const Text(
                'Donate',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    final amount = _amountController.text;
    if (amount.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text('Please enter a donation amount.'),
        ),
      );
      return;
    }
    try {
      paymentIntentData = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret:
                      'sk_test_51NEGTlSA6nOYUQ7RNYPN3nmZTjKi9dipn552W7478DtIAkyCDqlVNNmHzbkNHNAO3Hm70tNb2IOs96NbrOhNdxDB00FQ9UjTq2',
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  customFlow: true,
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Aman'))
          .then((value) {});

      displayPaymentSheet();
    } catch (e, s) {
      print('Payment exception:$e$s');
    }
  }

  Future<void> displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ' +
                'sk_test_51NEGTlSA6nOYUQ7RNYPN3nmZTjKi9dipn552W7478DtIAkyCDqlVNNmHzbkNHNAO3Hm70tNb2IOs96NbrOhNdxDB00FQ9UjTq2',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  String calculateAmount(String amount) {
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount != null) {
      final intAmount = (parsedAmount * 100).toInt();
      return intAmount.toString();
    }
    return '0';
  }
}
