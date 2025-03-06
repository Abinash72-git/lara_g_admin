import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lara_g/models/purchase_model.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../controllers/user_controller.dart';
import '../../helpers/helper.dart';
import '../../models/employee_model.dart';
import '../../models/route_argument.dart';
import '../../util/app_constants.dart';
import '../../util/colors_const.dart';
import '../../util/styles.dart';
import '../components/menu_widget.dart';
import '../components/my_button.dart';

class PurchaseDetailsPage extends StatefulWidget {
  final PurchaseModel purchase;

  const PurchaseDetailsPage({Key? key, required this.purchase})
      : super(key: key);
  @override
  _PurchaseDetailsPageState createState() => _PurchaseDetailsPageState();
}

class _PurchaseDetailsPageState extends StateMVC<PurchaseDetailsPage> {
  late UserController _con;
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  late PurchaseModel purchase;
  _PurchaseDetailsPageState() : super(UserController()) {
    _con = controller as UserController;
  }
  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    purchase = widget.purchase;

    getdata();
  }

  getdata() async {
    setState(() {
      _con.isloading = true;
    });
    var data = {"product_id": purchase.productId};
    await _con.getInventoryMenuList(data);

    setState(() {
      _con.isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ph = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.mainColor,
       // brightness: Brightness.dark,
        title: Text(
          "Purchase Details",
          style: Styles.textStyleLarge(color: MyColors.whiteColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: MyColors.whiteColor,
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
            child: _con.isloading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: MyColors.mainColor,
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
                                textcolor: MyColors.whiteColor,
                                textsize: 13,
                                fontWeight: FontWeight.w500,
                                letterspacing: 0.5,
                                buttoncolor: MyColors.mainColor,
                                buttonheight: 25,
                                buttonwidth: width / 5,
                                radius: 15,
                                onTap: () async {
                                  await Navigator.pushNamed(
                                      context, AppConstants.PURCHASEUPDATEPAGE,
                                      arguments: purchase);
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
                              color: MyColors.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(purchase.productname.toUpperCase(),
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
                              color: MyColors.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Purchase Cost : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text(purchase.cost,
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
                              color: MyColors.containerbg,
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
                              color: MyColors.containerbg,
                            ),
                            padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("MRP : ",
                                    style: Styles.textStyleSmall()
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Text(purchase.mrp,
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
                              color: MyColors.containerbg,
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
                                    purchase.stock,
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
                              color: MyColors.containerbg,
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
                              color: MyColors.containerbg,
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
                          _con.inventoryList.isEmpty
                              ? Container()
                              : Text("Related Menus",
                                  style: Styles.textStyleLarge()),
                          const SizedBox(
                            height: 15,
                          ),
                          _con.inventoryList.isEmpty
                              ? Container()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _con.inventoryList.length,
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
                                                color: MyColors.redColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: const Center(
                                              child: Icon(Icons.delete,
                                                  color: MyColors.bgColor,
                                                  size: 45),
                                            )),
                                        child: MenuWidget(
                                          image:
                                              _con.inventoryList[index].image,
                                          name: _con
                                              .inventoryList[index].menuname,
                                          rate: _con.inventoryList[index].rate,
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
