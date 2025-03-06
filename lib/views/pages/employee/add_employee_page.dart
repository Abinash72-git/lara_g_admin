import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lara_g_admin/models/employee_models.dart';
import 'package:lara_g_admin/provider/get_provider.dart';
import 'package:lara_g_admin/provider/user_provider.dart';
import 'package:lara_g_admin/route_generator.dart';
import 'package:lara_g_admin/widgets/dilogue.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/dialogs.dart';
import '../../../helpers/helper.dart';

//import '../../models/menu_ingredient_model.dart';
//import '../../models/menu_model.dart';

import '../../../models/route_argument.dart';
import '../../../util/app_constants.dart';
import '../../../util/colors_const.dart';
import '../../../util/styles.dart';
import '../../../util/textfields_widget.dart';
import '../../../util/validator.dart';
import '../../components/my_button.dart';
import 'package:intl/intl.dart';

class AddEmployeepage extends StatefulWidget {
  final RouteArgument data;

  const AddEmployeepage({
    Key? key,
    required this.data,
  }) : super(key: key);
  @override
  _AddEmployeepageState createState() => _AddEmployeepageState();
}

class _AddEmployeepageState extends State<AddEmployeepage> {
  late Helper hp;

  MediaQueryData get dimensions => MediaQuery.of(context);
  Size get size => dimensions.size;
  double get height => size.height;
  double get width => size.width;
  double get radius => sqrt(pow(width, 2) + pow(height, 2));
  int radioSelected = 1;
  String radioVal = 'male';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController salary = TextEditingController();
  TextEditingController designation = TextEditingController();
  TextEditingController doj = TextEditingController();
  TextEditingController target = TextEditingController();
  List<String> selectedMenuCategories = [];
  //Set<String> selectedMenuCategories = {};
  List<bool> checked = [];
  //List<MenuModel> menuList = [];
  double _currentSlidervalue = 20;

  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? img64;
  EmployeeModel? employee;
  bool isloading = false;

  UserProvider get provider => context.read<UserProvider>();
  GetProvider get gprovider => context.read<GetProvider>();

  String? menuCategoryId;

  bool _isEmployeeInitialized = false;

