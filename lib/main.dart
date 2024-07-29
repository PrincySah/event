import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:newevent/controller/data_controller.dart';
import 'package:newevent/views/bottom_nav_bar/bottom_bar_view.dart';
import 'package:newevent/views/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
// Get.put(DataController());
 //Stripe.publishableKey = 'pk_test_51PgSinRuDGsNLA2kG0VFyXUH9Tb0f7tMZeO8CZUlOXcUPjXIdMBGhsKiZxmQQ86nXaKYtgEEk60L9uVgntAejOCg00sjwS05aC';
  runApp(const MyHomePage(title: '',));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home:const MyHomePage() ,
      //: navigatorKey,
      // supportedLocales: const [
      //   Locale('en', 'US'),
      //   Locale('ne', 'NP'),
      // ],
      // localizationsDelegates: const [
      //   KhaltiLocalizations.delegate,
      // ]
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;



  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    
return KhaltiScope(
publicKey:
'test_public_key_95c0f22ab5ab41fda51873f673c7f8df'
// 'test_public_key_c07f4131df2e408d9e821c485719fe77'
 , builder:(context,navigatorkey){

return    GetMaterialApp(
       navigatorKey: navigatorkey,
            theme: ThemeData(
              textTheme: GoogleFonts.latoTextTheme(
                Theme.of(context)
                    .textTheme, // If this is not set, then ThemeData.light().textTheme is used.
              ),
            ),
            title: 'Flutter Demo',
            home:
                //FirebaseAuth.instance.currentUser == null?
                FirebaseAuth.instance.currentUser?.uid == null
                    ? OnBoardingScreen()
                    : BottomBarView()
            //: BottomBarView(),
       ,     localizationsDelegates: const [
                    KhaltiLocalizations.delegate,
                  ],
            );
           

  }

);

    
  }
}
