import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';
import '../../util/styles.dart';

class ProductSelectWidget extends StatelessWidget {
  final String image;
  final String productName;
  final VoidCallback onTap;
  ProductSelectWidget(
      {required this.image, required this.productName, required this.onTap});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: AppColor.whiteColor,
      child: Column(
        children: <Widget>[
          const Divider(
            height: 0.1,
            thickness: 1.0,
          ),
          ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColor.bannerBGColor,
                backgroundImage: NetworkImage(image),
              ),
              onTap: onTap,
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  productName.toString(),
                  style: Styles.textStyleMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: AppColor.blackColor,
                size: 20,
              ))
        ],
      ),
    );
  }
}
