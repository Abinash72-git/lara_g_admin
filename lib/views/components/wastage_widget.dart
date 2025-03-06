import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';

class WastageWidget extends StatelessWidget {
  final String totalPreparationCost;
  final String createdAt;
  final double width;
  final double height;
  final VoidCallback onTap;
  WastageWidget(
      {required this.totalPreparationCost,
      required this.createdAt,
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
                            "Total Preparation Cost : ",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Wastage Date : ",
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
                            "₹ $totalPreparationCost",
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            createdAt,
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColor.blackColor),
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
