// import 'dart:math';

// import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// import '../components/product_select_widget.dart';

// class EmployeeSelectListPage extends StatefulWidget {
//   @override
//   _EmployeeSelectListPageState createState() => _EmployeeSelectListPageState();
// }

// class _EmployeeSelectListPageState extends StateMVC<EmployeeSelectListPage> {
//   late UserController _con;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   MediaQueryData get dimensions => MediaQuery.of(context);
//   Size get size => dimensions.size;
//   double get height => size.height;
//   double get width => size.width;
//   double get radius => sqrt(pow(width, 2) + pow(height, 2));
//   late Helper hp;
//   List<EmployeeModel> employeeList = [];
//   bool issearching = true;
//   _EmployeeSelectListPageState() : super(UserController()) {
//     _con = controller as UserController;
//   }
//   @override
//   void initState() {
//     super.initState();
//     hp = Helper.of(context);
//     getdata();
//   }

//   getdata() async {
//     setState(() {
//       _con.isloading = true;
//     });

//     await _con.getEmployeeList();

//     setState(() {
//       employeeList = _con.employeeList;
//       _con.isloading = false;
//     });
//   }

//   void employeeSearch(value) {
//     setState(() {
//       employeeList = _con.employeeList
//           .where((employeeList) =>
//               employeeList.name.toLowerCase().contains(value.toLowerCase()))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       key: scaffoldKey,
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             icon: const Icon(
//               Icons.arrow_back,
//               color: MyColors.whiteColor,
//             )),
//         backgroundColor: MyColors.mainColor,
//         title: issearching
//             ? Text("Select Employee",
//                 style: Styles.textStyleMedium(color: MyColors.whiteColor))
//             : TextField(
//                 onChanged: (value) {
//                   employeeSearch(value);
//                 },
//                 style: Styles.textStyleMedium(color: MyColors.whiteColor),
//                 decoration: const InputDecoration(
//                     icon: Icon(
//                       Icons.search,
//                       color: MyColors.whiteColor,
//                     ),
//                     hintText: "Search Employee",
//                     hintStyle: TextStyle(color: Colors.white),
//                     border: InputBorder.none),
//               ),
//         centerTitle: true,
//         actions: [
//           issearching
//               ? IconButton(
//                   onPressed: () {
//                     setState(() {
//                       issearching = false;
//                     });
//                   },
//                   icon: const Icon(
//                     Icons.search,
//                     color: MyColors.whiteColor,
//                   ))
//               : IconButton(
//                   icon: const Icon(
//                     Icons.cancel,
//                     color: Colors.white,
//                   ),
//                   onPressed: () {
//                     setState(() {
//                       issearching = true;
//                       employeeList = _con.employeeList;
//                     });
//                   })
//         ],
//       ),
//       body: SafeArea(
//           child: Container(
//               width: width,
//               height: height,
//               color: MyColors.bgColor,
//               child: _con.isloading
//                   ? const Center(
//                       child: CircularProgressIndicator(
//                         color: MyColors.mainColor,
//                       ),
//                     )
//                   : SingleChildScrollView(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 15),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const SizedBox(
//                               height: 15,
//                             ),
//                             employeeList.isEmpty
//                                 ? Text(
//                                     "No Employee",
//                                     style: Styles.textStyleMedium(
//                                         color: MyColors.redColor),
//                                   )
//                                 : ListView.builder(
//                                     shrinkWrap: true,
//                                     physics:
//                                         const NeverScrollableScrollPhysics(),
//                                     itemCount: employeeList.length,
//                                     itemBuilder:
//                                         (BuildContext context, int index) {
//                                       return ProductSelectWidget(
//                                         image: employeeList[index].image,
//                                         productName: employeeList[index].name,
//                                         onTap: () async {
//                                           Navigator.pop(
//                                               context, employeeList[index]);
//                                         },
//                                       );
//                                     }),
//                             const SizedBox(
//                               height: 15,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ))),
//     );
//   }
// }
