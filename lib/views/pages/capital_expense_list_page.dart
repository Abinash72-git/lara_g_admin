import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/getExpense_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/route_argument.dart';
import '../components/capital_expense_widget.dart';

class CapitalExpenseListPage extends StatefulWidget {
  @override
  _CapitalExpenseListPageState createState() => _CapitalExpenseListPageState();
}

class _CapitalExpenseListPageState extends State<CapitalExpenseListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  bool isloading = false;

  GetProvider get gprovider => context.read<GetProvider>();

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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.SHOPID);
    String? shopId = prefs.getString(AppConstants.SHOPID);

    //await _con.getCapitalExpenseList();
    await gprovider.getCapitalExpenseList(token.toString(), shopId.toString());

    setState(() {
      isloading = false;
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
        title: Text("Capital Expense Details",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            // await Navigator.pushNamed(
            //     context, AppConstants.CAPITALEXPENSEADDUPDATEPAGE,
            //     arguments: RouteArgument(
            //         data: {"route": "Add", "capitalExpense": ''}));
            await AppRouteName.addcapitalExpense_page.push(context,
                args: RouteArgument(
                    data: {'route': 'Add', "capitalExpense": ''}));
            getdata();
          },
          tooltip: "Add Expense",
          backgroundColor: AppColor.mainColor,
          child: const Icon(
            Icons.add,
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
                  : gprovider.capitalExpense.isEmpty
                      ? Center(
                          child: Text(
                            "No Expense Added",
                            style: Styles.textStyleMedium(
                                color: AppColor.redColor),
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
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: gprovider.capitalExpense.length,
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
                                          confirmDismiss: (DismissDirection
                                              direction) async {
                                            return showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    'Are you sure?'.toString()),
                                                content: Text(
                                                    'Do you want delete this expense'
                                                        .toString()),
                                                titleTextStyle: const TextStyle(
                                                    // fontFamily: 'Fingbanger',
                                                    color: Colors.black),
                                                contentTextStyle: const TextStyle(
                                                    // fontFamily: 'Fingbanger',
                                                    color: Colors.black),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    child: Text(
                                                      'No'.toString(),
                                                      style: const TextStyle(
                                                          // fontFamily: 'Fingbanger',
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      deleteCapitalExpense(
                                                          gprovider
                                                              .capitalExpense[
                                                                  index]
                                                              .expenseId);
                                                      Navigator.of(context)
                                                          .pop(true);
                                                    },
                                                    child: Text(
                                                      'Yes'.toString(),
                                                      style: const TextStyle(
                                                          // fontFamily: 'Fingbanger',
                                                          color: Colors.black),
                                                    ),
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
                                          child: CapitalExpenseWidget(
                                            expenseName: gprovider
                                                .capitalExpense[index]
                                                .expenseName,
                                            expenseAmount: gprovider
                                                .capitalExpense[index]
                                                .expenseAmount,
                                            expenseDate: gprovider
                                                .capitalExpense[index]
                                                .expenseDate,
                                            employeeName: gprovider
                                                .capitalExpense[index]
                                                .employeeName,
                                            expenseDescription: gprovider
                                                .capitalExpense[index]
                                                .expenseDescription,
                                            width: width,
                                            height: height,
                                            onTap: () async {
                                              await Navigator.pushNamed(
                                                  context,
                                                  AppConstants
                                                      .CAPITALEXPENSEADDUPDATEPAGE,
                                                  arguments:
                                                      RouteArgument(data: {
                                                    "route": "Update",
                                                    "capitalExpense": gprovider
                                                        .capitalExpense[index]
                                                  }));
                                              getdata();
                                            },
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

  deleteCapitalExpense(String expenseID) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    String? shopId = sharedPrefs.getString(AppConstants.SHOPID);
    var data = {
      "shop_id": shopId,
      "expense_id": expenseID,
    };

    //await _con.deleteCapitalExpense(data);
    // await _con.getEmployeeList();
  }
}
