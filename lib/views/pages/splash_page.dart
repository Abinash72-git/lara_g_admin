import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/route_generator.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _MySplashState createState() => _MySplashState();
}

class _MySplashState extends State<Splash> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    Timer(const Duration(seconds: 2), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString(AppConstants.TOKEN);
      var isFirst = prefs.getBool(AppConstants.ISFIRSTREGISTER);
      var shopId = prefs.getString(AppConstants.SHOPID);
      navigate(token, isFirst);
      print("---------------------------- $token ---------------------------");
      print(
          "----------------------------isFirst $isFirst ---------------------------");
      print("----------------------- $shopId ----------------------");
    });
  }

  navigate(token, isFirst) async {
    if (isFirst == true) {
      await AppRouteName.addShoppage
          .pushAndRemoveUntil(context, (route) => false, args: true);
    } else {
      if (token == null) {
        await AppRouteName.loginpage.push(context);
      } else {
        await AppRouteName.appPage
            .pushAndRemoveUntil(context, (route) => false);
      }
    }
  }

  // navigate(token, isFirst) async {
  //   if (isFirst == 'Yes') {
  //     await Navigator.pushNamedAndRemoveUntil(
  //         context, AppConstants.ADDSHOPPAGE, Helper.of(context).predicate,
  //         arguments: true);
  //   } else {
  //     if (token == null) {
  //       final p = await Navigator.pushNamedAndRemoveUntil(
  //           context, AppConstants.LOGIN, Helper.of(context).predicate);
  //     } else {
  //       final p = await Navigator.pushNamedAndRemoveUntil(
  //           context, AppConstants.APPPAGES, Helper.of(context).predicate,
  //           arguments: 0);
  //       print(p);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/splash.jpg"),
                fit: BoxFit.cover,
              ),
              color: AppColor.whiteColor),
          child: Center(
            child: DefaultTextStyle(
              style: Styles.textStyleExtraHugeBold(
                color: AppColor.mainColor,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  ScaleAnimatedText(''),
                ],
                onTap: () {
                  print("Tap Event");
                },
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 2500),
                displayFullTextOnTap: true,
                stopPauseOnTap: true,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
