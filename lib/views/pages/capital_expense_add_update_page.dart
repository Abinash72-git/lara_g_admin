import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/employee_models.dart';
import 'package:lara_g_admin/models/getExpense_model.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/util/textfields_widget.dart';
import 'package:lara_g_admin/util/validator.dart';
import 'package:lara_g_admin/views/components/my_button.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CaptalExpenseAddUpdatepage extends StatefulWidget {
  final RouteArgument data;

  const CaptalExpenseAddUpdatepage({Key? key, required this.data})
      : super(key: key);
  @override
  _CaptalExpenseAddUpdatepageState createState() =>
      _CaptalExpenseAddUpdatepageState();
}

class _CaptalExpenseAddUpdatepageState
    extends State<CaptalExpenseAddUpdatepage> {
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
  TextEditingController expenseName = TextEditingController();
  TextEditingController expenseDescription = TextEditingController();
  TextEditingController expenseAmount = TextEditingController();
  TextEditingController expenseDate = TextEditingController();
  TextEditingController employeeName = TextEditingController();
  String employeeID = '';
  final picker = ImagePicker();
  File? profilepic;
  String img64 = '';
  late CapitalExpenseModel capitalExpense;
  late EmployeeModel employee;
  bool isloading = false;
  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    widget.data.data['route'] == 'Add' ? null : getdata();
  }

  getdata() async {
    setState(() {
      isloading = true;
      capitalExpense = widget.data.data['capitalExpense'];

      expenseName.text = capitalExpense.expenseName;
      expenseDescription.text = capitalExpense.expenseDescription;
      expenseAmount.text = capitalExpense.expenseAmount;
      expenseDate.text = capitalExpense.expenseDate;
      employeeName.text = capitalExpense.employeeName;
      employeeID = capitalExpense.employeeId;

      isloading = false;
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
          widget.data.data['route'] == 'Add'
              ? "Add Capital Expense"
              : "Update Capital Expense",
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
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: expenseName,
                                read: false,
                                obscureText: false,
                                hintText: 'Expense name',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: expenseAmount,
                                read: false,
                                obscureText: false,
                                hintText: 'Amount',
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
                                      controller: expenseDate,
                                      read: false,
                                      obscureText: false,
                                      hintText: 'date',
                                      validator: Validator.notEmpty,
                                      keyboardType: TextInputType.text,
                                      fillColor: AppColor.whiteColor,
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: expenseDescription,
                                read: false,
                                obscureText: false,
                                hintText: 'Description',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                                maxlines: 5,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.pushNamed(context,
                                          AppConstants.EMPLOYEESELECTPAGE)
                                      .then((value) => {
                                            employee = value as EmployeeModel,
                                          });
                                  setState(() {
                                    employeeID = employee.employeeId;
                                    employeeName.text = employee.name;
                                  });
                                },
                                child: AbsorbPointer(
                                  child: CustomTextFormField(
                                    controller: employeeName,
                                    read: true,
                                    obscureText: false,
                                    hintText: 'Employee Name',
                                    validator: Validator.notEmpty,
                                    keyboardType: TextInputType.text,
                                    fillColor: AppColor.whiteColor,
                                  ),
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
                            buttonwidth: width / 2.5,
                            radius: 5,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                isloading ? null : addExpense();
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
        // dob = formatted.toString();

        expenseDate.value = TextEditingValue(text: formatted.toString());
      });
    }
  }
addExpense() async {
  setState(() {
    isloading = true;
  });

  // Fetch shared preferences for token and shopId
  final sharedPrefs = await SharedPreferences.getInstance();
  String? token = sharedPrefs.getString(AppConstants.TOKEN);
  String? shopId = sharedPrefs.getString(AppConstants.SHOPID);

  // Ensure token and shopId are available before calling createExpense or updateCapitalExpense
  if (token != null && shopId != null) {
    // Extract text field values
    var expenseNameText = expenseName.text;
    var expenseDescriptionText = expenseDescription.text;
    var expenseAmountValue = double.tryParse(expenseAmount.text) ?? 0.0;  // Ensure expenseAmount is a valid number
    var expenseDateText = expenseDate.text;
    var employeeIdValue = employeeID;
    var employeeNameText = employeeName.text;

    // Prepare data to send
    var data = {
      "expense_id": widget.data.data['route'] == 'Add' ? "" : capitalExpense.expenseId,
      "shop_id": shopId,  // Passing shopId
      "expense_name": expenseNameText,  // Passing expenseName
      "expense_description": expenseDescriptionText,  // Passing expenseDescription
      "expense_amount": expenseAmountValue,  // Passing expenseAmount
      "expense_date": expenseDateText,  // Passing expenseDate
      "employee_id": employeeIdValue,  // Passing employeeId
      "employee_name": employeeNameText,  // Passing employeeName
    };

    // Check if route is 'Add' (Create) or something else (Update)
    if (widget.data.data['route'] == 'Add') {
      // Call createExpense to create a new expense
      await provider.createExpense(
        token: token,
        shopId: shopId,
        expenseName: expenseNameText,
        expenseDescription: expenseDescriptionText,
        expenseAmount: expenseAmountValue,
        expenseDate: expenseDateText,
        employeeId: employeeIdValue,
        employeeName: employeeNameText,
      );
    } else {
      // Call updateCapitalExpense to update an existing expense
    //  await provider.updateCapitalExpense(data);
    }
  } else {
    // Handle case where token or shopId is missing
    print('Missing token or shopId');
  }

  setState(() {
    isloading = false;
  });
}


}
