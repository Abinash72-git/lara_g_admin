import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/dialogs.dart';
import '../../util/app_constants.dart';
import '../../util/colors_const.dart';
import '../../util/styles.dart';
import '../components/shop_widget.dart';

class ShopChoosePage extends StatefulWidget {
  @override
  State<ShopChoosePage> createState() => _ShopChoosePageState();
}

class _ShopChoosePageState extends State<ShopChoosePage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  MediaQueryData get dimensions => MediaQuery.of(context);

  Size get size => dimensions.size;

  double get height => size.height;

  double get width => size.width;

  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  GetProvider get provider => context.read<GetProvider>();
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    provider.getShopList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.mainColor,
        title: Text("Choose Shop",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, AppConstants.ADDSHOPPAGE,
              arguments: false);
          //  context.read<GetProvider>().getShopDetails();
          provider.getShopList();
        },
        tooltip: "Add Shop",
        backgroundColor: AppColor.mainColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
        child: Consumer<GetProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColor.mainColor));
            }
            return provider.resultList.isEmpty
                ? Center(
                    child: Text("No Shops Available",
                        style: Styles.textStyleMedium(color: Colors.black)))
                : SingleChildScrollView(
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
                            itemBuilder: (BuildContext context, int index) {
                              final shop = provider.resultList[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: ShopWidget(
                                  image: shop.image,
                                  shopName: shop.shopName,
                                  location: shop.shopLocation,
                                  onTap: () => _showSelectionDialog(
                                      context, shop.shopId),
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
            onPressed: () async {
              await _selectShop(context, shopID);
            },
            child: const Text('Yes', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Future<void> _selectShop(BuildContext context, String shopID) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString(AppConstants.SHOPID, shopID);
    Navigator.of(context, rootNavigator: true).pop();
    Dialogs.snackbar("Shop saved successfully", context, isError: false);
    await Navigator.pushNamedAndRemoveUntil(
        context, AppConstants.APPPAGES, (route) => false,
        arguments: 0);
  }
}
