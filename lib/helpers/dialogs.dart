import 'package:flutter/material.dart';

import '../util/colors_const.dart';
import '../util/styles.dart';

class Dialogs {
  static snackbar(String message, context, {bool? isError}) {
    bool errorState = isError ?? !(message.toLowerCase().contains("success"));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: errorState ? Colors.red : Colors.green,
      elevation: 5,
      content: Text(
        message,
        style: Styles.textStyleMedium(color: AppColor.whiteColor),
      ),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(10),
      animation: AlwaysStoppedAnimation<double>(1),
      dismissDirection: DismissDirection.horizontal,
    ));
  }
}
