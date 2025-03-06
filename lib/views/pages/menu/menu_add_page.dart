import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/dialogs.dart';
import '../../../helpers/helper.dart';

import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';
import '../../../util/textfields_widget.dart';
import '../../../util/validator.dart';
import '../../components/my_button.dart';
import '../../components/product_select_widget.dart';

class MenuAddpage extends StatefulWidget {
  @override
  _MenuAddpageState createState() => _MenuAddpageState();
}

class _MenuAddpageState extends State<MenuAddpage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  int radioSelected = 1;
  String radioVal = 'male';
  TextEditingController menuName = TextEditingController();
  TextEditingController rate = TextEditingController();
  TextEditingController preparationCost = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController productname = TextEditingController();
  TextEditingController menuDate = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController doj = TextEditingController();
  String productIDs = '';
  String productNames = '';
  String quantities = '';
  String units = '';
  String productID = '';
  String unit = '';
  final picker = ImagePicker();
  File? _selectedImage;
  String? _base64Image;
  String showUnit = '';
  List<String> unitdrop = ['Kg', 'Gram', 'Litre', 'ML', 'None'];
  String? unitvalue;
  List<ProductModel> product = [];
  bool isproductselect = false; // Initially set to false
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
  String? menuCategoryId;
  bool isloading = false;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GetProvider get gprovider => context.read<GetProvider>();
  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getdata();
    });
  }

  getdata() async {
    setState(() {
      isloading = true;
    });

    await gprovider.getProductList();
    await provider.getMenuCategoriesList();

    if (mounted) {
      // Check if the widget is still mounted
      setState(() {
        product = gprovider.productList;
        isloading = false;
      });
    }
  }

  void productSearch(String value) {
    setState(() {
      isproductselect = false; // Reset flag
      product = gprovider.productList
          .where((productList) => productList.productName
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);

      if (mounted) {
        // Ensure the widget is still mounted
        setState(() {
          _selectedImage = imageFile;
          _base64Image = base64String;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppColor.mainColor,
        title: Text(
          "Add Menu",
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
                        const SizedBox(height: 30),
                        // Image selection section
                        Stack(
                          children: [
                            _selectedImage != null
                                ? Container(
                                    width: 150,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: FileImage(_selectedImage!),
                                          fit: BoxFit.cover,
                                        ),
                                        color: AppColor.whiteColor),
                                  )
                                : Container(
                                    width: 150,
                                    height: 80,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              "assets/images/writer-img.jpg"),
                                          fit: BoxFit.fill,
                                        ),
                                        color: AppColor.whiteColor),
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  pickImage();
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
                        const SizedBox(height: 20),
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
                              const SizedBox(height: 10),
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
                                              final currentProduct =
                                                  product[index];

                                              return ProductSelectWidget(
                                                image: currentProduct.image,
                                                productName:
                                                    currentProduct.productName,
                                                onTap: () async {
                                                  setState(() {
                                                    // Set product fields
                                                    productname.text =
                                                        product[index]
                                                            .productName;
                                                    productID = product[index]
                                                        .productId
                                                        .toString(); // Ensure it's a string
                                                    unit = product[index].unit;
                                                    showUnit =
                                                        product[index].unit;
                                                    prdPrice = double.parse(
                                                        product[index]
                                                            .purchaseCost
                                                            .toString());

                                                    // Set prices for different units
                                                    if (product[index].unit ==
                                                        'Kg') {
                                                      prd1KGprice = prdPrice;
                                                      prd1Gramprice =
                                                          prdPrice / 1000;
                                                    }
                                                    if (product[index].unit ==
                                                        'Gram') {
                                                      prd1Gramprice = prdPrice;
                                                      prd1KGprice =
                                                          prdPrice * 1000;
                                                    }
                                                    if (product[index].unit ==
                                                        'Litre') {
                                                      prd1Litreprice = prdPrice;
                                                      prd1MLprice =
                                                          prdPrice / 1000;
                                                    }
                                                    if (product[index].unit ==
                                                        'ML') {
                                                      prd1MLprice = prdPrice;
                                                      prd1Litreprice =
                                                          prdPrice * 1000;
                                                    }

                                                    // Update selection flag
                                                    isproductselect = true;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                    productname.text.isEmpty || isproductselect
                                        ? Container()
                                        : const SizedBox(height: 10),
                                    showUnit == ''
                                        ? const SizedBox()
                                        : const SizedBox(height: 10),
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
                                              "Product Unit: $showUnit",
                                              style: Styles.textStyleMedium(),
                                            )),
                                          ),
                                    const SizedBox(height: 10),
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
                                    const SizedBox(height: 10),
                                    CustomTextFormField(
                                      controller: quantity,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'Enter quantity',
                                      keyboardType: TextInputType.number,
                                      fillColor: AppColor.whiteColor,
                                    ),
                                    const SizedBox(height: 10),
                                    MyButton(
                                      text: "Add".toUpperCase(),
                                      textcolor: const Color(0xffFFFFFF),
                                      textsize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterspacing: 0.7,
                                      buttoncolor: AppColor.mainColor,
                                      borderColor: AppColor.mainColor,
                                      buttonheight: 50,
                                      buttonwidth: width / 4,
                                      radius: 5,
                                      onTap: () async {
                                        if (isproductselect) {
                                          setState(() {
                                            // Add product to list and calculate the cost
                                            productnames.add(productname.text);
                                            quanties.add(quantity.text);
                                            unitss.add(unitvalue!);

                                            // Append to product list
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

                                            // Calculate price based on selected unit
                                            double c = 0.0;
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

                                            // Update prices list and total cost
                                            prices.add(c.toString());
                                            preCost = preCost + c;
                                            preparationCost.text = preCost
                                                .roundToDouble()
                                                .toString();

                                            // Clear input fields for the next product
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
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                controller: preparationCost,
                                read: true,
                                obscureText: false,
                                hintText: 'Preparation Cost',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                fillColor: Colors.grey.shade200,
                              ),
                              const SizedBox(height: 10),
                              CustomTextFormField(
                                controller: rate,
                                read: false,
                                obscureText: false,
                                hintText: 'Enter rate',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => _selectDate(context, 'doj'),
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
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColor.mainColor),
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xffFFFFFF),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: DropdownButton<dynamic>(
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    dropdownColor: const Color(0xffFFFFFF),
                                    hint: const Text("Please select category"),
                                    value: menuCategoryId,
                                    items: provider.menuCategoriesList
                                        .map((category) {
                                      return DropdownMenuItem(
                                        value: category
                                            .menuCategoryId, // Ensure this matches `menuCategoryId` type
                                        child: Text(category
                                            .menuCategoryName), // Display category name
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        menuCategoryId = value as String;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        const SizedBox(height: 25),
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
                                if (_selectedImage == null) {
                                  Dialogs.snackbar("Please add image", context,
                                      isError: true);
                                } else {
                                  if (productnames.isEmpty) {
                                    Dialogs.snackbar(
                                        "Please add product", context,
                                        isError: true);
                                  } else if (menuCategoryId == null) {
                                    Dialogs.snackbar(
                                        "Please select category", context,
                                        isError: true);
                                  } else {
                                    isloading ? null : addMenu();
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  DateTime lastDate = DateTime.now();
  Future<void> _selectDate(BuildContext context, String from) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950, 1),
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.mainColor,
            hintColor: AppColor.mainColor,
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

        // Update the correct controller based on the parameter
        if (from == 'dob') {
          dob.text = formatted; // Use .text instead of .value
        } else if (from == 'doj') {
          menuDate.text = formatted; // Update menuDate instead of doj
        }
      });
    }
  }

  Future<void> addMenu() async {
    setState(() {
      isloading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var shopId = prefs.getString(AppConstants.SHOPID);

      // Convert strings to the proper types
      double prepCost = double.parse(preparationCost.text);
      double rateValue = double.parse(rate.text);

      // Convert your concatenated strings to lists
      List<String> productIdList =
          productIDs.isEmpty ? [] : productIDs.split("###");
      List<String> productNameList =
          productNames.isEmpty ? [] : productNames.split("###");
      List<String> quantityList =
          quantities.isEmpty ? [] : quantities.split("###");
      List<String> unitList = units.isEmpty ? [] : units.split("###");

      // Call the API
      final response = await provider.addMenu(
          shopId: shopId.toString(),
          menuName: menuName.text,
          menuImage:
              _base64Image, // Make sure this is defined and contains a base64 string
          preparationCost: prepCost,
          menuCategoryId: menuCategoryId ?? "",
          rate: rateValue,
          menuDate: menuDate.text,
          productIds: productIdList,
          productNames: productNameList,
          quantities: quantityList,
          units: unitList);

      // Handle success
      if (response.status) {
        // Show success message
        Dialogs.snackbar("Menu added successfully", context);
        // Navigate back or clear form
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error message
      Dialogs.snackbar("Failed to add menu: ${e.toString()}", context,
          isError: true);
    } finally {
      setState(() {
        isloading = false;
      });
    }
  }
}
