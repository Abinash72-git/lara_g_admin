import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../util/colors_const.dart';
import '../../util/styles.dart';

class ShopWidget extends StatelessWidget {
  final String image;
  final String shopName;
  final String location;
  final VoidCallback onTap;
  final VoidCallback edit;
  final bool iseditoption;
  ShopWidget(
      {required this.image,
      required this.shopName,
      required this.location,
      required this.onTap,
      required this.edit,
      required this.iseditoption});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 100,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              color: AppColor.bannerBGColor,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 90,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                color: AppColor.whiteColor,
              ),
              padding: const EdgeInsets.all(7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Shop Name : ",
                                style: Styles.textStyleSmall()),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(shopName,
                                style: Styles.textStyleSmall()
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              color: AppColor.mainColor,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(location,
                                style: Styles.textStyleSmall()
                                    .copyWith(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  !iseditoption
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: edit,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.whiteColor,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: AppColor.hintTextColor,
                                      blurRadius: 3.0,
                                    ),
                                  ]),
                              child: const Icon(
                                Icons.edit,
                                color: AppColor.mainColor,
                                size: 15,
                              ),
                            ),
                          ),
                        )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
