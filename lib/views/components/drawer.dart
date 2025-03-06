import 'dart:math';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helper.dart';
import '../../route_generator.dart';
import '../../util/app_constants.dart';
import '../../util/colors_const.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
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
    return SafeArea(
      child: Drawer(
        elevation: 50,
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              height: 200,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        //backgroundImage: NetworkImage('$img'),
                        backgroundColor: AppColor.mainColor,
                        radius: 35,
                        child: Icon(
                          Icons.person,
                          size: 60.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name.toString(),
                          textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppColor.mainColor,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          mobile.toString(),
                          textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff200303),
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          email.toString(),
                          textScaleFactor: 1.0,
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xff200303),
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width,
              height: height,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Customdrawer(Icons.home, 'Home', () async {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(AppConstants.APPPAGES, arguments: 0);
                  }),
                  SizedBox(
                    height: height / 70,
                  ),
                  Customdrawer(Icons.star, 'Target', () async {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushNamed(AppConstants.TARGETPAGE, arguments: 0);
                  }),
                  SizedBox(
                    height: height / 70,
                  ),
                  Customdrawer(Icons.logout, 'Logout', () async {
                    logout();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences local_data = await SharedPreferences.getInstance();
    local_data.clear();
    Navigator.of(context, rootNavigator: true).pop();
    AppRouteName.loginpage.pushAndRemoveUntil(context, (route) => false);
  }
}

class Customdrawer extends StatelessWidget {
  IconData icon;
  String text;
  void Function() onTap;
  Customdrawer(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 8.0, 0),
        child: InkWell(
          hoverColor: Colors.yellow.shade700,
          splashColor: Colors.yellow.shade700,
          onTap: onTap,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      icon,
                      size: 25,
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Text(
                      text,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1,
              )
            ],
          ),
        ));
  }
}
