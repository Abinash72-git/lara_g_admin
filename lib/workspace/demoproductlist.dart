import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/models/product_category_model.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/views/components/product_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/helper.dart';
import '../../../models/route_argument.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';

class DemoProductListPage extends StatefulWidget {
  @override
  _DemoProductListPageState createState() => _DemoProductListPageState();
}

class _DemoProductListPageState extends State<DemoProductListPage> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late Helper hp;
  List<ProductModel> productList = [];
  List<ProductCategoryModel> productCategoriesList = [];
  int? si;
  List _selectedIndexs = [];
  bool isloading = false;

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    getdata();
  }

  // Fetch product data and categories
  getdata() async {
    final userProvider = Provider.of<GetProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString(AppConstants.TOKEN);

    setState(() {
      isloading = true;
    });

    // Fetch the product list and categories
    await userProvider.getProductList();
    await userProvider
        .getProductCategories(token.toString()); // Fetch categories

    setState(() {
      productList = userProvider.productList;
      productCategoriesList =
          userProvider.productcategories; // Ensure this list is populated
      isloading = false;
    });
  }

  // Filter products by category
  void productSearch(value) {
    setState(() {
      productList = productList
          .where((product) => product.productCategoryId == value)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<GetProvider>(context);

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
        title: Text("Product Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            await AppRouteName.product_add.push(context,
                args: RouteArgument(data: {'route': 'Add', 'product': 'cscc'}));
            getdata();
          },
          tooltip: "Add product",
          backgroundColor: AppColor.mainColor,
          child: const Icon(Icons.add, color: Colors.white)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SafeArea(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                            const SizedBox(height: 15),
                            // Category selection
                            Container(
                              height: 40,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListView.builder(
                                shrinkWrap: false,
                                scrollDirection: Axis.horizontal,
                                itemCount: productCategoriesList.length,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 2),
                                itemBuilder: (BuildContext context, int index) {
                                  final _isSelected =
                                      _selectedIndexs.contains(index);
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (_isSelected) {
                                          _selectedIndexs.remove(si);
                                          productList =
                                              userProvider.productList;
                                        } else {
                                          _selectedIndexs.remove(si);
                                          _selectedIndexs.add(index);
                                          si = index;
                                          productSearch(
                                              productCategoriesList[index]
                                                  .productCategoryId);
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 7),
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 3.0,
                                              ),
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: _isSelected
                                                ? AppColor.mainColor
                                                : AppColor.whiteColor),
                                        child: Center(
                                          child: Text(
                                            productCategoriesList[index]
                                                .productCategoryName,
                                            style: Styles.textStyleLarge(
                                                    color: _isSelected
                                                        ? AppColor.whiteColor
                                                        : AppColor.mainColor)
                                                .copyWith(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                            // Product list display
                            productList.isEmpty
                                ? Text(
                                    "No Product Added",
                                    style: Styles.textStyleMedium(
                                        color: AppColor.redColor),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: productList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Dismissible(
                                        key: Key(index.toString()),
                                        direction: DismissDirection.horizontal,
                                        background: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          alignment: Alignment.centerLeft,
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: const Icon(Icons.edit,
                                              color: Colors.white, size: 45),
                                        ),
                                        secondaryBackground: Container(
                                          decoration: BoxDecoration(
                                              color: AppColor.redColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          alignment: Alignment.centerRight,
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: const Icon(Icons.delete,
                                              color: AppColor.bgColor,
                                              size: 45),
                                        ),
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          if (direction ==
                                              DismissDirection.startToEnd) {
                                            await AppRouteName.product_add.push(
                                                context,
                                                args: RouteArgument(data: {
                                                  "route": "Update",
                                                  "product": productList[index],
                                                }));
                                            getdata();
                                            return false;
                                          } else {
                                            return showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Are you sure?'),
                                                content: Text(
                                                    'Do you want delete this product'),
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
                                                    child: Text('No',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      deleteProduct(
                                                          productList[index]
                                                              .productId);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: Text('Yes',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                        child: ProductWidget(
                                          image: productList[index].image,
                                          name: productList[index].productName,
                                          rate:
                                              productList[index].mrp.toString(),
                                          itemCount: productList[index]
                                              .stock
                                              .toString(),
                                          stockMinValue: productList[index]
                                              .stockMinValue
                                              .toString(),
                                          isStockMin:
                                              productList[index].isStockMin,
                                          width: width,
                                          height: height,
                                          edit: () async {
                                            await AppRouteName.product_add.push(
                                                context,
                                                args: RouteArgument(data: {
                                                  'route': 'Update',
                                                  'product': productList[index]
                                                }));
                                            getdata();
                                          },
                                          delete: () async {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text('Are you sure?'),
                                                content: Text(
                                                    'Do you want delete this product'),
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
                                                    child: Text('No',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      deleteProduct(
                                                          productList[index]
                                                                  .productId
                                                              as String);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: Text('Yes',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ),
                                                ],
                                              ),
                                            );
                                            getdata();
                                          },
                                          onTap: () async {
                                            await Navigator.pushNamed(context,
                                                AppConstants.PRODUCTDETAILSPAGE,
                                                arguments: productList[index]);
                                          },
                                        ),
                                      );
                                    }),
                            const SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ))),
    );
  }

  deleteProduct(String productID) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var data = {
      "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
      "product_id": productID,
    };

    // Make the delete request here
    // await provider.deleteproduct(data);
  }
}
