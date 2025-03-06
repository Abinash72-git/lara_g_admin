import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/widgets/dilogue.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helper.dart';
import '../../util/styles.dart';
import '../../util/validator.dart';
import '../components/my_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Helper hp;

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController mobile = TextEditingController();
  bool isLoading = false;

  List<String> countrycode = ['+91', '+94', '+92', '+41', '+65'];
  String setCountryCode = '+91';

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/mobile.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                const SizedBox(height: 390),
                Text(
                  'Please Enter your 10 digit mobile number to begin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Container(
                        height: width * 0.16,
                        width: height * 0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.grey.withOpacity(0.4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 80, top: 5),
                          child: TextFormField(
                            style: TextStyle(fontSize: 15.0),
                            controller: mobile,
                            keyboardType: TextInputType.number,
                            validator: Validator.validateMobile,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Enter your mobile number',
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 9),
                      child: CircleAvatar(
                        radius: 29,
                        backgroundColor: Colors.white,
                        child: DropdownButton(
                          underline: const SizedBox(),
                          style: Styles.textStyleMedium(),
                          dropdownColor: Colors.white,
                          value: setCountryCode,
                          onChanged: (newValue) {
                            setState(() {
                              setCountryCode = newValue.toString();
                            });
                          },
                          items: countrycode.map((code) {
                            return DropdownMenuItem(
                              value: code,
                              child: Text(
                                code,
                                style: TextStyle(fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  'Don’t worry! Your details are safe with us',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Align(
                  child: MyButton(
                    text: isLoading ? "Sending..." : "Next".toUpperCase(),
                    textcolor: Colors.black,
                    textsize: 19,
                    fontWeight: FontWeight.w700,
                    letterspacing: 0.7,
                    buttoncolor: const Color.fromRGBO(27, 94, 32, 1), borderColor: AppColor.mainColor,
                    buttonheight: 45,
                    buttonwidth: 110,
                    radius: 5,
                    onTap: () async {
                      print(
                          "-----------------Login Button Clicked----------------");
                      if (formKey.currentState!.validate()) {
                        // isLoading ? null : login();
                        FocusScope.of(context).unfocus();

                        await AppDialogue.openLoadingDialogAfterClose(context,
                            text: "Loading...", load: () async {
                          return await provider.sendOTP(mobile: mobile.text);
                        }, afterComplete: (resp) async {
                          print("Response Status: ${resp.status}");
                          print("Response Data: ${resp.data}");
                          if (resp.status) {
                            print("sucess");
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            await prefs.setString(
                                AppConstants.USERMOBILE, mobile.text);
                            AppDialogue.toast(resp.data);
                            print("Navigating to OTP Screen...");
                            AppRouteName.verifyOtp.push(context);
                          } else {
                            print("OTP Send Failed");
                          }
                        });
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // login() async {
  //   setState(() {
  //     isLoading = true;
  //   });

  //   //await _con.sendOTP(mobile.text);

  //   setState(() {
  //     isLoading = false;
  //   });
  // }
}
