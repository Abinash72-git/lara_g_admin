import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/saledetails_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/views/components/sale_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SalesListPage extends StatefulWidget {
  @override
  _SalesListPageState createState() => _SalesListPageState();
}

class _SalesListPageState extends State<SalesListPage> {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shopId = prefs.getString(AppConstants.SHOPID);
    await gprovider.getSalesDetails(shopId.toString());

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
        title: Text("Sales Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            await Navigator.pushNamed(context, AppConstants.SALEADDPAGE);
            getdata();
          },
          tooltip: "Add Sale",
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
                  : gprovider.salesList.isEmpty
                      ? Center(
                          child: Text(
                            "No Sale Added",
                            style: Styles.textStyleMedium(
                                color: AppColor.redColor),
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
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: gprovider.salesList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Dismissible(
                                          key: Key(index.toString()),
                                          direction:
                                              DismissDirection.endToStart,
                                          background: Container(),
                                          confirmDismiss:
                                              (DismissDirection direction) {
                                            return showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Are you sure?'.toString()),
                                                content: Text(
                                                    'Do you want delete this sale'
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
                                                      deleteSale(gprovider
                                                          .salesList[index]
                                                          .salesId);
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
                                                      BorderRadius.circular(
                                                          10)),
                                              child: const Center(
                                                child: Icon(Icons.delete,
                                                    color: AppColor.bgColor,
                                                    size: 45),
                                              )),
                                          child: SaleWidget(
                                            totalPreparationCost: gprovider
                                                .salesList[index]
                                                .salePreparationCost
                                                .toString(),
                                            totalPrice: gprovider
                                                .salesList[index].salePrice
                                                .toString(),
                                            profit: (gprovider.salesList[index]
                                                        .salePrice -
                                                    gprovider.salesList[index]
                                                        .salePreparationCost)
                                                .toString(),
                                            createdAt: gprovider
                                                .salesList[index].saleDate,
                                            width: width,
                                            height: height,
                                            onTap: () async {
                                              await Navigator.pushNamed(context,
                                                  AppConstants.SALEMENULISTPAGE,
                                                  arguments: gprovider
                                                      .salesList[index]
                                                      .saleMenuDetails);
                                            },
                                          ),
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

  deleteSale(String salesID) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var data = {
      "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
      "sales_id": salesID,
    };

    //await _con.deleteSale(data);
    // await _con.getEmployeeList();
  }
}
