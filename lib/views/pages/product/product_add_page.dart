import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:lara_g_admin/helpers/dialogs.dart';
import 'package:lara_g_admin/models/product_category_model.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/util/textfields_widget.dart';
import 'package:lara_g_admin/util/validator.dart';
import 'package:lara_g_admin/views/components/my_button.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ProductAddpage extends StatefulWidget {
  final RouteArgument data;

  const ProductAddpage({Key? key, required this.data}) : super(key: key);
  @override
  _ProductAddpageState createState() => _ProductAddpageState();
}

class _ProductAddpageState extends State<ProductAddpage> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  int radioSelected = 1;
  String radioVal = 'Direct';
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController productname = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController menucost = TextEditingController();
  final picker = ImagePicker();

  late ProductModel product;
  List<String> unit = ['Kg', 'Gram', 'Litre', 'ML', 'None'];
  String? unitvalue;
  String? productCategoryID;
  bool isloading = false;
  GetProvider get gprovider => context.read<GetProvider>();
  UserProvider get provider => context.read<UserProvider>();
  List<ProductCategoryModel> _Dproductcategories = []; // Define it here
  File? _selectedImage;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    print('RouteArgument Data: ${widget.data.data}');
    print('Route Type: ${widget.data.data['route']}');
    print('Product Data: ${widget.data.data['product']}');

    print('✅ RouteArgument received in ProductAddPage: ${widget.data.data}');

    if (widget.data.data['route'] == 'Update') {
      print("🔄 Fetching product data...");
      getdata();
    }

    getcat();
  }

  Future<void> getdata() async {
    setState(() => isloading = true);
    product = widget.data.data['product'];
    productname.text = product.productName;
    cost.text = product.purchaseCost.toString();
    mrp.text = product.mrp.toString();
    stock.text = product.stock.toString();
    unitvalue = product.unit?.toString();
    isloading = false;
  }

  Future<void> getcat() async {
    setState(() => isloading = true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.TOKEN);
    _Dproductcategories = await gprovider.getDProductCategories(token ?? '');
    setState(() => isloading = false);
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
          widget.data.data['route'] == 'Add' ? "Add Product" : "Update Product",
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
                            _selectedImage != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColor.bannerBGColor,
                                    backgroundImage: FileImage(_selectedImage!),
                                  )
                                : widget.data.data['route'] == 'Add'
                                    ? const CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppColor.bannerBGColor,
                                        backgroundImage: AssetImage(
                                            "assets/images/writer-img.jpg"),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppColor.bannerBGColor,
                                        backgroundImage:
                                            NetworkImage(product.image),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: productname,
                                read: false,
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
                                read: widget.data.data['route'] == 'Add'
                                    ? false
                                    : true,
                                obscureText: false,
                                hintText: 'Enter purchase cost',
                                validator: (value) {
                                  if (widget.data.data['route'] != 'Add')
                                    return null; // 👈 Skip validation if updating
                                  return Validator.notEmpty(value);
                                },
                                keyboardType: TextInputType.number,
                                inputformat: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                fillColor: widget.data.data['route'] == 'Add'
                                    ? AppColor.whiteColor
                                    : Colors.grey.shade300,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: mrp,
                                read: false,
                                obscureText: false,
                                hintText: 'Enter MRP',
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
                              widget.data.data['route'] == 'Add'
                                  ? CustomTextFormField(
                                      controller: stock,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'Enter product quantity',
                                      validator: (value) {
                                        if (widget.data.data['route'] ==
                                                'Add' &&
                                            (value == null || value.isEmpty)) {
                                          return "Stock quantity cannot be zero or empty.";
                                        }
                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      inputformat: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      fillColor: AppColor.whiteColor,
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                              _Dproductcategories.isEmpty
                                  ? const Text(
                                      "No categories found") // ✅ Display message when empty
                                  : DropdownButton<String>(
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      dropdownColor: const Color(0xffFFFFFF),
                                      hint:
                                          const Text("Please select category"),
                                      value: productCategoryID,
                                      items: _Dproductcategories.map<
                                          DropdownMenuItem<String>>((category) {
                                        print(
                                            "Dropdown item: ${category.productCategoryName}"); // ✅ Debugging
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
                                      },
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                      'Non Direct',
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
                                  // icon: const Icon(
                                  //   Icons.keyboard_arrow_down,
                                  //   size: 30,
                                  // ),
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
                              widget.data.data['route'] != 'Add'
                                  ? const SizedBox()
                                  : radioVal != 'Direct'
                                      ? const SizedBox()
                                      : CustomTextFormField(
                                          controller: menucost,
                                          read: false,
                                          obscureText: false,
                                          hintText: 'Enter menu cost',
                                          validator: Validator.notEmpty,
                                          keyboardType: TextInputType.number,
                                          inputformat: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          fillColor: AppColor.whiteColor,
                                        ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MyButton(
                            text: isloading
                                ? "Loading..."
                                : widget.data.data['route'] == 'Add'
                                    ? "Add".toUpperCase()
                                    : "Update".toUpperCase(),
                            textcolor: const Color(0xffFFFFFF),
                            textsize: 16,
                            fontWeight: FontWeight.w700,
                            letterspacing: 0.7,
                            buttoncolor: AppColor.mainColor, borderColor: AppColor.mainColor,
                            buttonheight: 50,
                            buttonwidth: width / 1.5,
                            radius: 5,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                print("Product Name: ${productname.text}");
                                print("Purchase Cost: ${cost.text}");
                                print("MRP: ${mrp.text}");
                                print("Category: $productCategoryID");
                                print("Unit: $unitvalue");
                                print(
                                    "Stock Quantity: ${stock.text}"); // ✅ Debugging Stock

                                if (_base64Image == '' &&
                                    widget.data.data['route'] == 'Add') {
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
                                  isloading ? null : createProduct();
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

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64String = base64Encode(imageBytes);

      setState(() {
        _selectedImage = imageFile;
        _base64Image = base64String;
      });
    }
  }

  Future<void> createProduct() async {
    if ((_base64Image == null || _base64Image!.isEmpty) &&
        widget.data.data['route'] == 'Add') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Please select an image")),
      );
      return;
    }

    setState(() => isloading = true);

    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      String? shopId = sharedPrefs.getString(AppConstants.SHOPID);
      if (shopId == null || shopId.isEmpty)
        throw Exception("❌ Shop ID not found.");

      bool isAdding = widget.data.data['route'] == 'Add';

      int? stockQuantity = int.tryParse(stock.text);
      if (stockQuantity == null || stockQuantity <= 0) {
        throw Exception("❌ Stock quantity cannot be zero or empty.");
      }

      int? costValue = int.tryParse(cost.text);
      if (costValue == null || costValue <= 0) {
        throw Exception("❌ Product cost cannot be zero or empty.");
      }

      int purchaseCost = isAdding ? (costValue ~/ stockQuantity) : costValue;
      if (purchaseCost <= 0) throw Exception("❌ Invalid purchase cost.");

      String? rate;
      if (radioVal == "Direct" && menucost.text.isEmpty) {
        throw Exception("❌ Rate is required for 'Direct' category.");
      } else if (radioVal == "Direct") {
        rate = menucost.text;
      }

      final response = isAdding
          ? await provider.createProduct(
              shopId: shopId,
              productName: productname.text.trim(),
              category: radioVal,
              purchaseCost: purchaseCost.toString(),
              productCategoryId: productCategoryID!,
              unit: unitvalue!,
              stock: stock.text.trim(),
              menuRate: rate,
              base64Image:
                  _base64Image?.isNotEmpty == true ? _base64Image : null,
            )
          : await provider.updateProduct(
              shopId: shopId,
              productName: productname.text.trim(),
              category: radioVal,
              purchaseCost: purchaseCost.toString(),
              productCategoryId: productCategoryID!,
              unit: unitvalue!,
              stock: stock.text.trim(),
              productImage:
                  _base64Image?.isNotEmpty == true ? _base64Image : null,
            );

      if (response.data != null && response.data['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              backgroundColor: AppColor.mainColor,
              content: Text(
                response.data['message'] ?? "✅ Product added successfully",
                style: TextStyle(color: AppColor.whiteColor),
              )),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("❌ API Response Error: ${response.data}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isloading = false);
    }
  }
}
