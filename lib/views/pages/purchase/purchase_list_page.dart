import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/models/purchaselist_model.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/views/components/product_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PurchaseListPage extends StatefulWidget {
  @override
  _PurchaseListPageState createState() => _PurchaseListPageState();
}

class _PurchaseListPageState extends State<PurchaseListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  bool isloading = false;
  List<ProductModel> productList = [];
  List _selectedIndexs = [];
  List<PurchaseModel> purchaseList = [];
  int? si;
  GetProvider get gprovider => context.read<GetProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    getdata();
  }

  getdata() async {
    setState(() {
      isloading = true;
    });
    print("-------------------purchase page-------------");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shopId = prefs.getString(AppConstants.SHOPID);
    String? token = prefs.getString(AppConstants.TOKEN);

    await gprovider.getPurchaseList(shopId.toString(), "");
    await gprovider.getProductCategories(token.toString());

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text("Purchase Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () async {
          await AppRouteName.purchaseProductSelectPage.push(context);
          getdata();
        },
        tooltip: "Add purchase",
        backgroundColor: AppColor.mainColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
          child: Container(
              width: width,
              height: height,
              color: AppColor.bgColor,
              child: isloading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.mainColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            gprovider.purchaseList.isEmpty
                                ? Text(
                                    "No Purchase Added",
                                    style: Styles.textStyleMedium(
                                        color: AppColor.redColor),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: gprovider.purchaseList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Dismissible(
                                        key: Key(index.toString()),
                                        direction: DismissDirection.endToStart,
                                        background: Container(),
                                        confirmDismiss:
                                            (DismissDirection direction) {
                                          return showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  'Are you sure?'.toString()),
                                              content: Text(
                                                  'Do you want delete this purchase'
                                                      .toString()),
                                              titleTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              contentTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Text(
                                                    'No'.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    deletePurchase(gprovider
                                                        .purchaseList[index]
                                                        .purchaseId);
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Text(
                                                    'Yes'.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        secondaryBackground: Container(
                                            decoration: BoxDecoration(
                                                color: AppColor.redColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Center(
                                              child: Icon(Icons.delete,
                                                  color: AppColor.bgColor,
                                                  size: 45),
                                            )),
                                        child: ProductWidget(
                                            image: gprovider
                                                .purchaseList[index].image,
                                            name: gprovider.purchaseList[index]
                                                .productName,
                                            rate: gprovider.purchaseList[index]
                                                .purchaseCost
                                                .toString(),
                                            itemCount: gprovider
                                                .purchaseList[index].stock
                                                .toString(),
                                            stockMinValue: "",
                                            isStockMin: false,
                                            width: width,
                                            height: height,
                                            edit: () async {
                                              print(
                                                  "Navigating to purchaseupdatepage with: ${gprovider.purchaseList[index]}");
                                              await AppRouteName
                                                  .purchaseupdatepage
                                                  .push(
                                                context,
                                                args: gprovider
                                                    .purchaseList[index],
                                              );
                                              getdata();
                                            },
                                            delete: () async {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: Text('Are you sure?'
                                                      .toString()),
                                                  content: Text(
                                                      'Do you want delete this purchase'
                                                          .toString()),
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          color: Colors.black),
                                                  contentTextStyle:
                                                      const TextStyle(
                                                          color: Colors.black),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(false),
                                                      child: Text(
                                                        'No'.toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () async {
                                                        deletePurchase(gprovider
                                                            .purchaseList[index]
                                                            .purchaseId);
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: Text(
                                                        'Yes'.toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            onTap: () async {
                                              print(
                                                  "Navigating to purchasedetailspage with: ${gprovider.purchaseList[index]}");
                                              await AppRouteName
                                                  .purchasedetailspage
                                                  .push(
                                                context,
                                                args: gprovider.purchaseList[
                                                    index], // Passing selected purchase item
                                              );
                                            }),
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
}

deletePurchase(String purchaseID) async {
  final sharedPrefs = await SharedPreferences.getInstance();
  var data = {
    "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
    "purchase_id": purchaseID,
  };

  // await _con.deletePurchase(data);
  // await _con.getEmployeeList();
}
