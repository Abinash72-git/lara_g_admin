import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/saledetails_model.dart';
import 'package:lara_g_admin/models/salemenudetails.dart';
import 'package:lara_g_admin/models/salemenumodel.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/menu_widget.dart';
import '../components/sale_menu_widget.dart';

class SaleMenuListPage extends StatefulWidget {
  final List<SaleMenuDetails> saleMenu;
  final List<MenuDetails> menuDetails;


  const SaleMenuListPage({Key? key, required this.saleMenu,required this.menuDetails}) : super(key: key);
  @override
  _SaleMenuListPageState createState() => _SaleMenuListPageState();
}

class _SaleMenuListPageState extends State<SaleMenuListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.whiteColor,
            )),
        backgroundColor: AppColor.mainColor,
        title: Text("Sale Menu Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Container(
              width: width,
              height: height,
              color: AppColor.bgColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      widget.saleMenu.isEmpty
                          ? Text(
                              "No Sale Menu Added",
                              style: Styles.textStyleMedium(
                                  color: AppColor.redColor),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.saleMenu.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: SaleMenuWidget(
                                    image: widget.menuDetails[index].image,
                                    name: widget.menuDetails[index].menuName,
                                    rate: widget.menuDetails[index].rate.toString(),
                                    quantity:
                                        widget.saleMenu[index].menuQuantity.toString(),
                                    width: width,
                                    height: height,
                                    onTap: () async {
                                      // await Navigator.pushNamed(
                                      //     context, AppConstants.ADDEMPLOYEEPAGE,
                                      //     arguments: "Update");
                                    },
                                  ),
                                );
                              }),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  deleteMenu(String menuID) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var data = {
      "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
      "menu_id": menuID,
    };

   // await _con.deleteMenu(data);
    // await _con.getEmployeeList();
  }
}
