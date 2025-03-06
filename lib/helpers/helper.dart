import 'package:flutter/material.dart';

class Helper {
  late BuildContext context;
  late DateTime currentBackPressTime;
  Helper.of(BuildContext context) {
    this.context = context;
  }
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void goBack(dynamic result) {
    Navigator.pop(context, result);
  }

  bool predicate(Route<dynamic> route) {
    print(route);
    return false;
  }

  // Future<void> showDialogBox(String action, List<String> options,
  //     List<VoidCallback> actions, Size size) async {
  //   if (options.length == actions.length) {
  //     final p = await showDialog<String>(
  //       context: context,
  //       builder: (context) => CustomDialogBoxWidget(
  //         child: AlertDialog(
  //           contentPadding: EdgeInsets.symmetric(
  //               horizontal: size.width / 25, vertical: size.height / 100),
  //           content: Text("Are You sure to " + action + "?",
  //               style: const TextStyle(
  //                   fontWeight: FontWeight.w500, color: Color(0xff200303))),
  //           actions: <Widget>[
  //             for (String i in options)
  //               TextButton(
  //                   child: Text(
  //                     i,
  //                     style: const TextStyle(
  //                         fontWeight: FontWeight.w600,
  //                         color: Color(0xff4BDFF3)),
  //                   ),
  //                   onPressed: actions[options.indexOf(i)])
  //           ],
  //         ),
  //       ),
  //     );
  //     print(p);
  //   }
  // }
}
