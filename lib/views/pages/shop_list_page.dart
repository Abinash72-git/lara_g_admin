import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/dialogs.dart';
import '../../helpers/helper.dart';
import '../../util/app_constants.dart';
import '../../util/colors_const.dart';
import '../../util/styles.dart';
import '../components/shop_widget.dart';

class ShopListPage extends StatefulWidget {
  @override
  _ShopListPageState createState() => _ShopListPageState();
}

class _ShopListPageState extends State<ShopListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  bool isLoading = false;

  GetProvider get provider => context.read<GetProvider>();
  UserProvider get _provider => context.read<UserProvider>();
  @override
  void initState() {
    super.initState();

    hp = Helper.of(context);

    // Use addPostFrameCallback to ensure that we only run the async method after the first build
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getdata();
    });
  }

  getdata() async {
    setState(() {
      isLoading = true;
    });
    // Set loading before the async call

    await provider.getShopList();

    // Fetch token after getting shop details
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AppConstants.TOKEN);

    // Ensure that token is not null and properly fetched before passing it to deleteShop
    if (token != null) {
      var shopId = prefs.getString(AppConstants.SHOPID);
      setState(() {
        isLoading = false;
      });
    } else {
      // Handle the error if token is not found
      print("Token not found");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        backgroundColor: AppColor.mainColor,
        title: Text('Shop list'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () async {
            await AppRouteName.appPage.push(context, args: 0);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      key: scaffoldKey,
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            await AppRouteName.addShoppage.push(context, args: false);
            getdata();
          },
          tooltip: "Add Shop",
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
              child: isLoading
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
                            provider.resultList.isEmpty
                                ? Text(
                                    "No Shop Added",
                                    style: Styles.textStyleMedium(
                                        color: AppColor.redColor),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: provider.resultList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: AppColor.redColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top:
                                                    10, // Slight space from the top
                                                right:
                                                    10, // Slight space from the right
                                                child: Icon(
                                                  Icons.delete,
                                                  color: AppColor
                                                      .whiteColor, // You can set this color to your design color
                                                  size:
                                                      30, // Adjust icon size if needed
                                                ),
                                              ),
                                              Dismissible(
                                                key: Key(index.toString()),
                                                confirmDismiss:
                                                    (DismissDirection
                                                        direction) {
                                                  return showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title:
                                                          Text('Are you sure?'),
                                                      content: Text(
                                                          'Do you want delete this shop?'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: Text('No'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            deleteShop(provider
                                                                .resultList[
                                                                    index]
                                                                .shopId);
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true);
                                                          },
                                                          child: Text('Yes'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: ShopWidget(
                                                  image: provider
                                                      .resultList[index].image,
                                                  shopName: provider
                                                      .resultList[index]
                                                      .shopName,
                                                  location: provider
                                                      .resultList[index]
                                                      .shopLocation,
                                                  onTap: () async {
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        title: Text(
                                                            'Are you sure?'),
                                                        content: Text(
                                                            'Do you want select this shop?'),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false),
                                                            child: Text('No'),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              selectShop(provider
                                                                  .resultList[
                                                                      index]
                                                                  .shopId);
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  edit: () async {
                                                    await Navigator.pushNamed(
                                                      context,
                                                      AppConstants
                                                          .SHOPUPDATEPAGE,
                                                      arguments: provider
                                                          .resultList[index],
                                                    );
                                                    getdata();
                                                  },
                                                  iseditoption: true,
                                                ),
                                              ),
                                            ],
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

  deleteShop(String shopID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AppConstants.TOKEN);

    if (token != null) {
      // Pass token correctly to deleteShop method
      await _provider.deleteShop(shopId: shopID, token: token);
    } else {
      // Handle missing token
      print("Token is missing");
    }
  }

  selectShop(String shopID) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    localStorage.setString(AppConstants.SHOPID, shopID.toString());
    Navigator.of(context, rootNavigator: true).pop();
    Dialogs.snackbar("Shop saved successfully", context, isError: false);
    // await Navigator.pushNamedAndRemoveUntil(
    //     context, AppConstants.APPPAGES, Helper.of(context).predicate,
    //     arguments: 0);
    await AppRouteName.appPage
        .pushAndRemoveUntil(context, (route) => false, args: 0);
  }
}
