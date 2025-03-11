import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/purchaselist_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/views/components/menu_widget.dart';
import 'package:lara_g_admin/views/components/my_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseDetailsPage extends StatefulWidget {
  final PurchaseModel purchase;

  const PurchaseDetailsPage({Key? key, required this.purchase})
      : super(key: key);
  @override
  _PurchaseDetailsPageState createState() => _PurchaseDetailsPageState();
}

class _PurchaseDetailsPageState extends State<PurchaseDetailsPage> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  late PurchaseModel purchase;
  bool isloading = false;
  GetProvider get gprovider => context.read<GetProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    purchase = widget.purchase;

    getdata();
  }

  getdata() async {
    setState(() {
      isloading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.TOKEN);

    // Get the productId from the purchase object
    var productId = purchase.productId;

    // Pass token and productId to the provider method
    await gprovider.getInventoryMenuDetails(token!, productId);

    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ph = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        // brightness: Brightness.dark,
        title: Text(
          "Purchase Details",
          style: Styles.textStyleLarge(color: AppColor.whiteColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: AppColor.whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xffFAFAFA),
            child: isloading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.mainColor,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height / 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Product Information",
                                  style: Styles.textStyleLarge()),
                              const SizedBox(
                                width: 15,
                              ),
                              MyButton(
                                text: "Edit",
                                textcolor: AppColor.whiteColor,
                                textsize:
                                    9, // Use a fixed, readable size instead of scaling it with screen width
                                fontWeight: FontWeight.w600,
                                letterspacing: 0.5,
                                buttoncolor: AppColor.mainColor,
                                borderColor: AppColor.mainColor,
                                buttonheight:
                                    40, // Slightly increased for better tap area
                                buttonwidth:
                                    100, // Adjusted for better text fit
                                radius: 12,
                                onTap: () async {
                                  // await Navigator.pushNamed(
                                  //     context, AppConstants.PURCHASEUPDATEPAGE,
                                  //     arguments: purchase);
                                  print(
                                      "Navigating to purchasedetailspage with: ${widget.purchase}");

                                  await AppRouteName.purchaseupdatepage
                                      .push(context, args: purchase);
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Container(
                            width: width,
                            height: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(purchase.productName.toUpperCase(),
                                    style: Styles.textStyleSmall().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(
                                  width: 15,
                                ),
                                purchase.image.isEmpty
                                    ? const CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            "assets/images/writer-img.jpg"))
                                    : CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(purchase.image)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Purchase Cost : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text(purchase.purchaseCost.toString(),
                                    style: Styles.textStyleSmall().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Category : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text(purchase.category,
                                    style: Styles.textStyleSmall().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("MRP : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text(purchase.mrp.toString(),
                                    style: Styles.textStyleSmall().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Quantity : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                SizedBox(
                                  width: width / 2,
                                  child: Text(
                                    purchase.stock.toString(),
                                    style: Styles.textStyleSmall().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Unit : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text(purchase.unit,
                                    style: Styles.textStyleSmall().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height / 80,
                          ),
                          Container(
                            width: width,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColor.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Purchase : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text(purchase.purchaseDate,
                                    style: Styles.textStyleSmall().copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          gprovider.inventoryList.isEmpty
                              ? Container()
                              : Text("Related Menus",
                                  style: Styles.textStyleLarge()),
                          const SizedBox(
                            height: 15,
                          ),
                          gprovider.inventoryList.isEmpty
                              ? Container()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: gprovider.inventoryList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Dismissible(
                                        key: Key(index.toString()),
                                        direction: DismissDirection.none,
                                        background: Container(),
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
                                        child: MenuWidget(
                                          image: gprovider
                                              .inventoryList[index].image,
                                          name: gprovider
                                              .inventoryList[index].menuName,
                                          rate: gprovider
                                              .inventoryList[index].rate
                                              .toString(),
                                          width: width,
                                          height: height,
                                          onTap: () async {
                                            // await Navigator.pushNamed(context,
                                            //     AppConstants.MENUINGREDIENTLISTPAGE,
                                            //     arguments: menuList[index]);
                                            // getdata();
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                          SizedBox(
                            height: height / 80,
                          ),
                        ],
                      ),
                    ),
                  )),
      ),
    );
  }
}
