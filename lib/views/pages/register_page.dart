import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lara_g_admin/models/create_user_model.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/exception.dart';
import 'package:lara_g_admin/views/pages/login_page.dart';
import 'package:lara_g_admin/widgets/dilogue.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helper.dart';
import '../../util/colors_const.dart';
import '../../util/validator.dart';
import '../components/my_button.dart';

class Registerpage extends StatefulWidget {
  const Registerpage({
    Key? key,
  }) : super(key: key);
  @override
  _RegisterpageState createState() => _RegisterpageState();
}

class _RegisterpageState extends State<Registerpage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  int radioSelected = 1;
  String radioVal = 'male';
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobile = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  UserProvider get provider => context.read<UserProvider>();
  @override
  void initState() {
    super.initState();

    hp = Helper.of(context);
    getdata();
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile.text = prefs.getString(AppConstants.USERMOBILE) ?? '';
    });
    print(mobile.text);
  }

  @override
  Widget build(BuildContext context) {
    var ph = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      /* appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text(
          "Sign Up",
          style: Styles.textStyleLarge(color: Colors.white),
        ),
        centerTitle: true,
      ),*/
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/signup.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 20, top: 270),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            //fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 100, top: 7, right: 50),
                        child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            /*child: Expanded(*/
                            child: Padding(
                              padding: EdgeInsets.only(left: 50, top: 5),
                              child: TextFormField(
                                // textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                                controller: name,
                                obscureText: false,
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    // contentPadding: new EdgeInsets.symmetric(),
                                    border: InputBorder.none,
                                    hintText: 'User name',
                                    hintStyle: TextStyle(color: Colors.white)),
                              ),
                            )
                            //),
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 60, top: 3),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Image(
                                image:
                                    AssetImage('assets/images/user-128.png')),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 100, top: 7, right: 50),
                        child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            //child: Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 50, top: 3),
                              child: TextFormField(
                                // textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                                controller: email,
                                // read: false,
                                obscureText: false,
                                //  hintText: 'Enter your email',
                                validator: Validator.validateEmail,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    // contentPadding: new EdgeInsets.symmetric(),
                                    border: InputBorder.none,
                                    hintText: 'Email address',
                                    hintStyle: TextStyle(color: Colors.white)),
                              ),
                            )
                            //),
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 60, top: 3),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Image(
                                image:
                                    AssetImage('assets/images/email-icon.png')),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 100, top: 7, right: 50),
                        child: Container(
                            height: 55,
                            width: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              color: Colors.grey.withOpacity(0.4),
                            ),
                            //child: Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 50, top: 3),
                              child: TextFormField(
                                // textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                                controller: mobile,
                                //read: true,
                                obscureText: false,
                                validator: Validator.validateMobile,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    // contentPadding: new EdgeInsets.symmetric(),
                                    border: InputBorder.none,
                                    hintText: 'Mobile number',
                                    hintStyle: TextStyle(color: Colors.white)),
                              ),
                            )
                            //),
                            ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 60, top: 3),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Image(
                                image: AssetImage(
                                    'assets/images/confirm-password.png')),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: MyButton(
                          text: provider.isLoading
                              ? "Loading..."
                              : "Register".toUpperCase(),
                          textcolor: const Color(0xffFFFFFF),
                          textsize: 16,
                          fontWeight: FontWeight.w700,
                          letterspacing: 0.7,
                          buttoncolor: AppColor.mainColor,
                          borderColor: AppColor.mainColor,
                          buttonheight: 50,
                          buttonwidth: 150,
                          radius: 5,
                          onTap: () async {
                            if (formKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();

                              await AppDialogue.openLoadingDialogAfterClose(
                                context,
                                text: "Loading...",
                                load: () async {
                                  try {
                                    final response = await provider.register(
                                      name: name.text,
                                      mobile_no: mobile.text,
                                      email: email.text,
                                    );
                                    print(
                                        "UI received response: ${response.data}");
                                    return response;
                                  } catch (e) {
                                    print("UI caught error: $e");
                                    if (e is APIException) {
                                      AppDialogue.toast(e.message);
                                    } else {
                                      AppDialogue.toast(
                                          "An unexpected error occurred.");
                                    }
                                    return null;
                                  }
                                },
                                afterComplete: (resp) async {
                                  if (resp != null && resp.data != null) {
                                    try {
                                      print(
                                          "Processing response in UI: ${resp.data}");

                                      Map<String, dynamic> responseData;
                                      if (resp.data is Map<String, dynamic>) {
                                        responseData = resp.data;
                                      } else if (resp.data is String) {
                                        // If data is a string, use the full response body
                                        responseData = resp.fullBody ??
                                            {
                                              'success': false,
                                              'message': resp.data
                                            };
                                      } else {
                                        responseData = {
                                          'success': false,
                                          'message': 'Invalid response format'
                                        };
                                      }

                                      print(
                                          "Processed response data: $responseData"); // Debug print

                                      if (responseData['success'] == true) {
                                        print(
                                            "Success confirmed, proceeding with navigation");

                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        await prefs.setString(
                                            AppConstants.USERMOBILE,
                                            mobile.text);

                                        // Show success message
                                        AppDialogue.toast(
                                            responseData['message'] ??
                                                "Registration successful");

                                        // Add a small delay before navigation
                                        await Future.delayed(
                                            const Duration(milliseconds: 500));

                                        // Navigate with error handling
                                        try {
                                          if (mounted) {
                                            // Check if widget is still mounted
                                            await AppRouteName.addShoppage
                                                .pushAndRemoveUntil(
                                                    context, (route) => false,
                                                    args: true);
                                          }
                                        } catch (e) {
                                          print("Navigation error: $e");
                                          AppDialogue.toast(
                                              "Error navigating to shop page");
                                        }
                                      } else {
                                        AppDialogue.toast(
                                            responseData['message'] ??
                                                "Registration failed");
                                      }
                                    } catch (e) {
                                      print(
                                          "Error processing response in UI: $e");
                                      AppDialogue.toast(
                                          "Error processing response");
                                    }
                                  } else {
                                    AppDialogue.toast(
                                        "Registration failed. Please try again.");
                                  }
                                },
                              );
                            }
                          }),
                    ),
                  ),

                  // const SizedBox(
                  //   height: 1,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LoginPage()));
                          },
                          child: Text(
                            'Login!',
                            style: TextStyle(
                                color: AppColor.mainColor,
                                fontWeight: FontWeight.w500),
                          ))
                      //   TextButton(
                      //     'Login!',
                      //     style: TextStyle(
                      //       color: AppColor.mainColor,
                      //       fontWeight: FontWeight.w500,
                      //     ),

                      //   )
                    ],
                  ),
                  // SizedBox(
                  //   height: 1,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        // onTap: () {
                        //   launchUrl("https://www.facebook.com");
                        // },
                        onTap: () async {
                          // final url =
                          //     "https://www.facebook.com"; // Replace with your Facebook URL
                          // final Uri uri = Uri.parse(url);

                          // if (await canLaunchUrl(uri.toString() as Uri)) {
                          //   await launchUrl(uri.toString() as Uri);
                          // } else {
                          //   print("Could not launch $url");
                          // }
                        },

                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              //color: Colors.white,
                              image: DecorationImage(
                                image: AssetImage('assets/images/facebook.png'),
                                //fit: BoxFit.fill,
                              )),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            //color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage('assets/images/instagram.png'),
                              //fit: BoxFit.fill,
                            )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
