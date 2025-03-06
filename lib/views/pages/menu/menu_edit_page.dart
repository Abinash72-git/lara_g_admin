import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lara_g_admin/helpers/dialogs.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/menu_model.dart';
import 'package:lara_g_admin/models/menuingredients_model.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/util/textfields_widget.dart';
import 'package:lara_g_admin/util/validator.dart';
import 'package:lara_g_admin/views/components/my_button.dart';
import 'package:lara_g_admin/views/components/product_select_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MenuEditpage extends StatefulWidget {
  final dynamic data;

  const MenuEditpage({Key? key, required this.data}) : super(key: key);

  @override
  _MenuEditpageState createState() => _MenuEditpageState();
}

class _MenuEditpageState extends State<MenuEditpage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  int radioSelected = 1;
  String radioVal = 'male';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController menuName = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController preparationCost = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController productname = TextEditingController();
  TextEditingController menuDate = TextEditingController();
  String productIDs = '';
  String productNames = '';
  String quantities = '';
  String units = '';
  String productID = '';
  String unit = '';
  final picker = ImagePicker();
  File? profilepic;
  String img64 = '';
  String showUnit = '';
  List<String> unitdrop = ['Kg', 'Gram', 'Litre', 'ML', 'None'];
  String? unitvalue;
  List<ProductModel> product = [];
  bool isproductselect = false;
  List<String> productnames = [];
  List<String> quanties = [];
  List<String> unitss = [];
  List<String> prices = [];
  double preCost = 0.0;
  double prdPrice = 0.0;
  double prd1KGprice = 0.0;
  double prd1Gramprice = 0.0;
  double prd1MLprice = 0.0;
  double prd1Litreprice = 0.0;
  late MenuModel menu;
  List<MenuIngredientModel> menuIngredients = [];
  bool isloading = false;
  GetProvider get gprovider => context.read<GetProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    print("-------------------> Entering menu edit page<---------------");
    print("Received data in MenuEditPage: ${widget.data}"); // Debug print
    menu = widget.data['menu'];
    menuIngredients = widget.data['menuIngredients'];

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getdata();
    });
  }

  getdata() async {
    setState(() {
      isloading = true;
    });

    await gprovider.getProductList();

    setState(() {
      product = gprovider.productList;
      menu = widget.data['menu'];
      menuIngredients = widget.data['menuIngredients'];
      menuName.text = menu.menuName;
      rate.text = menu.rate.toString();
      preparationCost.text = menu.preparationCost.toString();
      menuDate.text = menu.menuDate.toString();
      preCost = double.parse(menu.preparationCost.toString());
      isloading = false;
    });
  }

  void productSearch(value) {
    setState(() {
      isproductselect = false;
      product = gprovider.productList
          .where((productList) => productList.productName
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var ph = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text(
          "Edit Menu",
          style: Styles.textStyleLarge(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.bgColor,
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.mainColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Stack(
                          children: [
                            profilepic != null
                                ? Container(
                                    width: 150,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(profilepic!),
                                          fit: BoxFit.cover,
                                        ),
                                        color: AppColor.whiteColor),
                                  )
                                : Container(
                                    width: 150,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(menu.image),
                                          fit: BoxFit.fill,
                                        ),
                                        color: AppColor.whiteColor),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  bottomSheetImage();
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColor.mainColor,
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      size: 15,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: menuName,
                                read: false,
                                obscureText: false,
                                hintText: 'Enter menu name',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      ),
                                    ]),
                                child: Column(
                                  children: [
                                    CustomTextFormField(
                                      controller: productname,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'Enter product name',
                                      keyboardType: TextInputType.text,
                                      fillColor: AppColor.whiteColor,
                                      onchanged: (value) {
                                        productSearch(value);
                                        return '';
                                      },
                                    ),
                                    productname.text.isEmpty || isproductselect
                                        ? Container()
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            itemCount: product.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return ProductSelectWidget(
                                                image: product[index].image,
                                                productName:
                                                    product[index].productName,
                                                onTap: () async {
                                                  setState(() {
                                                    productname.text =
                                                        product[index]
                                                            .productName;
                                                    productID = product[index]
                                                        .productId;
                                                    unit = product[index].unit;
                                                    showUnit =
                                                        product[index].unit;
                                                    prdPrice = double.parse(
                                                        product[index]
                                                            .purchaseCost
                                                            .toString());

                                                    isproductselect = true;
                                                  });
                                                },
                                              );
                                            }),
                                    productname.text.isEmpty || isproductselect
                                        ? Container()
                                        : const SizedBox(
                                            height: 10,
                                          ),
                                    showUnit == ''
                                        ? const SizedBox()
                                        : const SizedBox(
                                            height: 10,
                                          ),
                                    showUnit == ''
                                        ? const SizedBox()
                                        : Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 45,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: AppColor.mainColor),
                                                color: AppColor.whiteColor),
                                            child: Center(
                                              child: Text(
                                                "Product Unit : " + showUnit,
                                                style: Styles.textStyleMedium(),
                                              ),
                                            ),
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: AppColor.mainColor),
                                          color: AppColor.whiteColor),
                                      child: DropdownButton(
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 30,
                                        ),
                                        style: Styles.textStyleMedium(),
                                        dropdownColor: AppColor.whiteColor,
                                        hint: Text('Please select unit',
                                            style: Styles.textStyleMedium(
                                                color: AppColor.hintTextColor)),
                                        value: unitvalue,
                                        onChanged: (newValue) {
                                          setState(() {
                                            unitvalue = newValue.toString();
                                          });
                                        },
                                        items: unitdrop.map((countrycode) {
                                          return DropdownMenuItem(
                                            child: Text(countrycode.toString()),
                                            value: countrycode,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomTextFormField(
                                      controller: quantity,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'Enter quantity',
                                      keyboardType: TextInputType.number,
                                      fillColor: AppColor.whiteColor,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MyButton(
                                      text: "Add".toUpperCase(),
                                      textcolor: const Color(0xffFFFFFF),
                                      textsize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterspacing: 0.7,
                                      buttoncolor: AppColor.mainColor,
                                      borderColor: AppColor.mainColor,
                                      buttonheight: 40,
                                      buttonwidth: width / 5,
                                      radius: 5,
                                      onTap: () async {
                                        if (isproductselect) {
                                          setState(() {
                                            productnames.add(productname.text);
                                            quanties.add(quantity.text);
                                            unitss.add(unitvalue!);
                                            productNames = productNames == ''
                                                ? productname.text
                                                : productNames +
                                                    "###" +
                                                    productname.text;
                                            quantities = quantities == ''
                                                ? quantity.text
                                                : quantities +
                                                    "###" +
                                                    quantity.text;
                                            productIDs = productIDs == ''
                                                ? productID
                                                : productIDs +
                                                    "###" +
                                                    productID;
                                            units = units == ''
                                                ? unitvalue!
                                                : units + "###" + unitvalue!;

                                            double c = 0.0;
                                            // 'Kg', 'Gram', 'Litre', 'ML', 'None'
                                            if (unitvalue == 'Kg') {
                                              c = prd1KGprice *
                                                  double.parse(quantity.text);
                                            } else if (unitvalue == 'Gram') {
                                              c = prd1Gramprice *
                                                  double.parse(quantity.text);
                                            } else if (unitvalue == 'Litre') {
                                              c = prd1Litreprice *
                                                  double.parse(quantity.text);
                                            } else if (unitvalue == 'ML') {
                                              c = prd1MLprice *
                                                  double.parse(quantity.text);
                                            } else {
                                              c = prdPrice *
                                                  double.parse(quantity.text);
                                            }
                                            prices.add(c.toString());
                                            preCost = preCost + c;
                                            preparationCost.text =
                                                preCost.toString();
                                            productname.clear();
                                            quantity.clear();
                                            showUnit = '';
                                          });
                                        } else {
                                          Dialogs.snackbar(
                                              "Please select the product",
                                              context,
                                              isError: true);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: preparationCost,
                                read: true,
                                obscureText: false,
                                hintText: 'Preparation Cost',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                fillColor: Colors.grey.shade200,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: rate,
                                read: false,
                                obscureText: false,
                                hintText: 'Enter rate',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: CustomTextFormField(
                                      controller: menuDate,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'Date',
                                      validator: Validator.notEmpty,
                                      keyboardType: TextInputType.text,
                                      fillColor: AppColor.whiteColor,
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "Menu Ingredients",
                          style: Styles.textStyleLarge(color: Colors.black),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        menuIngredients.isEmpty
                            ? Container()
                            : Table(
                                columnWidths: const {0: FlexColumnWidth(2.5)},
                                children: [
                                  TableRow(children: [
                                    Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(15.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Product name',
                                          style: Styles.textStyleLarge(
                                              color: AppColor.mainColor),
                                        ))),
                                    Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Unit',
                                          style: Styles.textStyleLarge(
                                              color: AppColor.mainColor),
                                        ))),
                                    Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Quantity',
                                          style: Styles.textStyleLarge(
                                              color: AppColor.mainColor),
                                        ))),
                                    Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Delete',
                                          style: Styles.textStyleLarge(
                                              color: AppColor.mainColor),
                                        ))),
                                  ]),
                                ],
                              ),
                        menuIngredients.isEmpty
                            ? Container()
                            : ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: menuIngredients.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Table(columnWidths: const {
                                    0: FlexColumnWidth(2.5)
                                  }, children: [
                                    TableRow(children: [
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: const BorderRadius.only(
                                              bottomLeft:
                                                  Radius.circular(15.0)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          menuIngredients[index].productName,
                                          style: Styles.textStyleMedium(
                                              color: Colors.black),
                                        )),
                                      ),
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                        ),
                                        child: Center(
                                            child: Text(
                                          menuIngredients[index]
                                              .menuIngredientUnit,
                                          style: Styles.textStyleMedium(
                                              color: Colors.black),
                                        )),
                                      ),
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                        ),
                                        child: Center(
                                            child: Text(
                                          menuIngredients[index]
                                              .menuIngredientQuantity,
                                          style: Styles.textStyleMedium(
                                              color: Colors.black),
                                        )),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  'Are you sure?'.toString()),
                                              content: Text(
                                                  'Do you want delete this ingredient'
                                                      .toString()),
                                              titleTextStyle: const TextStyle(
                                                  color: Colors.black),
                                              contentTextStyle: const TextStyle(
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
                                                    deleteMenuIngredient(
                                                        menuIngredients[index]
                                                            .menuIngredientId,
                                                        index);
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
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                          ),
                                          child: const Center(
                                              child: Icon(
                                            Icons.close,
                                            color: AppColor.redColor,
                                          )),
                                        ),
                                      ),
                                    ])
                                  ]);
                                }),
                        const SizedBox(
                          height: 35,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MyButton(
                            text: isloading
                                ? "Loading..."
                                : "Submit".toUpperCase(),
                            textcolor: const Color(0xffFFFFFF),
                            textsize: 16,
                            fontWeight: FontWeight.w700,
                            letterspacing: 0.7,
                            buttoncolor: AppColor.mainColor,
                            borderColor: AppColor.mainColor,
                            buttonheight: 50,
                            buttonwidth: width / 2.5,
                            radius: 5,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                isloading ? null : editMenu();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  bottomSheetImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: const Text(
                        'Photo Library',
                      ),
                      onTap: () {
                        getPicFromGallery();
                      }),
                  ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text(
                        'Camera',
                      ),
                      onTap: () {
                        getPicFromCam();
                      }),
                ],
              ),
            ),
          );
        });
  }

  Future getPicFromCam() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (pickedFile != null) {
        profilepic = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
  }

  Future getPicFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        profilepic = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
  }

  DateTime selectedDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950, 1),
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColor.mainColor,
              onPrimary: AppColor.whiteColor,
              surface: AppColor.mainColor,
              onSurface: AppColor.blackColor,
            ),
            dialogBackgroundColor: AppColor.whiteColor,
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        var formatter = DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(selectedDate);
        menuDate.value = TextEditingValue(text: formatted.toString());
      });
    }
  }

  deleteMenuIngredient(String menuIngredientID, int index) async {
    var data = {
      "menu_ingredient_id": menuIngredientID,
    };
    menuIngredients.removeAt(index);
    Navigator.of(context, rootNavigator: true).pop();
    setState(() {});
  }

  editMenu() async {
    setState(() {
      isloading = true;
    });

    final sharedPrefs = await SharedPreferences.getInstance();
    String? shopId = sharedPrefs.getString(AppConstants.SHOPID);

    var data = {
      "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
      "menu_id": menu.menuId,
      "menu_name": menuName.text,
      "menu_image": img64.isEmpty ? "" : img64,
      "rate": rate.text,
      "menu_date": menuDate.text,
      "product_id": productIDs,
      "product_name": productNames,
      "quantity": quantities,
      "unit": units,
      "preparation_cost": preparationCost.text
    };

    try {
      // Call the API to update the menu
      await gprovider.updateMenu(
          shopId: shopId.toString(),
          menuId: menu.menuId,
          menuName: menuName.text,
          preparationCost: preparationCost.text,
          rate: rate.text,
          menuDate: menuDate.text,
          menuImage: img64.isEmpty ? "" : img64,
          productIds: productIDs.split("###"),
          productNames: productNames.split("###"),
          quantities: quantities.split("###"),
          units: units.split("###"));

      setState(() {
        isloading = false;
      });

      // Show a success message (optional)
      Dialogs.snackbar("Menu updated successfully", context, isError: false);

      // Navigate to the previous screen
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isloading = false;
      });

      // Show error message if the update fails
      Dialogs.snackbar('Error updating menu: $e', context, isError: true);
    }
  }
}
