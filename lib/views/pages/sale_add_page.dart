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
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/services/api_service.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/util/textfields_widget.dart';
import 'package:lara_g_admin/util/validator.dart';
import 'package:lara_g_admin/views/components/my_button.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../components/product_select_widget.dart';

class SaleAddpage extends StatefulWidget {
  @override
  _SaleAddpageState createState() => _SaleAddpageState();
}

class _SaleAddpageState extends State<SaleAddpage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int radioSelected = 1;
  String radioVal = 'male';
  TextEditingController menuName = TextEditingController();
  TextEditingController totalRate = TextEditingController();
  TextEditingController preparationCost = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController menurate = TextEditingController();
  TextEditingController saleDate = TextEditingController();
  String menuIDs = '';
  String menuNames = '';
  String quantities = '';
  String preparationCosts = '';
  String menuID = '';
  String precosts = '';
  final picker = ImagePicker();
  File? profilepic;
  String img64 = '';
  List<MenuModel> menu = [];
  bool ismenuselect = false;
  List<String> menunames = [];
  List<String> quanties = [];
  List<String> rates = [];
  double preCost = 0.0;
  double menuPrePrice = 0.0;
  double totalPrice = 0.0;
  double menuPrice = 0.0;
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
          "Add Sale",
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          // Stack(
                          //   children: [
                          //     profilepic != null
                          //         ?
                          //         // CircleAvatar(
                          //         //     radius: 50,
                          //         //     backgroundColor: AppColor.bannerBGColor,
                          //         //     backgroundImage: FileImage(profilepic!),
                          //         //   )
                          //         Container(
                          //             width: 150,
                          //             height: 80,
                          //             decoration: BoxDecoration(
                          //                 image: DecorationImage(
                          //                   image: FileImage(profilepic!),
                          //                   fit: BoxFit.cover,
                          //                 ),
                          //                 color: AppColor.whiteColor),
                          //           )
                          //         : Container(
                          //             width: 150,
                          //             height: 80,
                          //             decoration: const BoxDecoration(
                          //                 image: DecorationImage(
                          //                   image: AssetImage(
                          //                       "assets/images/writer-img.jpg"),
                          //                   fit: BoxFit.fill,
                          //                 ),
                          //                 color: AppColor.whiteColor),
                          //           ),
                          //     // const CircleAvatar(
                          //     //   radius: 50,
                          //     //   backgroundColor: AppColor.bannerBGColor,
                          //     //   backgroundImage:
                          //     //       AssetImage("assets/images/writer-img.jpg"),
                          //     // ),
                          //     Positioned(
                          //       bottom: 0,
                          //       right: 0,
                          //       child: GestureDetector(
                          //         onTap: () {
                          //           bottomSheetImage();
                          //         },
                          //         child: const CircleAvatar(
                          //           radius: 12,
                          //           backgroundColor: AppColor.mainColor,
                          //           child: Center(
                          //             child: Icon(
                          //               Icons.edit,
                          //               size: 15,
                          //               color: AppColor.whiteColor,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                          // const SizedBox(
                          //   height: 20,
                          // ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
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
                                  controller: menuName,
                                  read: false,
                                  obscureText: false,
                                  hintText: 'Enter menu name',
                                  // validator: Validator.notEmpty,
                                  keyboardType: TextInputType.text,
                                  fillColor: AppColor.whiteColor,
                                  onchanged: (value) {
                                    menuSearch(value);
                                    return '';
                                  },
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        itemCount: menu.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return ProductSelectWidget(
                                            image: menu[index].image,
                                            productName: menu[index].menuName,
                                            onTap: () async {
                                              setState(() {
                                                menuName.text =
                                                    menu[index].menuName;
                                                menuID = menu[index].menuId;
                                                precosts = menu[index]
                                                    .preparationCost
                                                    .toString();
                                                menurate.text =
                                                    menu[index].rate.toString();
                                                menuPrePrice = double.parse(
                                                    menu[index]
                                                        .preparationCost
                                                        .toString());
                                                menuPrice = double.parse(
                                                    menu[index]
                                                        .rate
                                                        .toString());
                                                ismenuselect = true;
                                              });
                                            },
                                          );
                                        }),
                                menuName.text.isEmpty || ismenuselect
                                    ? Container()
                                    : const SizedBox(
                                        height: 10,
                                      ),
                                CustomTextFormField(
                                  controller: menurate,
                                  read: true,
                                  obscureText: false,
                                  hintText: 'Menu rate',
                                  // validator: Validator.notEmpty,
                                  keyboardType: TextInputType.number,
                                  fillColor: AppColor.whiteColor,
                                  // onchanged: (value) {
                                  //   productSearch(value);
                                  //   return '';
                                  // },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                CustomTextFormField(
                                  controller: quantity,
                                  read: false,
                                  obscureText: false,
                                  hintText: 'Enter quantity',
                                  // validator: Validator.notEmpty,
                                  keyboardType: TextInputType.number,
                                  fillColor: AppColor.whiteColor,
                                  // onchanged: (value) {
                                  //   productSearch(value);
                                  //   return '';
                                  // },
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
                                    if (ismenuselect) {
                                      setState(() {
                                        menunames.add(menuName.text);
                                        quanties.add(quantity.text);
                                        rates.add(menurate.text);
                                        menuIDs = menuIDs == ''
                                            ? menuID
                                            : menuIDs + "###" + menuID;
                                        quantities = quantities == ''
                                            ? quantity.text
                                            : quantities +
                                                "###" +
                                                quantity.text;
                                        menuNames = menuNames == ''
                                            ? menuName.text
                                            : menuNames + "###" + menuName.text;
                                        preparationCosts =
                                            preparationCosts == ''
                                                ? precosts
                                                : preparationCosts +
                                                    "###" +
                                                    precosts;
                                        double c = menuPrePrice *
                                            double.parse(quantity.text);
                                        preCost = preCost + c;
                                        preparationCost.text =
                                            preCost.toString();
                                        double d = menuPrice *
                                            double.parse(quantity.text);
                                        totalPrice = totalPrice + d;
                                        totalRate.text = totalPrice.toString();
                                        menuName.clear();
                                        quantity.clear();
                                        menurate.clear();
                                      });
                                    } else {
                                      Dialogs.snackbar(
                                          "Please select the menu", context,
                                          isError: true);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          // menuName.text.isEmpty || ismenuselect
                          //     ? Container()
                          //     : ListView.builder(
                          //         shrinkWrap: true,
                          //         physics: const NeverScrollableScrollPhysics(),
                          //         padding:
                          //             const EdgeInsets.symmetric(horizontal: 5),
                          //         itemCount: menu.length,
                          //         itemBuilder:
                          //             (BuildContext context, int index) {
                          //           return ProductSelectWidget(
                          //             image: menu[index].image,
                          //             productName: menu[index].menuname,
                          //             onTap: () async {
                          //               setState(() {
                          //                 menuName.text = menu[index].menuname;
                          //                 menuID = menu[index].menuId;
                          //                 precosts =
                          //                     menu[index].preparationCost;
                          //                 menurate.text = menu[index].rate;
                          //                 menuPrePrice = double.parse(
                          //                     menu[index].preparationCost);
                          //                 menuPrice =
                          //                     double.parse(menu[index].rate);
                          //                 ismenuselect = true;
                          //               });
                          //             },
                          //           );
                          //         }),
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
                            controller: totalRate,
                            read: true,
                            obscureText: false,
                            hintText: 'Total rate',
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
                                  controller: saleDate,
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
                          const SizedBox(
                            height: 25,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: MyButton(
                              text: isloading
                                  ? "Loading..."
                                  : "Add".toUpperCase(),
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
                                // Validate the form first
                                if (formKey.currentState!.validate()) {
                                  // Check if menuNames is empty
                                  if (menuNames.isEmpty) {
                                    Dialogs.snackbar("Please add menu", context,
                                        isError: true);
                                  } else {
                                    // Call the addSale function
                                    setState(() {
                                      isloading = true; // Set loading state
                                    });

                                    try {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      String? shopId =
                                          prefs.getString(AppConstants.SHOPID);
                                      String? token =
                                          prefs.getString(AppConstants.TOKEN);

                                      // Call the API provider function
                                      var response = await provider.addSale(
                                        token: token.toString(),
                                        shopId: shopId.toString(),
                                        preparationCost: preparationCost.text,
                                        salePrice: totalRate.text,
                                        saleDate: saleDate.text,
                                        menuIds:
                                            menuIDs, // Pass menu IDs as string
                                        menuNames:
                                            menuNames, // Pass menu names as string
                                        quantities:
                                            quantities, // Pass quantities as string
                                        preparationCosts:
                                            preparationCosts, // Pass preparation costs as string
                                      );

                                      // Check if the response is successful
                                      // Check if the response is successful
                                      if (response.status) {
                                        // Sale was successfully added
                                        print(
                                            'Sale added successfully: ${response.data}');
                                        setState(() {
                                          menuNames = '';
                                          quantities = '';
                                          preparationCosts = '';
                                          totalRate.text = '';
                                          preparationCost.text = '';
                                          saleDate.text = '';
                                        });
                                        Dialogs.snackbar(
                                            'Sale added successfully', context,
                                            isError: false);
                                        Navigator.pop(context);
                                      } else {
                                        // There was an error adding the sale
                                        print(
                                            'Failed to add sale: ${response.data}');
                                        Dialogs.snackbar(
                                            'Sale not added successfully',
                                            context,
                                            isError: true);
                                      }
                                    } catch (e) {
                                      Dialogs.snackbar(
                                          'An error occurred: $e', context,
                                          isError: true);
                                    }

                                    setState(() {
                                      isloading =
                                          false; // Reset loading state after the API call
                                    });
                                  }
                                } else {
                                  Dialogs.snackbar(
                                      "Please fill in all required fields",
                                      context,
                                      isError: true);
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          menunames.isEmpty
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 130,
                                        child: Text(
                                          'Menu name',
                                          style: Styles.textStyleLarge(
                                              color: Colors.black),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Quantity",
                                        style: Styles.textStyleLarge(
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Price",
                                        style: Styles.textStyleLarge(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          menunames.isEmpty
                              ? Container()
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  itemCount: menunames.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 100,
                                            child: Text(
                                              menunames[index],
                                              style: Styles.textStyleMedium(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            quanties[index],
                                            style: Styles.textStyleMedium(
                                                color: Colors.black),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            rates[index],
                                            style: Styles.textStyleMedium(
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
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
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );
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

        saleDate.value = TextEditingValue(text: formatted.toString());
      });
    }
  }

  // addSale() async {
  //   setState(() {
  //     isloading = true; // Show loading indicator
  //   });

  //   final sharedPrefs = await SharedPreferences.getInstance();

  //   // Prepare the data to send to the backend
  //   var data = {
  //     "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
  //     "preparation_cost": preparationCost.text,
  //     "sale_price": totalRate.text,
  //     "sale_date": saleDate.text,
  //     "menu_ids": menuIDs, // List of menu IDs as a string
  //     "menu_names": menuNames, // List of menu names as a string
  //     "quantities": quantities, // List of quantities as a string
  //     "preparation_costs":
  //         preparationCosts, // List of preparation costs as a string
  //   };

  //   try {
  //     // Call the API provider function
  //     var response = await provider.addSale(
  //       shopId: sharedPrefs.getString(AppConstants.SHOPID).toString(),
  //       preparationCost: preparationCost.text,
  //       salePrice: totalRate.text,
  //       saleDate: saleDate.text,
  //       menuIds: menuIDs, // Pass menu IDs as string
  //       menuNames: menuNames, // Pass menu names as string
  //       quantities: quantities, // Pass quantities as string
  //       preparationCosts: preparationCosts, // Pass preparation costs as string
  //     );

  //     // Check if the response indicates success
  //     if (response['success']) {
  //       setState(() {
  //         // Reset form data after successful submission
  //         menuNames = '';
  //         quantities = '';
  //         preparationCosts = '';
  //         totalRate.text = '';
  //         preparationCost.text = '';
  //         saleDate.text = '';
  //       });
  //       Dialogs.snackbar('Sale added successfully', context, isError: false);
  //     } else {
  //       Dialogs.snackbar('Sale not added successfully', context, isError: true);
  //     }
  //   } catch (e) {
  //     Dialogs.snackbar('An error occurred: $e', context, isError: true);
  //   }

  //   setState(() {
  //     isloading = false; // Hide loading indicator
  //   });
  // }
}
