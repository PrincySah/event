import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class PaymentForm extends StatefulWidget {
  @override
  _PaymentFormState createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  String referenceid = '';

  @override
  Widget build(BuildContext context) {
    final config = PaymentConfig(
      returnUrl: 'https://example.com/payment-success',

      amount: 10000, // Amount should be in paisa
      productIdentity: 'dell-g5-g5510-2021',
      productName: 'Dell G5 G5510 2021',
      productUrl: 'https://www.khalti.com/#/bazaar',
      additionalData: {
        // Not mandatory; can be used for reporting purpose
        'vendor': 'Khalti Bazaar',
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Khalti payment'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            KhaltiButton(
              config: config,
              preferences: [
                // Not providing this will enable all the payment methods.
                PaymentPreference.khalti,
                PaymentPreference.eBanking,
              ],
              onSuccess: onSuccess,
              onFailure: onFailure,
              onCancel: onCancel,
            ),
            ElevatedButton(
              onPressed: () {
                payviakhaltiinapp(context);
              },
              child: Text('Pay via Khalti In App'),
            ),
            Text(referenceid)
          ],
        ),
      ),
    );
  }

  void payviakhaltiinapp(BuildContext context) {
    KhaltiScope.of(context).pay(
      config: PaymentConfig(
        amount: 1000,
        productIdentity: "Product id",
        productName: "Product name",
      ),
      preferences: [
        PaymentPreference.khalti,
      ],
      onSuccess: onSuccess,
      onFailure: onFailure,
      onCancel: onCancel,
    );
  }

  void onSuccess(PaymentSuccessModel success) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Payment Sucessful"),
          actions: [
            SimpleDialogOption(
              child: Text("OK"),
              onPressed: () {
                setState(() {
                  referenceid = success.idx;
                });
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void onFailure(PaymentFailureModel failure) {
    debugPrint(failure.toString());
  }

  void onCancel() {
    debugPrint("Cancelled");
  }
}
