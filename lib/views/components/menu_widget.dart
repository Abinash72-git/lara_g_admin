import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';

class MenuWidget extends StatelessWidget {
  final String image;
  final String name;
  final String rate;
  final String date;
  final double width;
  final double height;
  final VoidCallback onTap;
  MenuWidget(
      {required this.image,
      required this.rate,
      required this.name,
      this.date = "",
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 10, 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: width / 4.5,
                      height: height / 7.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColor.greyColor,
                      ),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.prompt(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColor.blackColor),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        "₹ $rate",
                        style: GoogleFonts.prompt(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.blackColor),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      date == ""
                          ? const SizedBox()
                          : Text(
                              date,
                              style: GoogleFonts.prompt(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.blackColor),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
