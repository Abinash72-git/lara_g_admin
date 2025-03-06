import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';

class CapitalExpenseWidget extends StatelessWidget {
  final String expenseName;
  final String expenseDescription;
  final String expenseAmount;
  final String expenseDate;
  final String employeeName;
  final double width;
  final double height;
  final VoidCallback onTap;
  CapitalExpenseWidget(
      {required this.expenseName,
      required this.expenseDescription,
      required this.expenseAmount,
      required this.expenseDate,
      required this.employeeName,
      required this.width,
      required this.height,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColor.whiteColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expense Name : ",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Expense Amount : ",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Expense Date : ",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Employee Name : ",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Description : ",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "₹ $expenseName",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "₹ $expenseAmount",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            expenseDate,
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            employeeName,
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Container(
                            width: width / 3,
                            child: Text(
                              expenseDescription,
                              style: GoogleFonts.prompt(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.blackColor),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
