import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/menu_model.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/views/components/menu_ingredient_widget.dart';
import 'package:lara_g_admin/views/pages/menu/menu_edit_page.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MenuIngredientListPage extends StatefulWidget {
  final MenuModel menu;

  const MenuIngredientListPage({Key? key, required this.menu})
      : super(key: key);
  @override
  _MenuIngredientListPageState createState() => _MenuIngredientListPageState();
}

class _MenuIngredientListPageState extends State<MenuIngredientListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  bool isloading = false;
  late MenuModel menu;
  GetProvider get gprovider => context.read<GetProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    menu = widget.menu;
    getdata();
    print("------------------ ${menu}"); // Debugging step
  }

  getdata() async {
    setState(() {
      isloading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.TOKEN);
    print(
        "-------------------------------- ${widget.menu.menuId}-------------------");

    await gprovider.getMenuIngredients(token.toString(), widget.menu.menuId);
    print("menuIngredients: ${gprovider.menuIngredients.length}");

    setState(() {
      isloading = false; // Make sure to update isloading after fetching data
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
        title: Text("Menu Ingredient Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            var data = {
              "menu": widget.menu,
              "menuIngredients": gprovider.menuIngredients,
            };

            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MenuEditpage(data: data)));

            getdata();
          },
          tooltip: "Edit Menu",
          backgroundColor: AppColor.mainColor,
          child: const Icon(
            Icons.edit,
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
                            gprovider.menuIngredients.isEmpty
                                ? Text(
                                    "No Menu Ingredient Added",
                                    style: Styles.textStyleMedium(
                                        color: AppColor.redColor),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: gprovider.menuIngredients.length,
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
                                                title: Text('Are you sure?'),
                                                content: Text(
                                                    'Do you want to delete this ingredient?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text('No'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      deleteMenuIngredient(
                                                          gprovider
                                                              .menuIngredients[
                                                                  index]
                                                              .menuIngredientId);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: Text('Yes'),
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
                                          child: MenuIngredientWidget(
                                            productimage: gprovider
                                                .menuIngredients[index]
                                                .productImage,
                                            productName: gprovider
                                                .menuIngredients[index]
                                                .productName,
                                            productCategory: gprovider
                                                .menuIngredients[index]
                                                .category,
                                            ingredientQuantity: gprovider
                                                .menuIngredients[index]
                                                .menuIngredientQuantity,
                                            ingredientUnit: gprovider
                                                .menuIngredients[index]
                                                .menuIngredientUnit,
                                            width: width,
                                            height: height,
                                            onTap: () {},
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

  deleteMenuIngredient(String menuIngredientID) async {
    var data = {
      "menu_ingredient_id": menuIngredientID,
    };

    // await _con.deleteMenuIngredient(data);
    // await _con.getEmployeeList();
  }
}