  @override
  void initState() {
    super.initState();
    hp = Helper.of(context);

    // Ensure that the data passed is of the expected type
    if (widget.data.data['route'] != 'Add') {
      // Assuming employee data is a JSON string, parse it to an EmployeeModel
      if (widget.data.data['employee'] is String) {
        // If it's a string, decode it into an EmployeeModel
        employee =
            EmployeeModel.fromJson(jsonDecode(widget.data.data['employee']));
      } else if (widget.data.data['employee'] is Map) {
        // If it's already a map, directly convert it to EmployeeModel
        employee = EmployeeModel.fromJson(widget.data.data['employee']);
      }
      _isEmployeeInitialized = true;
    }

    shopId();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getdata();
    });
  }

  Future<void> shopId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? shopId = prefs.getString(AppConstants.SHOPID);
    print('--------------------------- $shopId ------------------------');
  }

  Future<void> getdata() async {
    if (!mounted) return;

    setState(() {
      isloading = true;
    });

    try {
      if (widget.data.data['route'] != 'Add') {
        employee = widget.data.data['employee'];
        _isEmployeeInitialized = true;

        // Initialize form fields with safe access
        name.text =
            employee?.name ?? ''; // Use safe access and fallback if null
        age.text = employee?.age.toString() ?? '';
        mobile.text = employee?.mobile ?? '';
        dob.text = employee?.dob ?? '';
        address.text = employee?.address ?? '';
        salary.text = employee?.salary ?? '';
        designation.text = employee?.designation ?? '';
        doj.text = employee?.dateOfJoin ?? '';
        target.text = (employee?.target?.join(', ') ?? ''); // Fallback if null
      }

      await provider.getMenuCategoriesList();

      if (!mounted) return;

      if (widget.data.data['route'] == 'Update' && _isEmployeeInitialized) {
        checked = List.generate(provider.menuCategoriesList.length, (index) {
          return employee?.target?.any((target) => target.contains(
                  provider.menuCategoriesList[index].menuCategoryName)) ??
              false; // Handle null with fallback to false
        });
      } else {
        checked =
            List.generate(provider.menuCategoriesList.length, (index) => false);
      }
    } catch (e) {
      print("Error in getdata: $e");
      if (mounted) {
        Dialogs.snackbar("Error loading data", context, isError: true);
      }
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var ph = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        backgroundColor: AppColor.mainColor,
        title: Text(
          widget.data.data['route'] == 'Add'
              ? "Add Employee"
              : "Update Employee",
          style: Styles.textStyleLarge(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColor.bgColor,
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.mainColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Stack(
                          children: [
                            _imageFile != null
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundColor: AppColor.bannerBGColor,
                                    backgroundImage: FileImage(_imageFile!),
                                  )
                                : widget.data.data['route'] == 'Add'
                                    ? const CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppColor.bannerBGColor,
                                        backgroundImage: AssetImage(
                                            "assets/images/writer-img.jpg"),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundColor: AppColor.bannerBGColor,
                                        backgroundImage: employee?.image != null
                                            ? NetworkImage(employee!
                                                .image) // Use safe access here
                                            : AssetImage(
                                                    "assets/images/default-image.jpg")
                                                as ImageProvider, // Fallback to default image
                                      ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  bottomSheetImage();
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: AppColor.mainColor,
                                  child: Center(
                                    child: Icon(
                                      Icons.edit,
                                      size: 17,
                                      color: AppColor.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            children: [
                              CustomTextFormField(
                                controller: name,
                                read: false,
                                obscureText: false,
                                hintText: 'Name',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: age,
                                read: false,
                                obscureText: false,
                                hintText: 'Age',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: mobile,
                                read: false,
                                obscureText: false,
                                hintText: 'Mobile number',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context, 'dob'),
                                child: AbsorbPointer(
                                  child: CustomTextFormField(
                                    controller: dob,
                                    read: false,
                                    obscureText: false,
                                    hintText: 'DOB',
                                    validator: Validator.notEmpty,
                                    keyboardType: TextInputType.text,
                                    fillColor: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: address,
                                read: false,
                                obscureText: false,
                                hintText: 'Address',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: salary,
                                read: false,
                                obscureText: false,
                                hintText: 'Salary',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.number,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomTextFormField(
                                controller: designation,
                                read: false,
                                obscureText: false,
                                hintText: 'Designation',
                                validator: Validator.notEmpty,
                                keyboardType: TextInputType.text,
                                fillColor: AppColor.whiteColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () => _selectDate(context, 'doj'),
                                child: AbsorbPointer(
                                  child: CustomTextFormField(
                                    controller: doj,
                                    read: false,
                                    obscureText: false,
                                    hintText: 'Date of join',
                                    validator: Validator.notEmpty,
                                    keyboardType: TextInputType.text,
                                    fillColor: AppColor.whiteColor,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                child: AbsorbPointer(
                                  child: CustomTextFormField(
                                    controller: target,
                                    read: false,
                                    obscureText: false,
                                    hintText: 'Target',
                                    validator: Validator.notEmpty,
                                    keyboardType: TextInputType.text,
                                    fillColor: AppColor.whiteColor,
                                  ),
                                ),
                                onTap: () {
                                  if (provider.menuCategoriesList.isEmpty) {
                                    // Optionally, show a loading indicator or message
                                    provider.getMenuCategoriesList().then((_) {
                                      menuCatPopUp(); // Show the dialog after data is loaded
                                    });
                                  } else {
                                    menuCatPopUp(); // Show the dialog if already populated
                                  }
                                },
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 20, 0, 0),
                                    child: Text(
                                      _currentSlidervalue.round().toString(),
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Slider(
                                    value: _currentSlidervalue,
                                    activeColor: AppColor.mainColor,
                                    inactiveColor:
                                        Color.fromARGB(255, 42, 179, 51),
                                    max: 100,
                                    divisions: 100,
                                    label:
                                        _currentSlidervalue.round().toString(),
                                    onChanged: ((double value) {
                                      setState(() {
                                        _currentSlidervalue = value;
                                      });
                                    })),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: MyButton(
                            text: isloading
                                ? "Loading..."
                                : widget.data.data['route'] == 'Add'
                                    ? "Add".toUpperCase()
                                    : "Update".toUpperCase(),
                            textcolor: const Color(0xffFFFFFF),
                            textsize: 16,
                            fontWeight: FontWeight.w700,
                            letterspacing: 0.7,
                            buttoncolor: AppColor.mainColor,
                            buttonheight: 50,
                            buttonwidth: width / 2.5,
                            radius: 5,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                if (img64 == '' &&
                                    widget.data.data['route'] == 'Add') {
                                  Dialogs.snackbar("Please add image", context,
                                      isError: true);
                                } else {
                                  isloading ? null : addemployee();
                                  print(selectedMenuCategories);
                                }
                              }
                              await gprovider.getEmployeeList();
                            },
                            borderColor: AppColor.mainColor,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  menuCatPopUp() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          content: menuCatgeoryPopUp(),
        );
      },
    );
  }

  Widget menuCatgeoryPopUp() {
    // Check if the list is empty or if data is still loading
    if (provider.menuCategoriesList.isEmpty) {
      return Center(child: CircularProgressIndicator()); // Show loading spinner
    }

    return Container(
      width: width,
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: false,
        itemCount: provider.menuCategoriesList.length,
        itemBuilder: (BuildContext context, int index) {
          // Ensure index is within bounds of the list
          if (index >= provider.menuCategoriesList.length) {
            return Container(); // Return empty container if out of bounds
          }

          return provider.menuCategoriesList.length != index + 1
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: AppColor.mainColor,
                      value: checked[index],
                      onChanged: (bool? value) {
                        setState(() {
                          checked[index] = value!;
                        });
                        if (value!) {
                          selectedMenuCategories.add(provider
                              .menuCategoriesList[index].menuCategoryName);
                        } else {
                          selectedMenuCategories.remove(provider
                              .menuCategoriesList[index].menuCategoryName);
                        }
                        Navigator.of(context).pop();
                        target.text = selectedMenuCategories.join(', ');
                        menuCatPopUp();
                      },
                    ),
                    Text(
                      provider.menuCategoriesList[index].menuCategoryName,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                            checkColor: Colors.white,
                            activeColor: AppColor.mainColor,
                            value: checked[index],
                            onChanged: (bool? value) {
                              setState(() {
                                checked[index] = value!;
                              });
                              if (value!) {
                                selectedMenuCategories.add(provider
                                    .menuCategoriesList[index]
                                    .menuCategoryName);
                              } else {
                                selectedMenuCategories.remove(provider
                                    .menuCategoriesList[index]
                                    .menuCategoryName);
                              }
                              Navigator.of(context).pop();
                              target.text = selectedMenuCategories.join(', ');
                              menuCatPopUp();
                            }),
                        Text(
                          provider.menuCategoriesList[index].menuCategoryName,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ButtonTheme(
                      minWidth: 100.0,
                      height: 40.0,
                      child: ElevatedButton(
                          child: const Text(
                            'ok',
                            style: TextStyle(color: AppColor.whiteColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            print(selectedMenuCategories);
                          }),
                    ),
                  ],
                );
        },
      ),
    );
  }

  bottomSheetImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Photo Library'),
                  onTap: () {
                    getPicFromGallery();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getPicFromCam();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getPicFromCam() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (!mounted) return;

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final base64Image = await _getBase64Image(file);

        if (mounted) {
          setState(() {
            _imageFile = file;
            img64 = base64Image;
          });
        }
      }
    } catch (e) {
      print("Error capturing image: $e");
      if (mounted) {
        Dialogs.snackbar("Error capturing image", context, isError: true);
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> getPicFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (!mounted) return;

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        final base64Image = await _getBase64Image(file);

        if (mounted) {
          setState(() {
            _imageFile = file;
            img64 = base64Image;
          });
        }
      }
    } catch (e) {
      print("Error selecting image: $e");
      if (mounted) {
        Dialogs.snackbar("Error selecting image", context, isError: true);
      }
    }
    if (mounted) {
      Navigator.pop(context);
    }
  }

  Future<String?> _getBase64Image(File file) async {
    try {
      List<int> imageBytes = await file.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print("Error converting image to base64: $e");
      return null;
    }
  }

  DateTime selectedDate = DateTime.now();
  DateTime lastDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context, String from) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950, 1),
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColor.mainColor,
            hintColor: AppColor.mainColor,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        var formatter = DateFormat('yyyy-MM-dd');
        String formatted = formatter.format(selectedDate);
        if (from == 'dob') {
          dob.value = TextEditingValue(text: formatted);
        } else {
          doj.value = TextEditingValue(text: formatted);
        }
      });
    }
  }

  Future<void> addemployee() async {
    if (!mounted) return;

    if (!formKey.currentState!.validate()) return;

    if (img64 == null && widget.data.data['route'] == 'Add') {
      Dialogs.snackbar("Please add an image", context, isError: true);
      return;
    }

    setState(() {
      isloading = true;
    });

    try {
      final sharedPrefs = await SharedPreferences.getInstance();
      final shopId = sharedPrefs.getString(AppConstants.SHOPID);

      if (shopId == null) {
        throw Exception("Shop ID not found");
      }

      // Prepare data for the API request
      final employeeData = {
        "shop_id": shopId,
        "employee_id":
            widget.data.data['route'] == 'Update' ? employee!.employeeId : '',
        "name": name.text,
        "age": int.parse(age.text),
        "mobile": mobile.text,
        "dob": dob.text,
        "address": address.text,
        "salary": salary.text,
        "deignation": designation.text,
        "date_of_join": doj.text,
        "target": target.text.split(',').map((e) => e.trim()).toList(),
        "employee_image": img64 ?? employee!.image,
      };

      // Call the appropriate API method (Create or Update)
      final response = widget.data.data['route'] == 'Add'
          ? await provider.createEmployee(
              shopId: shopId,
              name: name.text,
              age: int.parse(age.text),
              mobile: mobile.text,
              dob: dob.text,
              address: address.text,
              salary: salary.text,
              deignation: designation.text,
              dateOfJoin: doj.text,
              target: target.text.split(',').map((e) => e.trim()).toList(),
              employeeImage: img64 ?? '',
            )
          : await provider.updateEmployee(
              shopId: shopId,
              employeeId: employee!.employeeId,
              name: name.text,
              age: int.parse(age.text),
              mobile: mobile.text,
              dob: dob.text,
              address: address.text,
              salary: salary.text,
              designation: designation.text,
              dateOfJoin: doj.text,
              target: target.text.split(',').map((e) => e.trim()).toList(),
              employeeImage: img64 ?? employee!.image,
            );

      // Check if the response is successful
      if (response.status == true && response.fullBody['success'] == true) {
        Dialogs.snackbar(
          "Employee ${widget.data.data['route'] == 'Add' ? 'added' : 'updated'} successfully",
          context,
        );
        // Navigator.pop(context, 'Yes'); // Pop the page after successful update

        if (widget.data.data['route'] == 'Add') {
          Navigator.pop(context, 'Yes');
        } else {
          // Navigator.pop(context, 'Yes');
          await AppRouteName.homepage
              .pushAndRemoveUntil(context, (route) => false);
        }
      } else {
        throw Exception(
            response.fullBody['message'] ?? "Failed to update employee.");
      }
    } catch (e, stacktrace) {
      print("Error in addemployee: $e");
      print("Stacktrace: $stacktrace");
      if (mounted) {
        Dialogs.snackbar(
          "Failed to ${widget.data.data['route'] == 'Add' ? 'add' : 'update'} employee",
          context,
          isError: true,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isloading = false;
        });
      }
    }
  }
}
