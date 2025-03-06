import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/models/base_model.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/exception.dart';
import 'package:lara_g_admin/widgets/dilogue.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helper.dart';
import '../components/my_button.dart';

class OTPpage extends StatefulWidget {
  const OTPpage({
    Key? key,
  }) : super(key: key);
  @override
  _OTPpageState createState() => _OTPpageState();
}

class _OTPpageState extends State<OTPpage> {
  late Helper hp;
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController otp = TextEditingController();
  TextEditingController mobile = TextEditingController();
  UserProvider get provider => context.read<UserProvider>();

  bool haserror = false;

  @override
  void initState() {
    super.initState();
    getdata();
    hp = Helper.of(context);
    print("-------------Entering OTP page----------------");
  }

  getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile.text = prefs.getString(AppConstants.USERMOBILE) ?? '';
    });
    print(mobile.text);
  }

  String maskMobileNumber(String number) {
    if (number.length >= 10) {
      return '*******' + number.substring(7);
    }
    return number;
  }

  @override
  Widget build(BuildContext context) {
    //var ph = MediaQuery.of(context).size.height;
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      /*appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.purple[900],
        title:
            Text("Mobile verifications", style: TextStyle(color: Colors.white)),
      ),*/
      body: SafeArea(
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/otp.jpg"),
              fit: BoxFit.fitHeight,
            ),
          ),
          //color: AppColor.whiteColor,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 250,
                  ),
                  Text(
                    'Verfication  Code',
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  /*Padding(
                    padding: const EdgeInsets.only(
                        top: 30, left: 15, right: 15, bottom: 20),
                    child: Center(
                      child: Image.asset(
                        'assets/images/otp8.jpeg',
                        width: 900,
                        height: 200,
                      ),
                    ),
                  ),*/
                  /* Text(
                    'Verfication  Code',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),*/
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Please type the Verfication code',
                    style: TextStyle(color: Colors.amber, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    maskMobileNumber(mobile.text),
                    style: TextStyle(color: Colors.amber, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),

                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '+91 9943770998',
                        style: TextStyle(color: Colors.blue[900]),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            //color: Colors.white,
                            image: DecorationImage(
                              image: AssetImage('assets/images/phone4.jpg'),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ],
                  ),*/
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Align(
                      // alignment: Alignment.topCenter,
                      child: PinCodeTextField(
                        pinBoxHeight: 65,
                        pinBoxWidth: 65,
                        pinBoxRadius: 10,
                        autofocus: true,
                        controller: otp,
                        hideCharacter: true,
                        highlight: true,
                        highlightColor: Colors.white,
                        defaultBorderColor: Colors.white,
                        hasTextBorderColor: Colors.white,
                        errorBorderColor: Colors.red,
                        maxLength: 4,
                        hasError: haserror,
                        maskCharacter: "*", //😎
                        onTextChanged: (text) {},
                        onDone: (text) async {},
                        wrapAlignment: WrapAlignment.spaceEvenly,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.roundedPinBoxDecoration,
                        pinTextStyle: const TextStyle(
                            fontSize: 35.0, color: Colors.black),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinBoxColor: Colors.white,
                        pinTextAnimatedSwitcherDuration:
                            const Duration(milliseconds: 300),
                        //                    highlightAnimation: true,
                        //highlightPinBoxColor: Colors.red,
                        highlightAnimationBeginColor: Colors.red,
                        highlightAnimationEndColor: Colors.white12,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  /* Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Didn't get OTP? ",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      MyButton(
                        text: "Resend code".toUpperCase(),
                        textcolor: Colors.white,
                        textsize: 16,
                        fontWeight: FontWeight.w700,
                        letterspacing: 0.7,
                        buttoncolor: Color.fromARGB(255, 9, 123, 130),
                        buttonheight: 50,
                        buttonwidth: width / 2.5,
                        radius: 5,
                        onTap: () async {
                          Dialogs.snackbar("OTP sent successfully", context,
                              isError: false);
                        },
                      ),
                    ],
                  ),*/
                  /* SizedBox(
                    height: height / 18,
                  ),*/
                  Align(
                    alignment: Alignment.center,
                    child: MyButton(
                      text: provider.isLoading
                          ? "Loading..."
                          : "Verify".toUpperCase(),
                      textcolor: Colors.white,
                      textsize: 20,
                      fontWeight: FontWeight.w700,
                      letterspacing: 0.7,
                      buttoncolor: Colors.amber,
                      borderColor: AppColor.mainColor,
                      buttonheight: 55,
                      buttonwidth: 300,
                      radius: 5,
                      onTap: () async {
                        if (otp.text.length == 4) {
                          FocusScope.of(context).unfocus();
                          try {
                            await AppDialogue.openLoadingDialogAfterClose(
                              context,
                              text: "Loading...",
                              load: () async {
                                return await provider.verifyOTP(
                                  mobile: mobile.text,
                                  otp: otp.text,
                                );
                              },
                              afterComplete: (resp) async {
                                print("Inside afterComplete...");
                                if (resp.status) {
                                  print("Response is successful");
                                  BaseModel baseModel =
                                      BaseModel.fromMap(resp.fullBody);
                                  print(
                                      "Response message: ${baseModel.message}");

                                  if (baseModel.message == "login success") {
                                    print("✅ Navigation to Home Page...");
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      AppRouteName.appPage.pushAndRemoveUntil(
                                        context,
                                        (route) => false,
                                      );
                                    });
                                  } else if (baseModel.message ==
                                      "Not registered") {
                                    print(
                                        "🟡 User is not registered, navigate to registration...");

                                    // Add navigation to registration page if needed
                                    Future.delayed(Duration(milliseconds: 300),
                                        () {
                                      AppRouteName.registerpage
                                          .pushAndRemoveUntil(
                                        context,
                                        (route) => false,
                                      );
                                    });
                                  } else {
                                    print(
                                        "❌ Unexpected response: ${baseModel.message}");
                                    AppDialogue.toast(
                                        "Unexpected response: ${baseModel.message}");
                                  }
                                }
                              },
                            );
                          } on Exception catch (e) {
                            ExceptionHandler.showMessage(context, e);
                          }
                        } else {
                          AppDialogue.toast("Please enter a valid 4-digit OTP");
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  //Row(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  // children: [
                  Text(
                    "Didn't get OTP RESENT !",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  /* Text(
                        'RESENT!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      )*/
                  /*  MyButton(
                        text: "Resend code".toUpperCase(),
                        textcolor: Colors.white,
                        textsize: 16,
                        fontWeight: FontWeight.w700,
                        letterspacing: 0.7,
                        buttoncolor: Color.fromARGB(255, 9, 123, 130),
                        buttonheight: 50,
                        buttonwidth: width / 2.5,
                        radius: 5,
                        onTap: () async {
                          Dialogs.snackbar("OTP sent successfully", context,
                              isError: false);
                        },
                      ),*/
                  //],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  verifyOTP() async {
    setState(() {
      //   _con.isloading = true;
      // });

      // await _con.verifyOTP(widget.mobile, otp.text);

      // setState(() {
      //   _con.isloading = false;
    });
  }
}
