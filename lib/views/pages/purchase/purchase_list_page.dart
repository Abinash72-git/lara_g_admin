import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
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

    //  await _con.getPurchaseList("");
    await gprovider.getPurchaseList(shopId.toString(), "");

    // await await _con.getProductCategoriesList();
    await gprovider.getDProductCategories(token.toString());

    setState(() {
      isloading = false;
    });
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
        title: Text("Purchase Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            // await Navigator.pushNamed(context, AppConstants.PURCHASEADDPAGE);
            // await Navigator.pushNamed(
            //     context, AppConstants.PURCHASEPRODUCTSELECTPAGE);///
            await AppRouteName.purchaseProductSelectPage.push(
              context,
            );
            getdata();
          },
          tooltip: "Add purchase",
          backgroundColor: AppColor.mainColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          )),
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
                            gprovider.productList.isEmpty
                                ? Text(
                                    "No Purchase Added",
                                    style: Styles.textStyleMedium(
                                        color: AppColor.redColor),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: gprovider.productList.length,
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
                                                  // fontFamily: 'Fingbanger',
                                                  color: Colors.black),
                                              contentTextStyle: const TextStyle(
                                                  // fontFamily: 'Fingbanger',
                                                  color: Colors.black),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  child: Text(
                                                    'No'.toString(),
                                                    style: const TextStyle(
                                                        // fontFamily: 'Fingbanger',
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    deletePurchase(gprovider
                                                        .productList[index]
                                                        .productId);
                                                    Navigator.of(context)
                                                        .pop(true);
                                                  },
                                                  child: Text(
                                                    'Yes'.toString(),
                                                    style: const TextStyle(
                                                        // fontFamily: 'Fingbanger',
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
                                              .productList[index].image,
                                          name: gprovider
                                              .productList[index].productName,
                                          rate: gprovider
                                              .productList[index].purchaseCost
                                              .toString(),
                                          itemCount: gprovider
                                              .productList[index].stock
                                              .toString(),
                                          stockMinValue: "",
                                          isStockMin: false,
                                          width: width,
                                          height: height,
                                          edit: () async {
                                            // await Navigator.pushNamed(context,
                                            //     AppConstants.PURCHASEUPDATEPAGE,
                                            //     arguments: gprovider
                                            //         .productList[index]);

                                            getdata();
                                          },
                                          delete: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Are you sure?'.toString()),
                                                content: Text(
                                                    'Do you want delete this purchase'
                                                        .toString()),
                                                titleTextStyle: const TextStyle(
                                                    // fontFamily: 'Fingbanger',
                                                    color: Colors.black),
                                                contentTextStyle: const TextStyle(
                                                    // fontFamily: 'Fingbanger',
                                                    color: Colors.black),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text(
                                                      'No'.toString(),
                                                      style: const TextStyle(
                                                          // fontFamily: 'Fingbanger',
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      deletePurchase(gprovider
                                                          .productList[index]
                                                          .productId);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: Text(
                                                      'Yes'.toString(),
                                                      style: const TextStyle(
                                                          // fontFamily: 'Fingbanger',
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          onTap: () async {
                                            await Navigator.pushNamed(
                                                context,
                                                AppConstants
                                                    .PURCHASEDETAILSPAGE,
                                                arguments: gprovider
                                                    .productList[index]);
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

  deletePurchase(String purchaseID) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var data = {
      "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
      "purchase_id": purchaseID,
    };

    /// await _con.deletePurchase(data);////
    // await _con.getEmployeeList();
  }
}
