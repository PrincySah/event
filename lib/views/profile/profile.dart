import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:ems/controller/data_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newevent/controller/data_controller.dart';
import 'package:newevent/utils/color.dart';
import 'package:newevent/views/widgets/my_widgets.dart';

// import '../../utils/app_color.dart';
// import '../../widgets/my_widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  bool isNotEditable = true;

  DataController? dataController;

  String image = '';
  Future<bool> isUserCollectionExist() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').limit(1).get();
      return snapshot.docs
          .isNotEmpty; // If the collection has at least one document, it exists
    } catch (e) {
      print('Error checking user collection existence: $e');
      return false;
    }
  }

  Future<void> loadUserData() async {
    try {
      bool isCollectionExist = await isUserCollectionExist();
      print('usercoll$isCollectionExist');
      await fetchUserDocument();
      // Access userData after fetchUserDocument has completed
      // Set the text controllers here
      firstNameController.text = userData!['first'];
      lastNameController.text = userData!['last'];
      descriptionController.text = userData!['desc'] ?? '';
      // Other controller assignments...
    } catch (e) {
      // Handle errors if any
      print('Error loading user data: $e');
    }
  }

  var img;
  Future<void> fetchUserDocument() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      DocumentSnapshot docSnapshot = await userDocRef.get();
      print('doc snap $docSnapshot');
      if (docSnapshot.exists) {
        print('exist.......');
        userData = docSnapshot.data() as Map<String, dynamic>?;
        img = userData?['image'];
        print('userdata${userData}');
        print('img${img}');

        setState(() {});
        //   return docSnapshot;
      } else {
        throw StateError('No user document found for the given uid');
      }
    } else {
      throw StateError('User is not authenticated');
    }
  }

  Map<String, dynamic>? userData;
  @override
  initState() {
    super.initState();

    loadUserData();
    //fetchUserDocument();

    // DocumentSnapshot? myDocument;
    print(FirebaseAuth.instance.currentUser!.uid);
    print('userData$userData');
    dataController = Get.find<DataController>();

    firstNameController.text = userData?['first'] ?? '';
    //dataController?.get('first');
    lastNameController.text = userData?['last'] ?? '';
    //dataController!.myDocument?.get('last');

    try {
      descriptionController.text = userData?['desc'] ?? '';
      // dataController!.myDocument!.get('desc');
    } catch (e) {
      descriptionController.text = '' ?? '';
    }

    try {
      image = userData?['image'] ?? '';

      //dataController!.myDocument!.get('image');
    } catch (e) {
      image = '';
    }

    try {
      locationController.text = userData?['location'] ?? '';

      //dataController!.myDocument!.get('location');
    } catch (e) {
      locationController.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 100,
                  margin: EdgeInsets.only(
                      left: Get.width * 0.75, top: 20, right: 20),
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Image(
                          image: AssetImage('assets/sms.png'),
                          width: 28,
                          height: 25,
                        ),
                      ),
                      Image(
                        image: AssetImage('assets/menu.png'),
                        width: 23.33,
                        height: 19,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 90, horizontal: 20),
                  width: Get.width,
                  height: isNotEditable ? 240 : 310,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        width: 120,
                        height: 120,
                        margin: EdgeInsets.only(top: 35),
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(70),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xff7DDCFB),
                              Color(0xffBC67F2),
                              Color(0xffACF6AF),
                              Color(0xffF95549),
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(70),
                                ),
                                child:
                                    // image.isNotEmpty
                                    // ?
                                    CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    img ?? '',
                                  ),

                                  radius: 56,

                                  // child: Image.network(
                                  //   img,
                                  //   errorBuilder: (context, error, stackTrace) {
                                  //     return Center(
                                  //         child: Text('Error loading image'));
                                  //   },
                                  // ),
                                )

                                // CircleAvatar(
                                //     radius: 56,
                                //     backgroundColor: Colors.white,
                                //     backgroundImage: NetworkImage(
                                //       image,
                                //     ))
                                // : CircleAvatar(
                                //     radius: 56,
                                //     backgroundColor: Colors.white,
                                //     child: Icon(Icons.person),
                                //   )

                                // child: Image.asset(
                                //   'assets/profilepic.png',
                                //   fit: BoxFit.contain,
                                // ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    isNotEditable
                        ? Text(
                            "${firstNameController.text} ${lastNameController.text}",
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Container(
                            width: Get.width * 0.6,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: firstNameController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'First Name',
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: lastNameController,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      hintText: 'Last Name',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    isNotEditable
                        ? Text(
                            "${locationController.text}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff918F8F),
                            ),
                          )
                        : Container(
                            width: Get.width * 0.6,
                            child: TextField(
                              controller: locationController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Location',
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    isNotEditable
                        ? Container(
                            width: 270,
                            child: Text(
                              '${descriptionController.text}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: -0.3,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : Container(
                            width: Get.width * 0.6,
                            child: TextField(
                              controller: descriptionController,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                hintText: 'Description',
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 14),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: DefaultTabController(
                        length: 2,
                        initialIndex: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black,
                                    width: 0.01,
                                  ),
                                ),
                              ),
                              child: TabBar(
                                indicatorColor: Colors.black,
                                labelPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 10,
                                ),
                                unselectedLabelColor: Colors.black,
                                tabs: [
                                  Tab(
                                    icon: Image.asset("assets/ticket.png"),
                                    height: 20,
                                  ),
                                  Tab(
                                    icon: Image.asset("assets/Group 18600.png"),
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: screenheight * 0.46,
                              //height of TabBarView
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    color: Colors.white,
                                    width: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 105, right: 35),
                  child: InkWell(
                    onTap: () {
                      if (isNotEditable == false) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'first': firstNameController.text,
                          'last': lastNameController.text,
                          'location': locationController.text,
                          'desc': descriptionController.text
                        }, SetOptions(merge: true)).then((value) {
                          Get.snackbar('Profile Updated',
                              'Profile has been updated successfully.',
                              colorText: Colors.white,
                              backgroundColor: Colors.blue);
                        });
                      }

                      setState(() {
                        isNotEditable = !isNotEditable;
                      });
                    },
                    child: isNotEditable
                        ? Image(
                            image: AssetImage('assets/edit.png'),
                            width: screenwidth * 0.04,
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  margin: EdgeInsets.only(top: 105, right: 35),
                  child: InkWell(
                    onTap: () {
                      if (isNotEditable == false) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'first': firstNameController.text,
                          'last': lastNameController.text,
                          'location': locationController.text,
                          'desc': descriptionController.text
                        }, SetOptions(merge: true)).then((value) {
                          Get.snackbar('Profile Updated',
                              'Profile has been updated successfully.',
                              colorText: Colors.white,
                              backgroundColor: Colors.blue);
                        });
                      }

                      setState(() {
                        isNotEditable = !isNotEditable;
                      });
                    },
                    child: isNotEditable
                        ? Image(
                            image: AssetImage('assets/edit.png'),
                            width: screenwidth * 0.04,
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.black,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ticket Tab',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ReviewTab extends StatefulWidget {
  final TextEditingController reviewController;
  final bool isReviewEditable;
  ReviewTab({required this.reviewController, required this.isReviewEditable});
  @override
  _ReviewTabState createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('reviews').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              document['userName'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Icon(Icons.star, color: Colors.amber),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          document['review'],
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}