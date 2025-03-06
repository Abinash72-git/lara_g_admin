import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';
import '../../util/styles.dart';

class TargetWidget extends StatelessWidget {
  final String image;
  final String employeeName;
  //final String doj;
  final VoidCallback onTap;
  TargetWidget(
      {required this.image,
      required this.employeeName,
      //  required this.doj,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: AppColor.containerbg,
              borderRadius: BorderRadius.circular(50),
            ),
            // color: AppColor.whiteColor,
            child: Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Divider(
                  height: 2,
                  thickness: 0,
                ),
                Container(
                  height: 68,
                  //  width: 200,
                  //  color: AppColor.bgColor,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 211, 235, 211),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
                        child: CircleAvatar(
                          backgroundColor: AppColor.bannerBGColor,
                          backgroundImage: NetworkImage(image),
                          radius: 30,
                        ),
                      ),
                      onTap: onTap,
                      title: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 15, 0, 15),
                        child: Text(
                          employeeName.toString(),
                          style: Styles.textStyleMedium().copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 19,
                          ),
                        ),
                      ),
                      // subtitle: Padding(
                      //   padding: const EdgeInsets.only(left: 10.0),
                      //   child: Row(
                      //     children: [
                      // Text(
                      //   'DOj : ',
                      //   style:
                      //       Styles.textStyleSmall(color: AppColor.hintTextColor),
                      // ),
                      // Text(
                      //   doj,
                      //   style: Styles.textStyleSmall()
                      //       .copyWith(fontWeight: FontWeight.w500),
                      // ),
                      //     ],
                      //   ),
                      // ),
                      trailing: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 2, 30, 0),
                        child: const Icon(
                          Icons.task_outlined,
                          color: AppColor.blackColor,
                          size: 25,
                        ),
                      )),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
