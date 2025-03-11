import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/helper.dart';
import 'package:lara_g_admin/models/employee_models.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/util/colors_const.dart';
import 'package:lara_g_admin/util/styles.dart';
import 'package:lara_g_admin/views/components/product_select_widget.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EmployeeSelectListPage extends StatefulWidget {
  @override
  _EmployeeSelectListPageState createState() => _EmployeeSelectListPageState();
}

class _EmployeeSelectListPageState extends State<EmployeeSelectListPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  List<EmployeeModel> employeeList = [];
  bool issearching = true;
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

    await gprovider.getEmployeeList();

    setState(() {
      employeeList = gprovider.employeesList;
      isloading = false;
    });
  }

  void employeeSearch(value) {
    setState(() {
      employeeList = gprovider.employeesList
          .where((employeeList) =>
              employeeList.name.toLowerCase().contains(value.toLowerCase()))
          .toList();
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
        title: issearching
            ? Text("Select Employee",
                style: Styles.textStyleMedium(color: AppColor.whiteColor))
            : TextField(
                onChanged: (value) {
                  employeeSearch(value);
                },
                style: Styles.textStyleMedium(color: AppColor.whiteColor),
                decoration: const InputDecoration(
                    icon: Icon(
                      Icons.search,
                      color: AppColor.whiteColor,
                    ),
                    hintText: "Search Employee",
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none),
              ),
        centerTitle: true,
        actions: [
          issearching
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      issearching = false;
                    });
                  },
                  icon: const Icon(
                    Icons.search,
                    color: AppColor.whiteColor,
                  ))
              : IconButton(
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      issearching = true;
                      employeeList = gprovider.employeesList;
                    });
                  })
        ],
      ),
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
                            employeeList.isEmpty
                                ? Text(
                                    "No Employee",
                                    style: Styles.textStyleMedium(
                                        color: AppColor.redColor),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: employeeList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ProductSelectWidget(
                                        image: employeeList[index].image,
                                        productName: employeeList[index].name,
                                        onTap: () async {
                                          Navigator.pop(
                                              context, employeeList[index]);
                                        },
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
}
