import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lara_g_admin/views/pages/homepage.dart';
import 'package:lara_g_admin/views/pages/profile_page.dart';
import 'package:lara_g_admin/views/pages/shop_list_page.dart';
import 'package:lara_g_admin/workspace/demopage.dart';

import '../../util/colors_const.dart';
import '../../util/styles.dart';

class AppPages extends StatefulWidget {
  final int tabNumber;
  AppPages({required this.tabNumber});
  @override
  AppPagesState createState() => AppPagesState();
}

class AppPagesState extends State<AppPages> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int index;
  late Widget page;
  late DateTime currentBackPressTime;
  bool ispageset = false;
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  @override
  void initState() {
    super.initState();
    index = widget.tabNumber;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
          key: scaffoldKey,
          body: ispageset ? page : Homepage(),
          backgroundColor: Colors.white,
          bottomNavigationBar: BottomNavigationBar(
              iconSize: 40,
              unselectedItemColor: Colors.white,
              selectedItemColor: AppColor.whiteColor,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.green[900],
              unselectedLabelStyle: Styles.textStyleSmall(),
              selectedLabelStyle:
                  Styles.textStyleSmall(color: AppColor.whiteColor),
              items: const [
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("assets/images/home.png"),
                    ),
                    label: "Home"),
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("assets/images/shops.png"),
                    ),
                    label: "Shop"),
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("assets/images/shops-account.png"),
                    ),
                    label: "Accounts"),
                BottomNavigationBarItem(
                    icon: ImageIcon(
                      AssetImage("assets/images/my-accounts.png"),
                    ),
                    label: "Profile"),
              ],
              currentIndex: index,
              onTap: selectTab),
          resizeToAvoidBottomInset: false),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void selectTab(int i) {
    setState(() {
      index = i;
      switch (index) {
        case 0:
          page = Homepage();
          break;
        case 1:
          page = ShopListPage();

          break;
        case 2:
          page = Demopage();
          break;
        case 3:
          page = ProfilePage();

          break;
        default:
          page = Homepage();
          break;
      }
      ispageset = true;
    });
  }

  Future<bool> onWillPop() async {
    if (index != 0) {
      index = 0;
      selectTab(index);
      return Future.value(false);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        final p = await Fluttertoast.showToast(msg: "Tap Again to Exit");
        return Future.value(!p!);
      }
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(true);
    }
  }
}
