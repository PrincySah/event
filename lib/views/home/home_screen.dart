import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newevent/controller/data_controller.dart';
import 'package:newevent/views/widgets/custom_app_bar.dart';
import 'package:newevent/views/widgets/events_feed_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Get.put(DataController());

  // DataController dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    Get.put(DataController());
    DataController dataController = Get.find<DataController>();
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.03),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(),

                Text(
                  "What's Going on today",
                  style: GoogleFonts.raleway(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                EventsFeed(),
                Obx(() => dataController.isUsersLoading.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : EventsIJoined())
                //  Obx(()=> dataController.isUsersLoading.value? CircularProgressIndicator() :
                //Text('data')
                //  EventsIJoined()

                // ??Container()

                //  )

//            Obx(() {
//   if (dataController.allUsers==null) {
//     return Center(
//       child: CircularProgressIndicator(),
//     );
//   } else {
//     return EventsIJoined(); // Ensure EventsIJoined() is a valid widget
//   }
// })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
