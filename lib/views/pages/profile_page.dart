import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/views/pages/profile_edit.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helper.dart';
import '../../util/app_constants.dart';
import '../../util/colors_const.dart';
import '../components/my_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Helper hp;
  Future<SharedPreferences> _sharedPrefs = SharedPreferences.getInstance();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(height, 2) + pow(width, 2));
  var name, email, mobile;
  void initState() {
    hp = Helper.of(context);
    getdata();
    super.initState();
  }

  void getdata() async {
    final sharedPrefs = await _sharedPrefs;
    setState(() {
      name = sharedPrefs.getString(AppConstants.USERNAME);
      email = sharedPrefs.getString(AppConstants.USEREMAIL);
      mobile = sharedPrefs.getString(AppConstants.USERMOBILE);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColor.mainColor,
                backgroundImage: AssetImage("assets/images/emplyolees.png"),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Text(
                    name.toString(),
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                        fontSize: 20,
                        color: AppColor.mainColor,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    mobile.toString(),
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xff200303),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    email.toString(),
                    textScaleFactor: 1.0,
                    style: const TextStyle(
                        // fontSize: 10,
                        color: Color(0xff200303),
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  // MyButton(
                  //   text: "Edit",
                  //   textcolor: AppColor.whiteColor,
                  //   textsize: 15,
                  //   fontWeight: FontWeight.w500,
                  //   letterspacing: 0.5,
                  //   buttonwidth: width / 4, // Increase width
                  //   buttonheight: 50, // Increase height
                  //   buttoncolor: AppColor.mainColor,
                  //   radius: 15,
                  //   onTap: () {},
                  // ),
                  GestureDetector(
                    onTap: () {
                      AppRouteName.profile_editpage.push(context);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 160, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColor.mainColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Text(
                            "Edit",
                            style: Styles.textStyleLarge(
                                color: AppColor.whiteColor),
                            textScaler: TextScaler.linear(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
