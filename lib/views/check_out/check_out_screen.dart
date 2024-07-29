import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:developer';

import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:newevent/Services/payment_service/payment_service.dart';
import 'package:newevent/utils/color.dart';
import 'package:newevent/views/widgets/my_widgets.dart';

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
   late final WebViewController _controller;
   late final WebViewController webcontroller;
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
//final WebViewController controller =
  //WebViewController.fromPlatformCreationParams();
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
  String ?kurl;

  final config = PaymentConfig(
  amount: 1000, // Amount should be in paisa
  productIdentity: 'dell-g5-g5510-2021',
  productName: 'Dell G5 G5510 2021',
  productUrl: 'https://www.khalti.com/#/bazaar',
  additionalData: { // Not mandatory; can be used for reporting purpose
    'vendor': 'Khalti Bazaar',
  },
 // mobile: '9800000002', // Not mandatory; can be used to fill mobile number field
 // mobileReadOnly: true, // Not mandatory; makes the mobile field not editable
);
payment()async{
kurl=await inittiateKhaltiV2(100);
}
  //Future<String?>
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
//payment();

/////////


  //@override
 // void initState() {
 //   super.initState();
  
  //}


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



    // KhaltiScope.of(context).pay(
    //   config: config,
    //   preferences: [
    //     PaymentPreference.khalti
    //    // PaymentPreference.connectIPS,
    //     //PaymentPreference.eBanking,
    //     //PaymentPreference.sct,
    //   ],
    //   onSuccess: (v){

    //   },
    //   onFailure: (v){

    //   },
    //   onCancel: (){

    //   },
    // );
 

                 String ?khaltiUrl=    inittiateKhaltiV2(10);
                 print('khaltiurlis$khaltiUrl');
                 
if (khaltiUrl!.isNotEmpty) {
  webcontroller= WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(


      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {



      },
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('http://example.com')) {
          String url=request.url;
 Uri uri = Uri.parse(
//'https://test-pay.khalti.com/?pidx=XXPaKjyEHrHqk6m6vfiqcb'
  url
 );
  Map<String, String> queryParameters = uri.queryParameters;

print('............starts wit............');


  
         
  //  Get.toNamed(Routes.HOME);
        return NavigationDecision.prevent;
        }
        else{
Get.showSnackbar(GetSnackBar(title: 'Error',message: 'something went wrong',));
//Get.offAllNamed(Routes.HOME);

        }
        return NavigationDecision.navigate;
       },
    ),
  )
  ..loadRequest(Uri.parse('$khaltiUrl'));
}



Get.dialog(WebViewWidget(controller: webcontroller));
                 
                 //   Get.to(()=>PaymentPage(kurl: kurl,));
                    
                    //    _controller.loadRequest(Uri.parse('https://flutter.dev'));
                //    Get.to(PaymentForm());

// late   final WebViewController controller;
// controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000))
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onHttpError: (HttpResponseError error) {},
//       onWebResourceError: (WebResourceError error) {},
//       onNavigationRequest: (NavigationRequest request) {
//         if (request.url.startsWith('https://www.youtube.com/')) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     ),
//   )
//   ..loadRequest(Uri.parse('https://flutter.dev'));
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


}

class PaymentPage extends StatefulWidget {
  var kurl;
   PaymentPage({super.key,required this.kurl});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
 late final WebViewController _controller;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // pay();
 _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            print("Page started loading: $url");
          },
          onPageFinished: (String url) {
            print("Page finished loading: $url");
          },
          onHttpError: (HttpResponseError error) {
            print("HTTP error: ${error}");
          },
          onWebResourceError: (WebResourceError error) {
            print("Web resource error: ${error.description}");
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.kurl));

  }
  @override
  Widget build(BuildContext context) {


    return //Scaffold(body: 
   // PayNow(webViewController: _controller)
  WebViewWidget(controller: _controller);
    //Text(widget.kurl),
    //);
    
    //WebViewWidget(controller: _controller);
  }
}

