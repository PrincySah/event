import 'dart:async';
import 'dart:convert';
import 'dart:io';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:ems/utils/app_constants.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/constant.dart';

Map<String, dynamic>? paymentIntentData;

// Future<void> makePayment(BuildContext context,
//     {String? amount, String? eventId}) async {
//   try {
//     paymentIntentData = await createPaymentIntent(amount!, 'USD');
//     await Stripe.instance
//         .initPaymentSheet(
//             paymentSheetParameters: SetupPaymentSheetParameters(
//                 paymentIntentClientSecret: paymentIntentData!['client_secret'],
//                // applePay: true,
//                 //googlePay: true,
//                 testEnv: true,
//                 style: ThemeMode.dark,
//                 merchantCountryCode: 'US',
//                 merchantDisplayName: 'EMS'))
//         .then((value) {})
//         .catchError((e) {
//       print("Error is $e");
//     });

//     ///now finally display payment sheeet
//     displayPaymentSheet(context, eventId!);
//   } catch (e, s) {
//     print('exception:');
//     print("\n");
//     print("$e");
//     print("\n");

//     print("$s");
//   }
// }
inittiateKhaltiV2(
  var amount,
  //String key
) async {
  // print('amo$key...............................');
  try {
//  Get.put(BookingController());
    //  BookingController bController=Get.find<BookingController>();
    //var b=bController.paymentList[0].attributeList! .where((element) => element.attributeKey=='secret_key').first.attributeValue;
    final response = await http.post(
      Uri.parse('https://a.khalti.com/api/v2/epayment/initiate/'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8',
        HttpHeaders.authorizationHeader:

            //'key $key'

            'key live_secret_key_68791341fdd94846a146f0457ff7b455'
        //     'key cfb7038731334d81b6b117de6ae272f1',
        //  'key ${b.toString()}'
      },

//KhaltiHeader.getHeader(),
      body: json.encode({
        "return_url": "http://example.com",
        "website_url": "https://example.com/",
        "amount": amount * 100,
        "purchase_order_id": "Order01",
        "purchase_order_name": "test",
        "customer_info": {
          "name": "Hari",
          "email": "test@khalti.com",
          "phone": "9800000001"
        }
      }),
    );
    var res = jsonDecode(response.body);
    print('eres${response.body}');
    print(res['payment_url']);
    return res['payment_url'];
  } catch (e) {
    print('err$e');
  }
}

payment() async {
  late final WebViewController webcontroller;
  String khaltiUrl = inittiateKhaltiV2(
    1000,

    //'key cfb7038731334d81b6b117de6ae272f1'
  );

  //   await BookingRepository.inittiateKhaltiV2(controller.totalPrice.value,b!);

  if (khaltiUrl.isNotEmpty) {
    webcontroller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http://example.com')) {
              String url = request.url;
              Uri uri = Uri.parse(url);
              Map<String, String> queryParameters = uri.queryParameters;

              print('............starts wit............');

              //  Get.toNamed(Routes.HOME);
              return NavigationDecision.prevent;
            } else {
              Get.showSnackbar(GetSnackBar(
                title: 'Error',
                message: 'something went wrong',
              ));
//Get.offAllNamed(Routes.HOME);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('$khaltiUrl'));
  }

  Get.dialog(WebViewWidget(controller: webcontroller));
}

Map<String, dynamic>? PaymentIntentData;
Future<void> makePayment(BuildContext context,
    {String? amount, String? eventId}) async {
  try {
    PaymentIntentData = await createPaymentIntent('100', 'USD');
    print(paymentIntentData?['client_secret']);
    await Stripe.instance
        .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntentData!['client_secret'],

//'sk_test_51PgSinRuDGsNLA2kdqQew8PCsG5wy8Pa9HAS5hRja5tTm9G49kOhGfEZ1GZpAhzsorzW8TIMnoETZft6AxMUJaGX00iIzYoVl7',
                style: ThemeMode.dark,
                customFlow: false,
                merchantDisplayName: 'Coffee House',
                googlePay: PaymentSheetGooglePay(merchantCountryCode: 'US'),
                applePay: PaymentSheetApplePay(merchantCountryCode: 'US')))
        .then((value) {
      displayPaymentSheet(context);
    });
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }

