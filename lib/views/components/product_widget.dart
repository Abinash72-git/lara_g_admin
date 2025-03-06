import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';

class ProductWidget extends StatelessWidget {
  final String image;
  final String name;
  final String itemCount;
  final String rate;
  final String stockMinValue;
  final bool isStockMin;
  final double width;
  final double height;
  final VoidCallback onTap;
  final VoidCallback edit;
  final VoidCallback delete;
  ProductWidget(
      {required this.image,
      required this.rate,
      required this.name,
      required this.itemCount,
      required this.stockMinValue,
      required this.isStockMin,
      required this.width,
      required this.height,
      required this.onTap,
      required this.edit,
      required this.delete});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: AppColor.whiteColor,
                  border: Border.all(
                      color: isStockMin
                          ? AppColor.redColor
                          : AppColor.whiteColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 5, 10, 0),
                    child: Container(
                      width: width / 4.5,
                      height: height / 7.7,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        color: AppColor.greyColor,
                      ),
                      child: Center(
                        child: Image.network(image),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 10, 10),
                    child: SizedBox(
                      width: width / 4.2,
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
                            "Item Count : " + itemCount,
                            style: GoogleFonts.prompt(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
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
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width / 5.5,
                  ),
                  isStockMin
                      ? const Opacity(
                          opacity: 0.5,
                          child: Icon(
                            Icons.warning_rounded,
                            color: AppColor.redColor,
                            size: 50,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
            // FittedBox(
            //   child: Row(
            //     children: [
            //       OutlinedButton(
            //           onPressed: delete,
            //           style: ButtonStyle(
            //             backgroundColor:
            //                 MaterialStateProperty.all(AppColor.whiteColor),
            //             shape: MaterialStateProperty.all(
            //                 const RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.only(
            //                         bottomLeft: Radius.circular(15)))),
            //             side: MaterialStateProperty.all(
            //                 const BorderSide(color: AppColor.mainColor)),
            //           ),
            //           child: Container(
            //               height: height / 20,
            //               child: Center(
            //                 child: Text(
            //                   "Delete",
            //                   style: GoogleFonts.prompt(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w500,
            //                       color: AppColor.mainColor),
            //                 ),
            //               ),
            //               width: width / 2)),
            //       OutlinedButton(
            //           onPressed: edit,
            //           style: ButtonStyle(
            //             backgroundColor:
            //                 MaterialStateProperty.all(AppColor.mainColor),
            //             shape: MaterialStateProperty.all(
            //                 const RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.only(
            //                         bottomRight: Radius.circular(15)))),
            //             side: MaterialStateProperty.all(
            //                 const BorderSide(color: AppColor.mainColor)),
            //           ),
            //           child: Container(
            //               height: height / 20,
            //               // color: AppColor.boxbgcolor,
            //               child: Center(
            //                 child: Text(
            //                   "Update".toUpperCase(),
            //                   style: GoogleFonts.prompt(
            //                       fontSize: 14,
            //                       fontWeight: FontWeight.w600,
            //                       color: AppColor.whiteColor),
            //                 ),
            //               ),
            //               width: width / 2)),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
