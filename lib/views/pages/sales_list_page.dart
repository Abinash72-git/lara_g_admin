import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/dialogs.dart';
import 'package:lara_g_admin/helpers/helper.dart';

import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
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
  UserProvider get provider => context.read<UserProvider>();

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
            // await Navigator.pushNamed(context, AppConstants.SALEADDPAGE);
            await AppRouteName.salesAddpage.push(context);
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
                                          key: Key(gprovider.salesList[index]
                                              .salesId), // Use a unique identifier
                                          direction:
                                              DismissDirection.endToStart,
                                          background: Container(),
                                          confirmDismiss: (DismissDirection
                                              direction) async {
                                            final bool? result =
                                                await showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Are you sure?'.toString()),
                                                content: Text(
                                                    'Do you want delete this sale'
                                                        .toString()),
                                                titleTextStyle: const TextStyle(
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
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      // Close the dialog
                                                      Navigator.of(context)
                                                          .pop(true);
                                                      // The actual deletion happens in onDismissed
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

                                            return result;
                                          },
                                          onDismissed: (direction) {
                                            // This runs after the user has confirmed and the item has been dismissed
                                            final salesId = gprovider
                                                .salesList[index].salesId;

                                            // Remove from the UI immediately
                                            final removedItem =
                                                gprovider.salesList[index];
                                            setState(() {
                                              gprovider.salesList
                                                  .removeAt(index);
                                            });

                                            // Then make the API call
                                            deleteSale(salesId).then((success) {
                                              // If deletion fails, put the item back
                                              if (!success) {
                                                setState(() {
                                                  gprovider.salesList.insert(
                                                      index, removedItem);
                                                });

                                                // Show error message
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Failed to delete sale. Please try again.'),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } else {
                                                // Show success message
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        'Sale deleted successfully'),
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                );
                                              }
                                            });
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
                                              await AppRouteName
                                                  .salesMenuListpage
                                                  .push(
                                                context,
                                                args: {
                                                  'saleMenu': gprovider
                                                      .salesList[index]
                                                      .saleMenu,
                                                  'menuDetails': gprovider
                                                      .salesList[index].saleMenu
                                                      .map((e) => e.menuDetails)
                                                      .toList(),
                                                },
                                              );
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

  Future<bool> deleteSale(String salesID) async {
    print('----------- delete--------');
    final sharedPrefs = await SharedPreferences.getInstance();
    String? token = sharedPrefs.getString(AppConstants.TOKEN);
    String? shopId = sharedPrefs.getString(AppConstants.SHOPID);

    if (token != null && shopId != null) {
      var response = await provider.deleteSale(
        token: token,
        shopId: shopId,
        salesId: salesID,
      );

      return response.status;
    } else {
      print('Token or Shop ID is missing');
      return false;
    }
  }
}
