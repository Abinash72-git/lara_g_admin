import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';

class MenuIngredientWidget extends StatelessWidget {
  final String productimage;
  final String productName;
  final String productCategory;
  final String ingredientQuantity;
  final String ingredientUnit;
  final double width;
  final double height;
  final VoidCallback onTap;
  MenuIngredientWidget(
      {required this.productimage,
      required this.productName,
      required this.productCategory,
      required this.ingredientQuantity,
      required this.ingredientUnit,
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
                        productimage,
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
                        productName,
                        style: GoogleFonts.prompt(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColor.blackColor),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        ingredientUnit == "None"
                            ? ingredientQuantity + " Quantity"
                            : ingredientQuantity + " " + ingredientUnit,
                        style: GoogleFonts.prompt(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColor.blackColor),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Category : $productCategory",
                        style: GoogleFonts.prompt(
                            fontSize: 15,
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
