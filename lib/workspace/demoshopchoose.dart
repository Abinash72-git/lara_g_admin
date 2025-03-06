import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/views/components/shop_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/dialogs.dart';

class DemoShopChoosePage extends StatefulWidget {
  @override
  State<DemoShopChoosePage> createState() => _DemoShopChoosePageState();
}

class _DemoShopChoosePageState extends State<DemoShopChoosePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Fetch data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isInitialized) {
        context.read<GetProvider>().getShopList();
        isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        title: Text(
          "Choose Shop",
          style: Styles.textStyleMedium(color: AppColor.whiteColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<GetProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.mainColor,
                ),
              );
            }

            if (provider.resultList.isEmpty) {
              return Center(
                child: Text(
                  "No Shops Available",
                  style: Styles.textStyleMedium(color: Colors.black),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.resultList.length,
                      itemBuilder: (context, index) {
                        final shop = provider.resultList[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ShopWidget(
                            image: shop.image,
                            shopName: shop.shopName,
                            location: shop.shopLocation,
                            onTap: () => _showSelectionDialog(
                              context,
                              shop.shopId,
                            ),
                            edit: () {},
                            iseditoption: false,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Action for FAB, e.g., navigate to a new page or add a new shop
          // Navigator.pushNamed(context, '/addShop');
          print(
              "__________________Floating button is clciked______________________");
          await AppRouteName.addShoppage.push(context, args: false);
        },
        backgroundColor: AppColor.mainColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showSelectionDialog(BuildContext context, String shopID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Do you want to select this shop?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => _selectShop(context, shopID),
            child: const Text('Yes', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectShop(BuildContext context, String shopID) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setString(AppConstants.SHOPID, shopID);
      print("------------- ${AppConstants.SHOPID}");

      Navigator.of(context).pop(); // Close dialog

      Dialogs.snackbar("Shop saved successfully", context, isError: false);

      await AppRouteName.appPage.pushAndRemoveUntil(context, (route) => false);
    } catch (e) {
      Dialogs.snackbar("Error saving shop", context, isError: true);
    }
  }
}
