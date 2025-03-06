import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/models/employee_models.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/simple_stream.dart';
//import 'package:google_fonts/google_fonts.dart';

import '../../../helpers/helper.dart';

import '../../../models/route_argument.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';
import '../../components/my_button.dart';

class EmployeeDetailsPage extends StatefulWidget {
  final EmployeeModel employee;

  const EmployeeDetailsPage({Key? key, required this.employee})
      : super(key: key);
  @override
  _EmployeeDetailsPageState createState() => _EmployeeDetailsPageState();
}

class _EmployeeDetailsPageState extends State<EmployeeDetailsPage> {
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  late EmployeeModel employee;

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    employee = widget.employee;
  }

  @override
  Widget build(BuildContext context) {
    //  var ph = MediaQuery.of(context).size.height;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        backgroundColor: AppColor.mainColor,
        // brightness: Brightness.dark,
        title: Text(
          "Employee Details",
          style: Styles.textStyleLarge(color: AppColor.whiteColor),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: AppColor.whiteColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Color(0xffFAFAFA),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height / 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Employee Information",
                            style: Styles.textStyleLarge()),
                        const SizedBox(
                          width: 15,
                        ),
                        MyButton(
                          text: "Edit",
                          textcolor: AppColor.whiteColor,
                          textsize:
                              9, // Use a fixed, readable size instead of scaling it with screen width
                          fontWeight: FontWeight.w600,
                          letterspacing: 0.5,
                          buttoncolor: AppColor.mainColor,
                          borderColor: AppColor.mainColor,
                          buttonheight:
                              40, // Slightly increased for better tap area
                          buttonwidth: 100, // Adjusted for better text fit
                          radius: 12, // Adjusted for a balanced rounded look
                          onTap: () async {
                            final val = await AppRouteName.addemployee.push(
                                context,
                                args: RouteArgument(data: {
                                  "route": "Update",
                                  "employee": employee
                                }));
                            if (val == 'Yes') {
                              print('77777777777777777777777');
                              
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(employee.name.toUpperCase(),
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(
                            width: 15,
                          ),
                          employee.image.isEmpty
                              ? const CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      "assets/images/writer-img.jpg"))
                              : CircleAvatar(
                                  radius: 25,
                                  backgroundImage:
                                      NetworkImage(employee.image)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date of birth : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(employee.dob,
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Age : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(employee.age.toString(),
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Mobile : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(employee.mobile,
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Address : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: width / 2,
                            child: Text(
                              employee.address,
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Salary : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(employee.salary,
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Designation : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(employee.designation,
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 0, 50, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Date of join : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600)),
                          Text(employee.dateOfJoin,
                              style: Styles.textStyleSmall().copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height / 80,
                    ),
                    Container(
                      width: width,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.containerbg,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Target : ",
                              style: Styles.textStyleSmall()
                                  .copyWith(fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              employee.target.join(","),
                              style: Styles.textStyleSmall().copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
