import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/helper.dart';
import '../../util/app_constants.dart';
import '../../util/colors_const.dart';
import '../components/drawer.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  // late UserController _con; // Declare it as late
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  UserProvider get provider => context.read<UserProvider>();
  GetProvider get gprovider => context.read<GetProvider>();
  bool isloading = false;
  @override
  void initState() {
    super.initState();
    // _con = UserController(); // Initialize _con
    hp = Helper.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getdata();
    });
  }

  // getdata() async {
  // setState(() {
  //   _con.isloading = true;
  // });
  // SharedPreferences localStorage = await SharedPreferences.getInstance();

  // bool check = localStorage.containsKey(AppConstants.SHOPID);

  // if (check) {
  //   await _con.getShop();
  // } else {
  //   await _con.getShopList();
  //   localStorage.setString(AppConstants.SHOPID, _con.shopList[0].shopId);
  //   await _con.getShop();
  // }
  // await _con.getProfile();

  // setState(() {
  //   _con.isloading = false;
  // });
  //}
  getdata() async {
    setState(() {
      isloading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? shopId = prefs.getString(AppConstants.SHOPID);

    print('-------------- ShopID $shopId ---------------');

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight -
        kBottomNavigationBarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      drawer: MyDrawer(),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
          icon: const ImageIcon(
            AssetImage("assets/images/menu_icon.png"),
          ),
        ),
        backgroundColor: AppColor.mainColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Text(
                'Burger World',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.w500,
                  fontSize: 25,
                ),
              ),
            ),
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              backgroundImage: AssetImage("assets/images/emplyolees.png"),
              child: GestureDetector(
                onLongPress: () {
                  AppRouteName.shop_list.push(context);
                },
                onTap: () {
                  print('singletap');
                },
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
              width: _width,
              height: _height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/home_bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.mainColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20,
                              ),
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    // await Navigator.pushNamed(
                                    //     context, AppConstants.EMPLOYEESPAGE);
                                    await AppRouteName.employeePage
                                        .push(context);
                                  },
                                  child: orderContainer(
                                      "assets/images/emplyolees.png",
                                      'Employees'),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // await Navigator.pushNamed(
                                    //     context, AppConstants.MENULISTPAGE);
                                    await AppRouteName.menuList_page
                                        .push(context);
                                  },
                                  child: orderContainer(
                                      "assets/images/menu.png", 'Menu'),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await AppRouteName.purchase_list
                                        .push(context);
                                  },
                                  child: orderContainer(
                                      "assets/images/purchase.png", 'Purchase'),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // await Navigator.pushNamed(context,
                                    //     AppConstants.CAPITALEXPENSELISTPAGE);
                                    await AppRouteName.capitalExpense_page
                                        .push(context);
                                  },
                                  child: orderContainer(
                                      "assets/images/capital-expense.png",
                                      'Capital Expense'),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // await Navigator.pushNamed(
                                    //     context, AppConstants.SALESLISTPAGE);
                                    await AppRouteName.salesListpage
                                        .push(context);
                                  },
                                  child: orderContainer(
                                      "assets/images/sales.png", 'Sales'),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // await Navigator.pushNamed(
                                    //     context, AppConstants.PRODUCTLISTPAGE);
                                    await AppRouteName.product_list
                                        .push(context);
                                  },
                                  child: orderContainer(
                                      "assets/images/products.png", 'Products'),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.pushNamed(context,
                                        AppConstants.INVENTORYPURCHASELISTPAGE);
                                  },
                                  child: orderContainer(
                                      "assets/images/purchase.png",
                                      'Inventory Purchase'),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                        context, AppConstants.WASTAGELISTPAGE);
                                  },
                                  child: orderContainer(
                                      "assets/images/wastage.png", 'Wastage'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ))),
    );
  }

  Widget orderContainer(image, text,
      {Color color = AppColor.whiteColor, double elevation = 2.0}) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight -
        kBottomNavigationBarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            height: _height * 0.5,
            width: _width * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.green[900],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: elevation,
                  blurRadius: elevation,
                  offset: Offset(0, elevation),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 0, top: 20, bottom: 0),
                  child: Container(
                    height: 105,
                    width: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Image.asset(
                        image,
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15), //changed 15
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