//     try {
//       // Create payment intent
//       paymentIntentData = await createPaymentIntent(amount!, 'USD');
//       if (paymentIntentData == null) {
//         throw Exception("Failed to create payment intent");
//       }

//       // Initialize the payment sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentData!['client_secret'],
//           // Enable Apple and Google Pay if applicable
//        //   applePay: true,
//        //   googlePay: true,
//          // testEnv: true,
//           style: ThemeMode.dark,
//          // merchantCountryCode: 'US',
//           merchantDisplayName: 'EMS',
//         ),
//       );

//       // Display payment sheet
//       await displayPaymentSheet(context, eventId!);

//     } catch (e, s) {
//       print('Exception in makePayment: $e');
//       print('Stack trace: $s');
//       // Optionally, show an error message to the user
//       showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//           content: Text("Payment failed. Please try again."),
//         ),
//       );
//     }
}

createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, String> body = {
      'amount': amount,
      'currency': currency,
      'payment_method_types[]': 'card',
    };
    var response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':
            'Bearer sk_test_51PgSinRuDGsNLA2kdqQew8PCsG5wy8Pa9HAS5hRja5tTm9G49kOhGfEZ1GZpAhzsorzW8TIMnoETZft6AxMUJaGX00iIzYoVl7',
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body,
      encoding: Encoding.getByName('utf-8'),
    );
    print('red${response.body}');
    if (response.statusCode == 200) {
      return jsonDecode(response.body.toString());
    } else {
      throw Exception('Failed to create payment intent: ${response.body}');
    }
//return jsonDecode(respose.body.toString());
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

void displayPaymentSheet(BuildContext context) async {
  try {
    await Stripe.instance
        .presentPaymentSheet(options: PaymentSheetPresentOptions(timeout: 100));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Paid success')));
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paid success')));
    // }).onError((error,stackTrace){
    //   throw Exception(error);
    // });
  } catch (e) {}
}



// displayPaymentSheet(BuildContext context, String eventId) async {
//   try {
//     await Stripe.instance
//         .presentPaymentSheet(
//           options:PaymentSheetPresentOptions(


//           ) 
//             // ignore: deprecated_member_use
//             parameters: 
//             PresentPaymentSheetParameters(
//       clientSecret: paymentIntentData!['client_secret'],
//       confirmPayment: true,
//     ))
//         .then((newValue) {
//       FirebaseFirestore.instance.collection('events').doc(eventId).set({
//         'joined':
//             FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
//         'max_entries': FieldValue.increment(-1),
//       }, SetOptions(merge: true)).then((value) {
//         FirebaseFirestore.instance.collection('booking').doc(eventId).set({
//           'booking': FieldValue.arrayUnion([
//             {'uid': FirebaseAuth.instance.currentUser!.uid, 'tickets': 1}
//           ])
//         });

//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Paid Successfully")));

//         Timer(Duration(seconds: 3), () {
//           Get.back();
//         });
//       });

//       paymentIntentData = null;
//     }).onError((error, stackTrace) {
//       print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
//     });
//   } on StripeException catch (e) {
//     print('Exception/DISPLAYPAYMENTSHEET==> $e');
//     showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//               content: Text("Cancelled "),
//             ));
//   } catch (e) {
//     print('$e');
//   }
// }

// //  Future<Map<String, dynamic>>
// createPaymentIntent(String amount, String currency) async {
//   try {
//     Map<String, dynamic> body = {
//       'amount': calculateAmount(amount),
//       'currency': currency,
//       'payment_method_types[]': 'card'
//     };
//     print(body);
//     var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         body: body,
//         headers: {
//           'Authorization': 'Bearer $secretKey',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         });
//     print('Create Intent reponse ===> ${response.body.toString()}');
//     return jsonDecode(response.body);
//   } catch (err) {
//     print('err charging user: ${err.toString()}');
//   }
// }

// calculateAmount(String amount) {
//   final a = (int.parse(amount)) * 100;
//   return a.toString();
// }
