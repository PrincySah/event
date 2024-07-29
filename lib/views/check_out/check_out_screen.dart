import 'dart:convert';
import 'dart:io';
import 'package:khalti_flutter/khalti_flutter.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:khalti/khalti.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:newevent/Services/payment_service/payment_service.dart';
import 'package:newevent/utils/color.dart';
import 'package:newevent/views/widgets/my_widgets.dart';
import 'package:khalti_flutter/src/widget/khalti_scope.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class CheckOutView extends StatefulWidget {
  DocumentSnapshot? eventDoc;

  CheckOutView(this.eventDoc);

  @override
  State<CheckOutView> createState() => _CheckOutViewState();
}

class _CheckOutViewState extends State<CheckOutView> {
  int selectedRadio = 0;
  String refId = '';
  String hasError = '';
  final String title = '';
//  initState() {
//    super.initState();
//     print("initState Called");
//   }
// final config = PaymentConfig(
//   amount: 10000, // Amount should be in paisa
//   productIdentity: 'dell-g5-g5510-2021',
//   productName: 'Dell G5 G5510 2021',
//   productUrl: 'https://www.khalti.com/#/bazaar',
//   additionalData: { // Not mandatory; can be used for reporting purpose
//     'vendor': 'Khalti Bazaar',
//   },
//   mobile: '9800000001', // Not mandatory; can be used to fill mobile number field
//   mobileReadOnly: true, // Not mandatory; makes the mobile field not editable
// );

//  late final WebViewController controller;
// final WebViewController controller =
//   WebViewController.fromPlatformCreationParams();
  void setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
  }

  String eventImage = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    try {
      List media = widget.eventDoc!.get('media') as List;
      Map mediaItem =
          media.firstWhere((element) => element['isImage'] == true) as Map;
      eventImage = mediaItem['url'];
    } catch (e) {
      eventImage = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          // height: Get.height,
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(
                            context); // Navigate back to the previous screen
                      },
                      child: Container(
                        width: 27,
                        height: 27,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/circle.png'),
                          ),
                        ),
                        child: Image.asset('assets/bi_x-lg.png'),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: Center(
                      child: myText(
                        text: 'CheckOut',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(''),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: Get.width,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      spreadRadius: 1,
                      color: Color(0xff393939).withOpacity(0.15),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(eventImage),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                myText(
                                  text: widget.eventDoc!.get('event_name'),
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                myText(
                                  text: 'may 15',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 11.67,
                                height: 15,
                                child: Image.asset(
                                  'assets/location.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              myText(
                                text: widget.eventDoc!.get('location'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          myText(
                            text: widget.eventDoc!.get('date'),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              myText(
                text: 'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              Divider(),
              Row(
                children: [
                  myText(
                    text: 'Event Fee',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  myText(
                    text: '\Rs ${widget.eventDoc!.get('price')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Divider(),
              Row(
                children: [
                  myText(
                    text: 'Total Ticket',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  myText(
                    text: '\Rs ${int.parse(widget.eventDoc!.get('price'))}',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10),
                height: 50,
                width: double.infinity,
                child: elevatedButton(
                  onpress: () {
                    Get.to(PaymentForm());
                  },
                  text: 'Book Now',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// //KhaltiHeader.getHeader(),
//         body: json.encode({
//           "return_url": "http://example.com",
//           "website_url": "https://example.com/",
//           "amount": amount * 100,
//           "purchase_order_id": "Order01",
//           "purchase_order_name": "test",
//           "customer_info": {
//             "name": "Hari",
//             "email": "test@khalti.com",
//             "phone": "9800000001"
//           }
//         }),
//       );
//       var res = jsonDecode(response.body);
//       print('eres${response.body}');
//       print(res['payment_url']);
//       return res['payment_url'];
//     } catch (e) {
//       print('err$e');
//     }
//   }
// }

//  class PaymentForm extends StatefulWidget {
//    @override
//   _PaymentFormState createState() => _PaymentFormState();
//  }

// class _PaymentFormState extends State<PaymentForm> {

//     String referenceid = '';
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Khalti payment')),
//         body: Center(child: Column(
//           mainAxisSize: MainAxisSize.max,
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           ElevatedButton(onPressed: () {
//             Get.to(payviakhaltiinapp());
//           }, child: const Text('Pay via Khalti')),
//           Text(referenceid)

//         ],

//         ),),
//     );
//   }

//   payviakhaltiinapp(){
//     KhaltiScope.of(context).pay(
//       config: PaymentConfig(amount: 1000, productIdentity: "Product id", productName: "Product name"),
//       preferences: [
//         PaymentPreference.khalti,
//       ],
//       onSuccess: onSuccess,
//       onFailure: onFailure,
//       onCancel: onCancel
//       );

//   }
//   void onSuccess(PaymentSuccessModel success){
//     showDialog(context: context, builder: (context){
//     return AlertDialog(title: Text ("Payment Sucessful"),
//        actions: [
//         SimpleDialogOption(child: const Text("OK"),
//         onPressed: (){
//           setState(() {
//            referenceid= success.idx;
//           });
//           Navigator.pop(context);
//         },)
//        ],

//     );
//   });
// }
// void onFailure(PaymentFailureModel failure){
//   debugPrint(failure.toString());
// }
// void onCancel(){
//   debugPrint("Cancelled");
// }
// }

// //       body: Padding(
// //         padding: EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: Column(
// //             crossAxisAlignment: CrossAxisAlignment.stretch,
// //             children: [
// //               TextFormField(
// //                 controller: _cardNumberController,
// //                 decoration: InputDecoration(labelText: 'Card Number'),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter card number';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               TextFormField(
// //                 controller: _expiryDateController,
// //                 decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
// //                 keyboardType: TextInputType.datetime,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter expiry date';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               TextFormField(
// //                 controller: _cvvController,
// //                 decoration: InputDecoration(labelText: 'CVV'),
// //                 keyboardType: TextInputType.number,
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter CVV';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               TextFormField(
// //                 controller: _nameController,
// //                 decoration: InputDecoration(labelText: 'Cardholder Name'),
// //                 validator: (value) {
// //                   if (value == null || value.isEmpty) {
// //                     return 'Please enter cardholder name';
// //                   }
// //                   return null;
// //                 },
// //               ),
// //               SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _submit,
// //                 child: Text('Pay Now'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
}
