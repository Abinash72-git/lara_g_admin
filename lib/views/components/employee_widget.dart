import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';
import '../../util/styles.dart';

class EmployeeWidget extends StatelessWidget {
  final String image;
  final String employeeName;
  final String doj;
  final VoidCallback onTap;
  EmployeeWidget(
      {required this.image,
      required this.employeeName,
      required this.doj,
      required this.onTap});
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
                  employeeName.toString(),
                  style: Styles.textStyleMedium().copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Row(
                  children: [
                    Text(
                      'DOj : ',
                      style:
                          Styles.textStyleSmall(color: AppColor.hintTextColor),
                    ),
                    Text(
                      doj,
                      style: Styles.textStyleSmall()
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
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
