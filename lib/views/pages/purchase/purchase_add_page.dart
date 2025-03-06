import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lara_g_admin/helpers/dialogs.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/menu_model.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/services/api_service.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/util/textfields_widget.dart';
import 'package:lara_g_admin/util/validator.dart';
import 'package:lara_g_admin/views/components/my_button.dart';
import 'package:lara_g_admin/views/components/product_select_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class PurchaseAddpage extends StatefulWidget {
  final RouteArgument data;

  const PurchaseAddpage({Key? key, required this.data}) : super(key: key);
  @override
  _PurchaseAddpageState createState() => _PurchaseAddpageState();
}

class _PurchaseAddpageState extends State<PurchaseAddpage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int radioSelected = 1;
  String radioVal = 'Direct';
  TextEditingController productname = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController purchaseDate = TextEditingController();
  TextEditingController menucost = TextEditingController();
  TextEditingController menuName = TextEditingController();
  List<MenuModel> menu = [];
  bool ismenuselect = false;
  List<String> menunames = [];
  List<String> menuids = [];
  final picker = ImagePicker();
  File? profilepic;
  String img64 = '';
  String productCategory = '';
  String menuID = '';
  late ProductModel product;
  String? productCategoryID;
  bool isproductselect = false;
  List<String> unit = ['Kg', 'Gram', 'Litre', 'ML', 'None'];
  String? unitvalue;
  String? menuCategoryId;
  bool isloading = false;
  GetProvider get gprovider => context.read<GetProvider>();
  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    getcat();
    if (widget.data.data['isproductselect'] == 'true') {
      productname.text = widget.data.data['product_name'];
      product = widget.data.data['product'];
      isproductselect = false;
      productCategoryID = product.productCategoryId;
    } else {
      productname.text = widget.data.data['product_name'];
      isproductselect = true;
    }
  }

  getcat() async {
    setState(() {
      isloading = true;
    });

    print(
        '------------------------- coming into add purchase page---------------');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString(AppConstants.TOKEN);
    //await _con.getProductCategoryList();//
    await gprovider.getProductCategories(token.toString());
    //await _con.getMenuCategoryList();//
    await provider.getMenuCategoriesList();
    // await _con.getMenuList();//
    await gprovider.getMenuList();
    setState(() {
      menu = gprovider.menuList;
      isloading = false;
    });
  }

  void menuSearch(value) {
    setState(() {
      ismenuselect = false;
      menu = gprovider.menuList
          .where((menuList) =>
              menuList.menuName.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var ph = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text(
          "Add Purchase",
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
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColor.bannerBGColor,
                                    backgroundImage: FileImage(profilepic!),
                                  )
                                : const CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColor.bannerBGColor,
                                    backgroundImage: AssetImage(
                                        "assets/images/writer-img.jpg"),
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
                                controller: productname,
                                read: true,
                                obscureText: false,
                                hintText: 'Enter product name',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: cost,
                                read: false,
                                obscureText: false,
                                hintText: 'Enter total purchase cost',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                inputformat: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: stock,
                                read: false,
                                obscureText: false,
                                hintText: 'Enter total purchase quantity',
                                // validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                inputformat: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                fillColor: AppColor.whiteColor,
                              ),
                              !isproductselect
                                  ? const SizedBox()
                                  : const SizedBox(
                                      height: 10,
                                    ),
                              !isproductselect
                                  ? const SizedBox()
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.mainColor),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xffFFFFFF),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: DropdownButton<dynamic>(
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          dropdownColor:
                                              const Color(0xffFFFFFF),
                                          hint: Text("Please select category"),
                                          value: productCategoryID,
                                          items: gprovider.productcategories
                                              .map((category) {
                                            return DropdownMenuItem<String>(
                                              value: category.productCategoryId,
                                              child: Text(
                                                  category.productCategoryName),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              productCategoryID = value;
                                            });
                                            print(
                                                "Selected category: $productCategoryID");
                                          },
                                        ),
                                      ),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: AppColor.mainColor),
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
                                  hint: Text('Enter purchase unit',
                                      style: Styles.textStyleMedium(
                                          color: AppColor.hintTextColor)),
                                  value: unitvalue,
                                  onChanged: (newValue) {
                                    setState(() {
                                      unitvalue = newValue.toString();
                                    });
                                  },
                                  items: unit.map((countrycode) {
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
                              GestureDetector(
                                  onTap: () => _selectDate(context),
                                  child: AbsorbPointer(
                                    child: CustomTextFormField(
                                      controller: purchaseDate,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'Date',
                                      validator: Validator.notEmpty,
                                      keyboardType: TextInputType.text,
                                      fillColor: AppColor.whiteColor,
                                    ),
                                  )),
                              !isproductselect
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Direct',
                                            style: Styles.textStyleMedium(),
                                          ),
                                          Radio(
                                            value: 1,
                                            groupValue: radioSelected,
                                            activeColor: AppColor.mainColor,
                                            onChanged: (value) {
                                              setState(() {
                                                radioSelected = 1;
                                                radioVal = 'Direct';
                                              });
                                            },
                                          ),
                                          Text(
                                            'In Direct',
                                            style: Styles.textStyleMedium(),
                                          ),
                                          Radio(
                                            value: 2,
                                            groupValue: radioSelected,
                                            activeColor: AppColor.mainColor,
                                            onChanged: (value) {
                                              setState(() {
                                                radioSelected = 2;
                                                radioVal = 'Non Direct';
                                              });
                                            },
                                          ),
                                          Text(
                                            'Inventory',
                                            style: Styles.textStyleMedium(),
                                          ),
                                          Radio(
                                            value: 3,
                                            groupValue: radioSelected,
                                            activeColor: AppColor.mainColor,
                                            onChanged: (value) {
                                              setState(() {
                                                radioSelected = 3;
                                                radioVal = 'Inventory';
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              radioVal != 'Direct'
                                  ? const SizedBox()
                                  : CustomTextFormField(
                                      controller: mrp,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'Enter MRP (One quantity MRP)',
                                      validator: Validator.notEmpty,
                                      keyboardType: TextInputType.number,
                                      inputformat: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      fillColor: AppColor.whiteColor,
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              radioVal != 'Direct'
                                  ? const SizedBox()
                                  : Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColor.mainColor),
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(0xffFFFFFF),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: DropdownButton<dynamic>(
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            dropdownColor:
                                                const Color(0xffFFFFFF),
                                            hint: Text(
                                                "Please select menu category"),
                                            value: menuCategoryId,
                                            items: provider.menuCategoriesList
                                                .map((category) {
                                              return DropdownMenuItem<String>(
                                                value: category.menuCategoryId,
                                                child: Text(
                                                    category.menuCategoryName),
                                              );
                                            }).toList(),
                                            onChanged: (value) async {
                                              setState(() {
                                                menuCategoryId = value;
                                              });

                                              print(menuCategoryId);
                                            }),
                                      ),
                                    ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // CustomTextFormField(
                              //   controller: mrp,
                              //   read: false,
                              //   obscureText: false,
                              //   hintText: 'Enter MRP',
                              //   validator: Validator.notEmpty,
                              //   keyboardType: TextInputType.number,
                              //   inputformat: [
                              //     FilteringTextInputFormatter.digitsOnly
                              //   ],
                              //   fillColor: AppColor.whiteColor,
                              // ),
                              radioVal != 'Inventory'
                                  ? const SizedBox()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextFormField(
                                                controller: menuName,
                                                read: false,
                                                obscureText: false,
                                                hintText: 'Menu',
                                                // validator: Validator.notEmpty,
                                                keyboardType:
                                                    TextInputType.text,
                                                fillColor: AppColor.whiteColor,
                                                onchanged: (value) {
                                                  menuSearch(value);
                                                  return '';
                                                },
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            MyButton(
                                              text: "Add".toUpperCase(),
                                              textcolor:
                                                  const Color(0xffFFFFFF),
                                              textsize: 16,
                                              fontWeight: FontWeight.w700,
                                              letterspacing: 0.7,
                                              buttoncolor: AppColor.mainColor,
                                              borderColor: AppColor.mainColor,
                                              buttonheight: 40,
                                              buttonwidth: 70,
                                              radius: 10,
                                              onTap: () async {
                                                if (ismenuselect) {
                                                  setState(() {
                                                    menunames
                                                        .add(menuName.text);
                                                    menuids.add(menuID);
                                                    menuName.clear();
                                                    menuID = '';
                                                  });
                                                } else {
                                                  Dialogs.snackbar(
                                                      "Please select the menu",
                                                      context,
                                                      isError: true);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        menuName.text.isEmpty || ismenuselect
                                            ? Container()
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                itemCount: menu.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ProductSelectWidget(
                                                    image: menu[index].image,
                                                    productName:
                                                        menu[index].menuName,
                                                    onTap: () async {
                                                      setState(() {
                                                        menuName.text =
                                                            menu[index]
                                                                .menuName;
                                                        menuID =
                                                            menu[index].menuId;
                                                        ismenuselect = true;
                                                      });
                                                    },
                                                  );
                                                }),
                                        menuName.text.isEmpty || ismenuselect
                                            ? Container()
                                            : const SizedBox(
                                                height: 20,
                                              ),
                                        menunames.isEmpty
                                            ? Container()
                                            : Table(
                                                columnWidths: const {
                                                  0: FlexColumnWidth(2.5)
                                                },
                                                children: [
                                                  TableRow(children: [
                                                    Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15.0)),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        'Menu name',
                                                        style: Styles
                                                            .textStyleLarge(
                                                                color: AppColor
                                                                    .mainColor),
                                                      )),
                                                    ),
                                                    Container(
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[200],
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        'Delete',
                                                        style: Styles
                                                            .textStyleLarge(
                                                                color: AppColor
                                                                    .mainColor),
                                                      )),
                                                    ),
                                                  ]),
                                                ],
                                              ),
                                        menunames.isEmpty
                                            ? Container()
                                            : ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemCount: menunames.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return Table(
                                                      columnWidths: const {
                                                        0: FlexColumnWidth(2.5)
                                                      },
                                                      children: [
                                                        TableRow(children: [
                                                          Container(
                                                            height: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .grey[200],
                                                              borderRadius: const BorderRadius
                                                                  .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          15.0)),
                                                            ),
                                                            child: Center(
                                                                child: Text(
                                                              menunames[index],
                                                              style: Styles
                                                                  .textStyleMedium(
                                                                      color: Colors
                                                                          .black),
                                                            )),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  title: Text(
                                                                      'Are you sure?'
                                                                          .toString()),
                                                                  content: Text(
                                                                      'Do you want remove this menu'
                                                                          .toString()),
                                                                  titleTextStyle:
                                                                      const TextStyle(
                                                                          // fontFamily: 'Fingbanger',
                                                                          color:
                                                                              Colors.black),
                                                                  contentTextStyle:
                                                                      const TextStyle(
                                                                          // fontFamily: 'Fingbanger',
                                                                          color:
                                                                              Colors.black),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Navigator.of(context).pop(false),
                                                                      child:
                                                                          Text(
                                                                        'No'.toString(),
                                                                        style: const TextStyle(
                                                                            // fontFamily: 'Fingbanger',
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        setState(
                                                                            () {
                                                                          menunames
                                                                              .removeAt(index);
                                                                        });
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'Yes'
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            // fontFamily: 'Fingbanger',
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .grey[200],
                                                              ),
                                                              child:
                                                                  const Center(
                                                                      child:
                                                                          Icon(
                                                                Icons.close,
                                                                color: AppColor
                                                                    .redColor,
                                                              )),
                                                            ),
                                                          ),
                                                        ])
                                                      ]);
                                                }),
                                      ],
                                    )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MyButton(
                            text:
                                isloading ? "Loading..." : "Add".toUpperCase(),
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
                                if (img64 == '' && isproductselect) {
                                  Dialogs.snackbar("Please add image", context,
                                      isError: true);
                                } else if (unitvalue == null) {
                                  Dialogs.snackbar(
                                      "Please select unit", context,
                                      isError: true);
                                } else if (productCategoryID == null) {
                                  Dialogs.snackbar(
                                      "Please select category", context,
                                      isError: true);
                                } else {
                                  isloading ? null : addpurchase();
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
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
                        style: TextStyle(
                            // fontFamily: 'Fingbanger',
                            ),
                      ),
                      onTap: () {
                        getPicFromGallery();
                      }),
                  ListTile(
                      leading: const Icon(Icons.photo_camera),
                      title: const Text(
                        'Camera',
                        style: TextStyle(
                            // fontFamily: 'Fingbanger',
                            ),
                      ),
                      onTap: () {
                        getPicFromCam();
                      } //getPicFromCam
                      ),
                ],
              ),
            ),
          );
        });
  }

  Future getPicFromCam() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        profilepic = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
    // _cropImage();
  }

  Future getPicFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        profilepic = File(pickedFile.path);
      }
    });
    Navigator.pop(context);
    // _cropImage();
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
        // dob = formatted.toString();

        purchaseDate.value = TextEditingValue(text: formatted.toString());
      });
    }
  }

  addpurchase() async {
    setState(() {
      isloading = true;
    });

    // Calculate purchase cost per unit
    dynamic pc = int.parse(cost.text).round() / int.parse(stock.text).round();

    // Get the shop ID from SharedPreferences
    final sharedPrefs = await SharedPreferences.getInstance();
    String shopId = sharedPrefs.getString(AppConstants.SHOPID).toString();

    // Prepare the data to send to the provider
    var data = {
      "shop_id": shopId,
      "product_name": productname.text,
      "category": isproductselect ? radioVal : product.category,
      "purchase_cost": pc.toString(),
      "mrp": mrp.text.isEmpty ? "0" : mrp.text,
      "stock": stock.text,
      "product_status": isproductselect ? "New" : "Old",
      "product_image": isproductselect ? img64 : '',
      "product_id": isproductselect ? '' : product.productId,
      "unit": unitvalue,
      "purchase_date": purchaseDate.text,
      "product_category_id": productCategoryID,
      "menu_rate": radioVal == 'Direct' ? mrp.text : "",
      "menu_category_id": menuCategoryId ?? "",
    };

    // Add menu ids to the request data if present
    for (int i = 0; i < menuids.length; i++) {
      data.addAll({"menuids[$i]": menuids[i]});
    }

    try {
      // Call the provider method to add purchase
      await provider.addPurchase(
        shopId: shopId,
        productName: productname.text,
        category: isproductselect ? radioVal : product.category,
        purchaseCost: pc.toString(),
        productCategoryId: productCategoryID ?? "",
        unit: unitvalue ?? "",
        stock: stock.text,
        productStatus: isproductselect ? "New" : "Old",
        purchaseDate: purchaseDate.text,
        mrp: mrp.text.isEmpty ? "0" : mrp.text,
        productImage: isproductselect ? img64 : '',
        menuIds: menuids,
        menuRate: radioVal == 'Direct' ? mrp.text : "",
        productId: product.productId ?? "",
      );

      setState(() {
        isloading = false;
      });

      await AppRouteName.appPage.pushAndRemoveUntil(context, (route) => false);
    } catch (e) {
      setState(() {
        isloading = false;
      });
      // Show error message if the API call fails
      Dialogs.snackbar("Error: ${e.toString()}", context, isError: true);
    }
  }
}
