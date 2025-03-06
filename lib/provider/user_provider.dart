import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lara_g_admin/enum/enum.dart';
import 'package:lara_g_admin/models/addpruchase_model.dart';
import 'package:lara_g_admin/models/api_validation_model.dart';
import 'package:lara_g_admin/models/create_product_model.dart';
import 'package:lara_g_admin/models/create_shop.dart';
import 'package:lara_g_admin/models/create_user_model.dart';
import 'package:lara_g_admin/models/menucategory_models.dart';
import 'package:lara_g_admin/models/otp_model.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/services/api_service.dart';
import 'package:lara_g_admin/services/device_info.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/exception.dart';
import 'package:lara_g_admin/util/global.dart';
import 'package:lara_g_admin/util/url_path.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

class UserProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool isAuthorized = true;
  bool isApiValidationError = false;
  Dio dio = Dio();

  List<MenuCategoryModel> _menuCategoriesList = [];
  List<DropdownMenuItem> _DropmenuCategoriesList = [];
  List<ProductModel> _products = [];

  List<ProductModel> get products => _products;
  List<MenuCategoryModel> get menuCategoriesList => _menuCategoriesList;
  List<DropdownMenuItem> get DropmenuCategoriesList => _DropmenuCategoriesList;

  // Setter to safely change loading state and notify listeners
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> initialFetch() async {
    AppGlobal.deviceInfo = await DeviceInfoServices.getDeviceInfo();
  }

  Future<APIResp> sendOTP({
    required String mobile,
  }) async {
    // final String? firebaseToken = await FirebaseMessaging.instance.getToken();
    final resp = await APIService.post(UrlPath.loginUrl.sendOTP,
        data: {
          "mobile_no": mobile,
        },
        showNoInternet: false,
        auth: false,
        forceLogout: false,
        console: true,
        timeout: const Duration(seconds: 30));
    print(resp.statusCode);
    print("Abiiiiiiiiiiiiiiiiiii----------------------->");
    print(resp.status);
    print("Abinnnnnnnnnnnnnnnnnn------------------>");
    if (resp.status) {
      isApiValidationError = false;
      return resp;
    } else if (!resp.status && resp.data == "Validation Error") {
      AppConstants.apiValidationModel =
          ApiValidationModel.fromJson(resp.fullBody);
      isApiValidationError = true;
      notifyListeners();
      return resp;
    } else {
      throw APIException(
          type: APIErrorType.auth,
          message:
              resp.data?.toString() ?? "Invalid credential.please try again!");
    }
  }

  Future<APIResp> verifyOTP({
    required String mobile,
    required String otp,
  }) async {
    final resp = await APIService.post(
      UrlPath.loginUrl.verifyOTP,
      data: {
        "mobile_no": mobile,
        "otp": otp,
      },
      showNoInternet: false,
      auth: false,
      forceLogout: false,
      console: true,
      timeout: const Duration(seconds: 30),
    );

    print(resp.statusCode);
    print("Response Status----------------------->");
    print(resp.status);
    print("Response Data------------------>");

    if (resp.status) {
      print("-----------------token saving process------------");
      OTPVerificationResponse data =
          OTPVerificationResponse.fromJson(resp.fullBody);

      if (data.token != null && data.token!.isNotEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(AppConstants.TOKEN, data.token!);
        print("--------------------Token Saved------------------");
      }

      return resp; // Return the API response
    } else if (!resp.status && resp.data == "Validation Error") {
      AppConstants.apiValidationModel =
          ApiValidationModel.fromJson(resp.fullBody);
      isApiValidationError = true;
      notifyListeners();
      return resp;
    } else {
      throw APIException(
        type: APIErrorType.toast,
        message:
            resp.data?.toString() ?? "Invalid credential. Please try again!",
      );
    }
  }

  Future<APIResp> register({
    required String name,
    required String mobile_no,
    required String email,
  }) async {
    try {
      final resp = await APIService.post(
        UrlPath.loginUrl.createProfile,
        data: {
          "name": name,
          "mobile_no": mobile_no,
          "email": email,
        },
        showNoInternet: false,
        auth: false,
        forceLogout: false,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Raw Response Data: ${resp.data}");
      print("Full Body: ${resp.fullBody}"); // Add this line to debug

      // Use fullBody instead of data for the complete response
      if (resp.status) {
        CreateUserModel profile = CreateUserModel.fromMap(resp.fullBody);

        // Save token
        if (profile.token != null && profile.token!.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(AppConstants.TOKEN, profile.token!);
          print('Token saved successfully');
          await prefs.setString(AppConstants.USERNAME, name);
          print('UserName saved successfully');
          await prefs.setString(AppConstants.USEREMAIL, email);
          print('UserEmail saved successfully');
        }

        // Save isFirstTime
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(AppConstants.ISFIRSTREGISTER, true);
        print('isFirstTime saved: true');

        // Return response with the full body data
        return APIResp(
          statusCode: resp.statusCode,
          data: resp.fullBody, // Use fullBody here instead of data
          status: true,
        );
      }

      return resp;
    } catch (e) {
      print("Error in createProfile: $e");
      rethrow;
    }
  }

  Future<APIResp> addShop({
    required String shopName,
    required String shopLocation,
    required String shopImage, // Base64 encoded image
  }) async {
    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      _isLoading = true;
      notifyListeners();

      final resp = await APIService.post(
        '${UrlPath.loginUrl.createShop}/$token',
        data: {
          "shop_name": shopName,
          "shop_location": shopLocation,
          "shop_image": shopImage,
        },
        showNoInternet: true,
        auth: true,
        forceLogout: false,
        console: true,
        timeout:
            const Duration(seconds: 60), // Increased timeout for image upload
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Response Data: ${resp.data}");

      if (resp.status) {
        // Parse the response using the model
        CreateShopModel shopResponse = CreateShopModel.fromMap(resp.fullBody);

        if (shopResponse.success) {
          // ✅ Update isFirstTime to false after successful shop creation
          await prefs.setBool(AppConstants.ISFIRSTREGISTER, false);
          print('isFirstTime updated: false');

          return APIResp(
            statusCode: resp.statusCode,
            data: resp.fullBody,
            status: true,
          );
        } else {
          throw APIException(
            type: APIErrorType.auth,
            message: shopResponse.message,
          );
        }
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: resp.data?.toString() ?? "Failed to create shop",
        );
      }
    } catch (e) {
      print("Error in createShop: $e");
      throw APIException(
        type: APIErrorType.auth,
        message: e.toString(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<APIResp> deleteShop(
      {required String shopId, required String token}) async {
    final resp = await APIService.post(
      '${UrlPath.loginUrl.deleteShop}/$token', // Assuming this is the URL for delete API
      data: {
        "shop_id": shopId,
      },
      showNoInternet: false,
      auth: true, // Assuming authentication is required for this API
      forceLogout: false,
      console: true,
      timeout: const Duration(seconds: 30),
    );

    print(resp.statusCode);
    print("Delete----------------------->");
    print(resp.status);
    print("Delete------------------>");

    if (resp.status) {
      // Successful response
      isApiValidationError = false;
      return resp;
    } else if (!resp.status && resp.data == "Validation Error") {
      // If there is a validation error
      AppConstants.apiValidationModel =
          ApiValidationModel.fromJson(resp.fullBody);
      isApiValidationError = true;
      notifyListeners();
      return resp;
    } else {
      // Throw an error if the response is not successful
      throw APIException(
        type: APIErrorType.auth,
        message:
            resp.data?.toString() ?? "Shop deletion failed. Please try again!",
      );
    }
  }

  Future<void> getMenuCategoriesList() async {
    print(
        '------------------------------ get Menu categoriesList-------------');
    if (_isLoading) return;

    try {
      isLoading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      final response = await APIService.post(
        '${UrlPath.loginUrl.get_menuCategory}/$token',
        data: {},
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response status: ${response.status}");
      print("Response fullBody: ${response.fullBody}");

      if (response.fullBody != null && response.fullBody['result'] != null) {
        final List<dynamic> result = response.fullBody['result'];
        _menuCategoriesList = MenuCategoryModel.fromList(result);
        print(
            "Parsed menuCategoriesList length: ${_menuCategoriesList.length}");
      } else {
        print("No data in response");
        _menuCategoriesList = [];
      }
    } catch (e) {
      print("Error in getMenuCategoriesList: $e");
      _menuCategoriesList = [];
    } finally {
      isLoading = false;
    }
  }

  Future<void> dropMenuCategoriesList() async {
    if (_isLoading) return;

    try {
      isLoading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      final response = await APIService.post(
        '${UrlPath.loginUrl.get_menuCategory}/$token',
        data: {},
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response status: ${response.status}");
      print("Response fullBody: ${response.fullBody}");

      if (response.fullBody != null && response.fullBody['result'] != null) {
        final List<dynamic> result = response.fullBody['result'];
        _DropmenuCategoriesList =
            MenuCategoryModel.fromList(result).cast<DropdownMenuItem>();
        print(
            "Parsed menuCategoriesList length: ${_DropmenuCategoriesList.length}");
      } else {
        print("No data in response");
        _DropmenuCategoriesList = [];
      }
    } catch (e) {
      print("Error in getMenuCategoriesList: $e");
      _menuCategoriesList = [];
    } finally {
      isLoading = false;
    }
  }

// Method to send the API request for creating an employee
  Future<APIResp> createEmployee({
    required String shopId,
    required String name,
    required int age,
    required String mobile,
    required String dob,
    required String address,
    required String salary,
    required String deignation,
    required String dateOfJoin,
    required List<String> target,
    required String employeeImage,
  }) async {
    try {
      isLoading = true;

      // Get authentication token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      // Prepare data for API request
      Map<String, dynamic> data = {
        'shop_id': shopId,
        'name': name,
        'age': age.toString(),
        'mobile': mobile,
        'dob': dob,
        'address': address,
        'salary': salary,
        'designation': deignation,
        'date_of_join': dateOfJoin,
        'target': target,
        'employee_image': employeeImage, // Assuming it's base64 encoded
      };

      print("Sending data: $data"); // Debugging log

      final response = await APIService.post(
        '${UrlPath.loginUrl.create_employee}/$token',
        data: data,
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      // Debugging logs
      print("API Response Status Code: ${response.status}");
      print("API Response Data: ${response.fullBody}");
      log("${response.status}");

      if (response.status == true && response.fullBody != null) {
        final responseData = response.fullBody;

        // Check for success in response body
        if (responseData['success'] == true) {
          print("✅ Employee added successfully");
          isApiValidationError = false;
          notifyListeners();
          return response;
        } else {
          // Handle API failure based on response message
          print(
              "❌ API responded with failure message: ${responseData['message']}");
          throw APIException(
            type: APIErrorType.auth,
            message: responseData['message'] ?? "Failed to add employee.",
          );
        }
      } else {
        // Handle API error based on status
        print("❌ API error, status code: ${response.status}");
        throw APIException(
          type: APIErrorType.auth,
          message: "Error while creating employee.",
        );
      }
    } catch (e, stacktrace) {
      print("❌ Error in createEmployee: $e");
      print("Stacktrace: $stacktrace");

      if (e is APIException) {
        throw e; // Rethrow the actual APIException
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: "Unexpected error occurred.",
        );
      }
    } finally {
      isLoading = false;
    }
  }

  Future<APIResp> updateEmployee({
    required String shopId,
    required String employeeId,
    required String name,
    required int age,
    required String mobile,
    required String dob,
    required String address,
    required String salary,
    required String designation, // Kept as "deignation" to match backend
    required String dateOfJoin,
    required List<String> target, // target as List<String>
    required String employeeImage,
  }) async {
    try {
      isLoading = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      // Prepare the data to be sent to the backend
      Map<String, dynamic> data = {
        'employee_id': employeeId,
        'shop_id': shopId,
        'name': name,
        'age': age.toString(),
        'mobile': mobile,
        'dob': dob,
        'address': address,
        'employee_image': employeeImage,
        'salary': salary,
        'deignation': designation, // Ensure spelling matches backend
        'date_of_join': dateOfJoin,
        'target':
            target, // Send target as List<String> (backend expects an array)
      };

      // Make the API call using the service
      final response = await APIService.post(
        '${UrlPath.loginUrl.update_employeeDetails}/$token',
        data: data,
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print('---------------- ${response.status} ------------');

      if (response.status == true) {
        return response;
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: "Error while updating employee.",
        );
      }
    } catch (e) {
      throw APIException(
        type: APIErrorType.auth,
        message: e.toString(),
      );
    } finally {
      isLoading = false;
    }
  }

  Future<APIResp> createProduct({
    required String shopId,
    required String productName,
    required String category,
    required String purchaseCost,
    required String productCategoryId,
    required String unit,
    required String stock,
    String? base64Image,
    String? menuRate, // Required for "Direct" category
  }) async {
    print("-------------------creating product-----------------");
    try {
      // ✅ Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      _isLoading = true;
      notifyListeners();

      // ✅ Prepare request data
      Map<String, dynamic> requestBody = {
        "shop_id": shopId,
        "product_name": productName.trim(),
        "category": category,
        "purchase_cost": purchaseCost,
        "product_category_id": productCategoryId,
        "unit": unit,
        "stock": stock,
        "image": base64Image,
      };

      // ✅ Include menu_rate if category is "Direct"
      if (category == "Direct" && menuRate != null && menuRate.isNotEmpty) {
        requestBody["menu_rate"] = menuRate;
      }

      // ✅ Send API request
      final resp = await APIService.post(
        '${UrlPath.loginUrl.addProduct}/$token',
        data: requestBody,
        showNoInternet: true,
        auth: true,
        forceLogout: false,
        console: true,
        timeout: const Duration(seconds: 60), // ✅ Increased timeout
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Response Data: ${resp.data}");

      if (resp.status) {
        print(
            "-------------------creating product resp.status ${resp.status}-----------------");
        // ✅ Parse response using model
        CreateProductModel productResponse =
            CreateProductModel.fromMap(resp.fullBody);

        if (productResponse.success) {
          return APIResp(
            statusCode: resp.statusCode,
            data: resp.fullBody,
            status: true,
          );
        } else {
          throw APIException(
            type: APIErrorType.auth,
            message: productResponse.message,
          );
        }
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: resp.data?.toString() ?? "Failed to add product",
        );
      }
    } catch (e) {
      print("❌ Error in createProduct: $e");
      throw APIException(
        type: APIErrorType.auth,
        message: e.toString(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<APIResp> updateProduct({
    required String shopId,
    required String productName,
    required String category,
    required String purchaseCost,
    required String productCategoryId,
    required String unit,
    required String stock,
    String? productImage,
  }) async {
    print('------------------------updated product---------------');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      // Ensure stock is not empty or invalid
      String finalStock =
          stock.isEmpty || int.tryParse(stock) == null || int.parse(stock) <= 0
              ? '0' // Or set a default value
              : stock;

      Map<String, dynamic> data = {
        'shop_id': shopId,
        'product_name': productName,
        'category': category,
        'purchase_cost': purchaseCost,
        'product_category_id': productCategoryId,
        'unit': unit,
        'stock': finalStock, // Use validated stock value
        'image': productImage ?? "",
      };

      final response = await APIService.post(
        '${UrlPath.loginUrl.updateProduct}/$token',
        data: data,
        auth: true,
      );

      return APIResp.fromJson(response.data);
    } catch (e) {
      throw APIException(
        type: APIErrorType.network,
        message: "Network error: ${e.toString()}",
      );
    }
  }

  Future<APIResp> deleteproduct({
    required String shopId,
    required String productId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.TOKEN);

    if (token == null) {
      throw APIException(
        type: APIErrorType.auth,
        message: "Authentication failed. Please log in again!",
      );
    }

    final resp = await APIService.post(
      '${UrlPath.loginUrl.deleteProduct}/$token',
      data: {
        "product_id": productId,
        "shop_id": shopId,
      },
      showNoInternet: false,
      auth: true,
      forceLogout: false,
      console: true,
      timeout: const Duration(seconds: 30),
    );

    print("API Response: ${resp.fullBody}");
    print("Status Code: ${resp.statusCode}");

    if (resp.status) {
      isApiValidationError = false;
      return resp;
    } else if (!resp.status && resp.data == "Validation Error") {
      if (resp.fullBody != null && resp.fullBody is Map<String, dynamic>) {
        AppConstants.apiValidationModel =
            ApiValidationModel.fromJson(resp.fullBody);
      }
      isApiValidationError = true;
      notifyListeners();
      return resp;
    } else {
      throw APIException(
        type: APIErrorType.auth,
        message: resp.data?.toString() ??
            "Product deletion failed. Please try again!",
      );
    }
  }

  Future<APIResp> addProduct({
    required String productName,
    required String category,
    required String purchaseCost,
    required String productCategoryId,
    required String mrp,
    required String stock,
    required String unit,
    required String imageBase64,
    required String menuRate,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw Exception("Authentication token not found");
      }

      final response = await APIService.post(
        '${UrlPath.loginUrl.addProduct}/$token',
        data: {
          "product_name": productName,
          "category": category,
          "purchase_cost": purchaseCost,
          "product_category_id": productCategoryId,
          "mrp": mrp,
          "stock": stock,
          "unit": unit,
          "product_image": imageBase64,
          "menu_rate": menuRate,
        },
        auth: true,
      );

      return APIResp(
        statusCode: response.statusCode,
        data: response.fullBody,
        status: response.status,
      );
    } catch (e) {
      throw Exception("Error in addProduct: $e");
    }
  }

  Future<APIResp> updatedProduct({
    required String productId,
    required String productName,
    required String category,
    required String purchaseCost,
    required String productCategoryId,
    required String mrp,
    required String unit,
    required String imageBase64,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw Exception("Authentication token not found");
      }

      final response = await APIService.post(
        '${UrlPath.loginUrl.updateProduct}/$productId/$token',
        data: {
          "product_name": productName,
          "category": category,
          "purchase_cost": purchaseCost,
          "product_category_id": productCategoryId,
          "mrp": mrp,
          "unit": unit,
          "product_image": imageBase64,
        },
        auth: true,
      );

      return APIResp(
        statusCode: response.statusCode,
        data: response.fullBody,
        status: response.status,
      );
    } catch (e) {
      throw Exception("Error in updateProduct: $e");
    }
  }

  Future<APIResp> addMenu({
    required String shopId,
    required String menuName,
    required String? menuImage,
    required double preparationCost,
    required String menuCategoryId,
    required double rate,
    required String menuDate,
    required List<String> productIds,
    required List<String> productNames,
    required List<String> quantities,
    required List<String> units,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      // Get authentication token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      // Prepare data for the API request
      Map<String, dynamic> data = {
        'shop_id': shopId,
        'menu_name': menuName,
        'menu_image': menuImage, // Assuming it's base64 encoded
        'preparation_cost': preparationCost,
        'menu_category_id': menuCategoryId,
        'rate': rate,
        'menu_date': menuDate,
        'product_id': productIds.join('###'),
        'product_name': productNames.join('###'),
        'quantity': quantities.join('###'),
        'unit': units.join('###'),
      };

      print("Sending data: $data"); // Debugging log

      final response = await APIService.post(
        '${UrlPath.loginUrl.add_menu}/$token',
        data: data,
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      // Debugging logs
      print("API Response Status Code: ${response.status}");
      print("API Response Data: ${response.fullBody}");

      if (response.status == true && response.fullBody != null) {
        final responseData = response.fullBody;

        // Check for success in response body
        if (responseData['success'] == true) {
          print("✅ Menu added successfully");
          isLoading = false;
          notifyListeners();
          return response;
        } else {
          // Handle API failure based on response message
          print(
              "❌ API responded with failure message: ${responseData['message']}");
          throw APIException(
            type: APIErrorType.auth,
            message: responseData['message'] ?? "Failed to add menu.",
          );
        }
      } else {
        // Handle API error based on status
        print("❌ API error, status code: ${response.status}");
        throw APIException(
          type: APIErrorType.auth,
          message: "Error while adding menu.",
        );
      }
    } catch (e, stacktrace) {
      print("❌ Error in addMenu: $e");
      print("Stacktrace: $stacktrace");

      if (e is APIException) {
        throw e; // Rethrow the actual APIException
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: "Unexpected error occurred.",
        );
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  

  Future<APIResp> createExpense({
    required String token,
    required String shopId,
    required String expenseName,
    required String expenseDescription,
    required double expenseAmount,
    required String expenseDate,
    required String employeeId,
    required String employeeName,
  }) async {
    try {
      final resp = await APIService.post(
        UrlPath.loginUrl.createExpense, // Update with the correct URL path
        data: {
          "shop_id": shopId,
          "expense_name": expenseName,
          "expense_description": expenseDescription,
          "expense_amount": expenseAmount,
          "expense_date": expenseDate,
          "employee_id": employeeId,
          "employee_name": employeeName,
        },
        showNoInternet: false,
        auth: true, // Assuming authentication is required
        forceLogout: false,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Raw Response Data: ${resp.data}");
      print(
          "Full Body: ${resp.fullBody}"); // Debugging the full body of the response

      if (resp.status) {
        // Assuming the response contains a message on success
        return APIResp(
          statusCode: resp.statusCode,
          data: resp.fullBody, // Using fullBody for the response data
          status: true,
        );
      }

      return resp;
    } catch (e) {
      print("Error in createExpense: $e");
      rethrow;
    }
  }

  
  Future<APIResp> addPurchase({
    required String shopId,
    required String productName,
    required String category,
    required String purchaseCost,
    required String productCategoryId,
    required String unit,
    required String stock,
    required String productStatus,
    required String purchaseDate,
    required String mrp,
    required String? productImage, // Base64 encoded image
    required List<String> menuIds,
    required String menuRate,
    required String productId,
  }) async {
    try {
      // Get token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      _isLoading = true;
      notifyListeners();

      // Create model instance and convert to JSON
      AddPurchaseModel purchaseModel = AddPurchaseModel(
        shopId: shopId,
        productName: productName,
        category: category,
        purchaseCost: purchaseCost,
        productCategoryId: productCategoryId,
        unit: unit,
        stock: stock,
        productStatus: productStatus,
        purchaseDate: purchaseDate,
        mrp: mrp,
        productImage: productImage, // Base64 image
        menuIds: menuIds,
        menuRate: menuRate,
        productId: productId,
      );

      Map<String, dynamic> requestData = purchaseModel.toJson();

      final resp = await APIService.post(
        '${UrlPath.loginUrl.add_purchase}/$token',
        data: requestData,
        showNoInternet: true,
        auth: true,
        forceLogout: false,
        console: true,
        timeout:
            const Duration(seconds: 60), // Increased timeout for image upload
      );

      print("Response Status Code: ${resp.statusCode}");
      print("Response Data: ${resp.data}");

      if (resp.status) {
        return APIResp(
          statusCode: resp.statusCode,
          data: resp.fullBody,
          status: true,
        );
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: resp.data?.toString() ?? "Failed to add purchase",
        );
      }
    } catch (e) {
      print("Error in addPurchase: $e");
      throw APIException(
        type: APIErrorType.auth,
        message: e.toString(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

}
