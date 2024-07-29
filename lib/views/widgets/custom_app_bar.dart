import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newevent/utils/color.dart';
import 'package:newevent/views/auth/login_signup.dart';


import 'my_widgets.dart';

Widget CustomAppBar(){
  return Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Container(
                        width: 116,
                        height: 17,
                        child: myText(
                            text: 'EMS',
                            style: TextStyle(
                                color: AppColors.blue,
                                fontWeight: FontWeight.bold,fontSize: 16)),
                      ),
                      Spacer(),
                      Container(
                        width: 24,
                        height: 22,
                        child: InkWell(
                          onTap: () {
                          //  Get.to(() => UserNotificationScreen());
                          },
                          child:
                         
                           Image.asset('assets/Frame.png'),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.04,
                      ),
                      InkWell(
                        onTap: ()async {

                          await FirebaseAuth.instance.signOut();
                        },
                        child: GestureDetector(onTap: ()async{
                          await FirebaseAuth.instance.signOut();
                          Get.to(LoginView());
                        },
                          child: Container(
                            width: 22,
                            height: 20,
                            child: Icon(Icons.logout)
                            //Image.asset(
                              //'assets/menu.png',
                            //),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
                
}