import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/helpers/dialogs.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/helper.dart';

import '../../../models/route_argument.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';
import '../../../util/textfields_widget.dart';
import '../../../util/validator.dart';
import '../../components/my_button.dart';
import '../../components/product_select_widget.dart';

class PurchaseProductSelectPage extends StatefulWidget {
  @override
  _PurchaseProductSelectPageState createState() =>
      _PurchaseProductSelectPageState();
}

class _PurchaseProductSelectPageState extends State<PurchaseProductSelectPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  late Helper hp;
  List<ProductModel> product = [];
  ProductModel? prd;
  bool isproductselect = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController productname = TextEditingController();
  bool isloading = false;
  GetProvider get gprovider => context.read<GetProvider>();
  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);
    Future.microtask(() => getdata());
  }

  getdata() async {
    setState(() {
      isloading = true;
    });
    print(
        '--------------------------------PurchaseProductSelectPage----------------------');

    await gprovider.getProductList();

    setState(() {
      product = gprovider.productList;
      isloading = false;
    });
  }

  void productSearch(value) {
    setState(() {
      isproductselect = false;
      product = gprovider.productList
          .where((productList) => productList.productName
              .toLowerCase()
              .contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.whiteColor,
            )),
        backgroundColor: AppColor.mainColor,
        title: Text("Purchase Add",
            style: Styles.textStyleMedium(color: AppColor.whiteColor)),
        centerTitle: true,
        // actions: [
        //   issearching
        //       ? IconButton(
        //           onPressed: () {
        //             setState(() {
        //               issearching = false;
        //             });
        //           },
        //           icon: const Icon(
        //             Icons.search,
        //             color: AppColor.whiteColor,
        //           ))
        //       : IconButton(
        //           icon: const Icon(
        //             Icons.cancel,
        //             color: Colors.white,
        //           ),
        //           onPressed: () {
        //             setState(() {
        //               issearching = true;
        //               product = _con.productList;
        //             });
        //           })
        // ],
      ),
      body: SafeArea(
          child: Container(
              width: width,
              height: height,
              color: AppColor.bgColor,
              child: isloading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.mainColor,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 100, 15, 0),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              CustomTextFormField(
                                controller: productname,
                                read: false,
                                obscureText: false,
                                hintText: 'Enter product name',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                                onchanged: (value) {
                                  productSearch(value);
                                  return '';
                                },
                              ),
                              productname.text.isEmpty || isproductselect
                                  ? Container()
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      itemCount: product.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ProductSelectWidget(
                                          image: product[index].image,
                                          productName:
                                              product[index].productName,
                                          onTap: () async {
                                            setState(() {
                                              prd = product[index];
                                              productname.text =
                                                  product[index].productName;
                                              isproductselect = true;
                                            });
                                          },
                                        );
                                      }),
                              const SizedBox(
                                height: 15,
                              ),
                              MyButton(
                                text: "Add".toUpperCase(),
                                textcolor: const Color(0xffFFFFFF),
                                textsize: 16,
                                fontWeight: FontWeight.w700,
                                letterspacing: 0.7,
                                buttoncolor: AppColor.mainColor,
                                borderColor: AppColor.mainColor,
                                buttonheight: 50,
                                buttonwidth: width / 2.5,
                                radius: 5,
                                onTap: (isproductselect &&
                                        productname.text.isNotEmpty)
                                    ? () async {
                                        final value = await AppRouteName
                                            .purchaseaddpage
                                            .push(
                                          context,
                                          args: RouteArgument(
                                            data: {
                                              "isproductselect": isproductselect
                                                  ? "true"
                                                  : "false",
                                              "product": prd,
                                              "product_name": productname.text
                                            },
                                          ),
                                        );
                                        if (value == 'yes') {
                                          Navigator.of(context).pop();
                                        }
                                      }
                                    : () {
                                        // Optionally show a feedback message or disable the button
                                        Dialogs.snackbar(
                                            "Please select a product and enter a name",
                                            context,
                                            isError: true);
                                      },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))),
    );
  }
}
