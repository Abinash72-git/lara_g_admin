import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/exception.dart';
import 'package:lara_g_admin/widgets/dilogue.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/dialogs.dart';
import '../../helpers/helper.dart';
import '../../util/colors_const.dart';
import '../../util/styles.dart';
import '../../util/validator.dart';
import '../components/my_button.dart';

class AddShoppage extends StatefulWidget {
  final bool isFirstTime;
  const AddShoppage({super.key, this.isFirstTime = false});
  @override
  _AddShoppageState createState() => _AddShoppageState();
}

class _AddShoppageState extends State<AddShoppage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  int radioSelected = 1;
  String radioVal = 'male';
  TextEditingController shopName = TextEditingController();
  TextEditingController shopLocation = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  bool _isLoading = false;
  String token = '';

  UserProvider get provider => context.read<UserProvider>();

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);

    getData();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Error picking image: $e");
      AppDialogue.toast("Error selecting image");
    }
  }

  Future<String?> _getBase64Image() async {
    if (_imageFile == null) return null;
    try {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print("Error converting image to base64: $e");
      return null;
    }
  }

  Future<void> addShop() async {
    if (formKey.currentState!.validate()) {
      if (_imageFile == null) {
        AppDialogue.toast("Please select a shop image");
        return;
      }

      String? base64Image = await _getBase64Image();
      if (base64Image == null) {
        AppDialogue.toast("Error processing image");
        return;
      }

      FocusScope.of(context).unfocus();

      await AppDialogue.openLoadingDialogAfterClose(
        context,
        text: "Creating Shop...",
        load: () async {
          try {
            final response = await provider.addShop(
              shopName: shopName.text,
              shopLocation: shopLocation.text,
              shopImage: base64Image,
            );
            print("UI received response: ${response.data}");
            return response;
          } catch (e) {
            print("UI caught error: $e");
            if (e is APIException) {
              AppDialogue.toast(e.message);
            } else {
              AppDialogue.toast("An unexpected error occurred.");
            }
            return null;
          }
        },
        afterComplete: (resp) async {
          if (resp != null && resp.data != null) {
            try {
              print("Processing response in UI: ${resp.data}");

              Map<String, dynamic> responseData;
              if (resp.data is Map<String, dynamic>) {
                responseData = resp.data;
              } else if (resp.data is String) {
                try {
                  responseData = json.decode(resp.data);
                } catch (e) {
                  responseData =
                      resp.fullBody ?? {'success': false, 'message': resp.data};
                }
              } else {
                responseData = {
                  'success': false,
                  'message': 'Invalid response format'
                };
              }

              if (responseData['success'] == true) {
                print("Shop created successfully");
                AppDialogue.toast(
                    responseData['message'] ?? "Shop created successfully");

                // Navigate to next screen
                if (mounted) {
                  await Future.delayed(const Duration(milliseconds: 500));
                  AppRouteName.demoshopchoose.pushAndRemoveUntil(
                    context,
                    (route) => false,
                  );
                }
              } else {
                AppDialogue.toast(
                    responseData['message'] ?? "Failed to create shop");
              }
            } catch (e) {
              print("Error processing response in UI: $e");
              AppDialogue.toast("Error processing response");
            }
          } else {
            AppDialogue.toast("Failed to create shop. Please try again.");
          }
        },
      );
    }
  }

  // Fetch the stored token
  void getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token =
        prefs.getString(AppConstants.TOKEN) ?? ''; // Provide default if null
    print("Token: $token");
  }

  @override
  Widget build(BuildContext context) {
    var ph = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColor.mainColor,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
          title: Text(
            "Add Shops",
            style: Styles.textStyleLarge(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Container(
                width: double.infinity,
                height: double.infinity,
                // color: AppColor.bgColor,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/add-shop-bg.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 50,
                              ),
                              const Text(
                                'Add Shop',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Stack(
                                children: [
                                  _imageFile != null
                                      ?
                                      // CircleAvatar(
                                      //     radius: 50,
                                      //     backgroundColor: AppColor.bannerBGColor,
                                      //     backgroundImage: FileImage(profilepic!),
                                      //   )
                                      Container(
                                          width: 130,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: FileImage(_imageFile!),
                                              fit: BoxFit.cover,
                                            ),
                                            shape: BoxShape.circle,
                                            color: const Color.fromARGB(
                                                255, 27, 94, 32),
                                          ),
                                        )
                                      : Container(
                                          width: 130,
                                          height: 130,
                                          decoration: const BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/emplyolees.png"),
                                              fit: BoxFit.fitWidth,
                                            ),
                                            shape: BoxShape.circle,
                                            color:
                                                Color.fromARGB(255, 27, 94, 32),
                                          ),
                                        ),
                                  Positioned(
                                    bottom: 1,
                                    right: 10,
                                    child: GestureDetector(
                                      onTap: () {
                                        _pickImage();
                                      },
                                      child: const CircleAvatar(
                                        radius: 12,
                                        backgroundColor:
                                            Color.fromARGB(255, 27, 94, 32),
                                        // child: Center(
                                        child: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        //),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 70,
                              ),
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 60, top: 7, right: 30),
                                    child: Container(
                                        height: 55,
                                        width:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(40),
                                            topRight: Radius.circular(40),
                                          ),
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                        //child: Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50, top: 4),
                                          child: TextFormField(
                                            // textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 20.0),
                                            controller: shopName,
                                            // read: false,
                                            obscureText: false,
                                            //  hintText: 'Enter your email',
                                            validator: Validator.notEmpty,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                                // contentPadding: new EdgeInsets.symmetric(),
                                                border: InputBorder.none,
                                                fillColor: AppColor.whiteColor,
                                                hintText:
                                                    'Enter your shop name',
                                                hintStyle: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )
                                        //),
                                        ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 30, top: 3),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white,
                                        child: Image(
                                            image: AssetImage(
                                                'assets/images/add-shop.png')),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 60, top: 7, right: 30),
                                    child: Container(
                                        height: 55,
                                        width:
                                            MediaQuery.of(context).size.height,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            bottomLeft: Radius.circular(0),
                                            bottomRight: Radius.circular(40),
                                            topRight: Radius.circular(40),
                                          ),
                                          color: Colors.grey.withOpacity(0.4),
                                        ),
                                        // child: Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 50, top: 4),
                                          child: TextFormField(
                                            // textAlign: TextAlign.center,
                                            style:
                                                const TextStyle(fontSize: 20.0),
                                            controller: shopLocation,
                                            // read: false,
                                            obscureText: false,
                                            //  hintText: 'Enter your email',
                                            validator: Validator.notEmpty,
                                            keyboardType: TextInputType.text,
                                            decoration: const InputDecoration(
                                                // contentPadding: new EdgeInsets.symmetric(),
                                                border: InputBorder.none,
                                                fillColor: AppColor.whiteColor,
                                                hintText:
                                                    'Enter your shop Location',
                                                hintStyle: TextStyle(
                                                    color: Colors.white)),
                                          ),
                                        )
                                        //),
                                        ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 30, top: 3),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.white,
                                        child: Image(
                                            image: AssetImage(
                                                'assets/images/shop-name loction.png')),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              Align(
                                  alignment: Alignment.center,
                                  child: MyButton(
                                      text: provider.isLoading
                                          ? "Loading..."
                                          : "Add".toUpperCase(),
                                      textcolor: Colors.white,
                                      textsize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterspacing: 0.7,
                                      buttoncolor: Colors.green.shade900, borderColor: AppColor.mainColor,
                                      buttonheight: 50,
                                      buttonwidth: 300,
                                      radius: 5,
                                      onTap: () {
                                        addShop();
                                      }))
                            ]))))));
  }
}
