import 'package:flutter/material.dart';

import '../../util/colors_const.dart';
import '../../util/styles.dart';

class MenuSalesWidget extends StatelessWidget {
  final String image;
  final String name;
  final String rate;
  final String saleDate;
  final bool ismenu;
  final double width;
  final double height;
  final VoidCallback onTap;
  MenuSalesWidget(
      {required this.image,
      required this.name,
      required this.rate,
      required this.saleDate,
      required this.ismenu,
      required this.width,
      required this.height,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width / 3,
        height: ismenu ? height / 4.5 : height / 4,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColor.bannerBGColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: width / 3,
                height: height / 7.5,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  color: AppColor.whiteColor,
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                name,
                style: Styles.textStyleSmall(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "₹ $rate",
                style: Styles.textStyleSmall(color: AppColor.mainColor),
              ),
            ),
            SizedBox(
              height: !ismenu ? 4 : 0,
            ),
            !ismenu
                ? Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      saleDate,
                      style: Styles.textStyleSmall(),
                    ),
                  )
                : Container(),
            const SizedBox(
              height: 2,
            ),
          ],
        ),
      ),
    );
  }
}
