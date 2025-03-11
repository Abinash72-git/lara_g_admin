import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/purchaselist_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/util/textfields_widget.dart';
import 'package:lara_g_admin/util/validator.dart';
import 'package:lara_g_admin/views/components/my_button.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseUpdatepage extends StatefulWidget {
  final PurchaseModel purchase;

  const PurchaseUpdatepage({Key? key, required this.purchase})
      : super(key: key);
  @override
  _PurchaseUpdatepageState createState() => _PurchaseUpdatepageState();
}

class _PurchaseUpdatepageState extends State<PurchaseUpdatepage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController cost = TextEditingController();
  TextEditingController mrp = TextEditingController();
  TextEditingController stock = TextEditingController();
  TextEditingController purchaseDate = TextEditingController();
  List<String> unit = ['Kg', 'Gram', 'Litre', 'ML', 'None'];
  String? unitvalue;
  bool isloading = false;
  GetProvider get gprovider => context.read<GetProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    getdata();
  }

  getdata() async {
    setState(() {
      cost.text = widget.purchase.purchaseCost.toString();
      mrp.text = widget.purchase.mrp.toString();
      stock.text = widget.purchase.stock.toString();
      unitvalue = widget.purchase.unit;
      purchaseDate.text = widget.purchase.purchaseDate;
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
          "Update Purchase",
          style: Styles.textStyleLarge(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.bgColor,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        // CustomTextFormField(
                        //   controller: cost,
                        //   read: false,
                        //   obscureText: false,
                        //   hintText: 'Enter purchase cost',
                        //   validator: Validator.notEmpty,
                        //   keyboardType: TextInputType.number,
                        //   fillColor: AppColor.whiteColor,
                        // ),
                        // const SizedBox(
                        //   height: 10,
                        // ),
                        CustomTextFormField(
                          controller: mrp,
                          read: false,
                          obscureText: false,
                          hintText: 'MRP',
                          validator: Validator.notEmpty,
                          keyboardType: TextInputType.number,
                          fillColor: AppColor.whiteColor,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          controller: stock,
                          read: false,
                          obscureText: false,
                          hintText: 'Enter quantity',
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
                                controller: purchaseDate,
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
                        Container(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColor.mainColor),
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
                            items: unit.map((unitOption) {
                              return DropdownMenuItem(
                                child: Text(unitOption),
                                value: unitOption,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                      text: isloading ? "Loading..." : "Update".toUpperCase(),
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
                          isloading ? null : update();
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
        purchaseDate.value = TextEditingValue(text: formatted.toString());
      });
    }
  }

  update() async {
    setState(() {
      isloading = true;
    });

    final sharedPrefs = await SharedPreferences.getInstance();
    String? token = sharedPrefs.getString(AppConstants.TOKEN);
    String? shopId = sharedPrefs.getString(AppConstants.SHOPID);

    // Get the individual values directly instead of creating a JSON string
    String purchaseId = widget.purchase.purchaseId;
    String productId = widget.purchase.productId;
    double purchaseCost = double.tryParse(cost.text) ?? 0.0; // Safe parse
    double mrpValue = double.tryParse(mrp.text) ?? 0.0; // Safe parse
    int stockValue = int.tryParse(stock.text) ?? 0; // Safe parse
    String purchaseDateValue = purchaseDate.text;
    String unitValue = unitvalue ?? '';

    // Call updatePurchase with the correct positional arguments
    await gprovider.updatePurchase(
      token!,
      shopId!,
      purchaseId,
      productId,
      purchaseCost,
      mrpValue,
      unitValue,
      stockValue,
      purchaseDateValue,
    );

    setState(() {
      isloading = false;
    });

    // Show a success message in Snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Purchase updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    // Optionally, navigate back to the previous screen (e.g., homepage)
    Navigator.pushReplacementNamed(context, AppRouteName.appPage.value);
  }
}
