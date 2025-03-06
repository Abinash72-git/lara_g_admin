import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/helper.dart';

import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';
import '../../components/employee_widget.dart';

class EmployeesPage extends StatefulWidget {
  @override
  _EmployeesPageState createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  bool isloading = false;

  GetProvider get gprovider => context.read<GetProvider>();
  // _EmployeesPageState() : super(UserController()) {
  //   _con = controller as UserController;
  // }
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
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.whiteColor,
            )),
        backgroundColor: AppColor.mainColor,
        title: Text("Employees",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
          heroTag: null,
          onPressed: () async {
            final val = await AppRouteName.addemployee.push(context,
                args:
                    RouteArgument(data: {'route': 'Add', 'employee': 'cscc'}));

            if (val == 'Yes') {
              print('3333333333333333333333');

              getdata();
            }
          },
          tooltip: "Add Employee",
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
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            gprovider.employeesList.isEmpty
                                ? Text(
                                    "No Employee Added",
                                    style: Styles.textStyleMedium(
                                        color: AppColor.redColor),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: gprovider.employeesList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Dismissible(
                                        key: Key(index.toString()),
                                        direction: DismissDirection.endToStart,
                                        background: Container(),
                                        confirmDismiss:
                                            (DismissDirection direction) async {
                                          return showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: Text(
                                                  'Are you sure?'.toString()),
                                              content: Text(
                                                  'Do you want delete this employee'
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
                                                    deleteEmployee(gprovider
                                                        .employeesList[index]
                                                        .employeeId);
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
                                                    BorderRadius.circular(10)),
                                            child: const Center(
                                              child: Icon(Icons.delete,
                                                  color: AppColor.bgColor,
                                                  size: 45),
                                            )),
                                        child: EmployeeWidget(
                                          image: gprovider
                                              .employeesList[index].image,
                                          employeeName: gprovider
                                              .employeesList[index].name,
                                          doj: gprovider
                                              .employeesList[index].dateOfJoin,
                                          onTap: () async {
                                            // await Navigator.pushNamed(context,
                                            //     AppConstants.ADDEMPLOYEEPAGE,
                                            //     arguments: RouteArgument(data: {
                                            //       "route": "Update",
                                            //       "employee":
                                            //           _con.employeeList[index]
                                            //     }));
                                            // await Navigator.pushNamed(
                                            //     context,
                                            //     AppConstants
                                            //         .EMPLOYEEDETAILSPAGE,
                                            //     arguments: gprovider
                                            //         .employeesList[index]);
                                            await AppRouteName.employeedetails
                                                .push(
                                                    context,
                                                    args: RouteArgument(data: {
                                                      "employee": gprovider
                                                          .employeesList[index]
                                                    }));

                                            getdata();
                                          },
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

  deleteEmployee(String employeeID) async {
    final sharedPrefs = await SharedPreferences.getInstance();
    var data = {
      "shop_id": sharedPrefs.getString(AppConstants.SHOPID).toString(),
      "employee_id": employeeID,
    };

    //await _con.deleteEmploye(data);
    // await _con.getEmployeeList();
  }
}
