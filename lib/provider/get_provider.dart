import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lara_g_admin/enum/enum.dart';
import 'package:lara_g_admin/models/employee_models.dart';
import 'package:lara_g_admin/models/getExpense_model.dart';
import 'package:lara_g_admin/models/inventory_model.dart';
import 'package:lara_g_admin/models/menu_model.dart';
import 'package:lara_g_admin/models/menuingredients_model.dart';
import 'package:lara_g_admin/models/product_model.dart';
import 'package:lara_g_admin/models/product_category_model.dart';
import 'package:lara_g_admin/models/purchaselist_model.dart';
import 'package:lara_g_admin/models/saledetails_model.dart';

import 'package:lara_g_admin/models/shop_details_model.dart';
import 'package:lara_g_admin/services/api_service.dart';
import 'package:lara_g_admin/util/app_constants.dart';
import 'package:lara_g_admin/util/exception.dart';
import 'package:lara_g_admin/util/url_path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<ShopDetailsModel> _resultList = [];
  List<EmployeeModel> _employeeList = [];
  List<PurchaseModel> _Purchaselist = [];
  List<ProductCategoryModel> _productcategories = [];
  List<ProductCategoryModel> _Dproductcategories = [];
  List<ProductModel> _productList = [];
  List<MenuModel> _menuList = [];
  List<MenuIngredientModel> _menuIngredients = [];

  List<SaleModel> _saleslist = [];

  List<CapitalExpenseModel> _capitalExpense = [];
  List<InventoryModel> _inventoryList = [];

  bool get isLoading => _isLoading;

  List<ShopDetailsModel> get resultList => _resultList;
  List<EmployeeModel> get employeesList => _employeeList;
  List<PurchaseModel> get purchaseList => _Purchaselist;
  List<ProductCategoryModel> get productcategories => _productcategories;

  List<ProductCategoryModel> get Dproductcategories => _Dproductcategories;
  List<ProductModel> get productList => _productList;
  List<MenuModel> get menuList => _menuList;
  List<MenuIngredientModel> get menuIngredients => _menuIngredients;

  List<SaleModel> get salesList => _saleslist;

  List<CapitalExpenseModel> get capitalExpense => _capitalExpense;
  List<InventoryModel> get inventoryList => _inventoryList;

  void setCapitalExpense(List<CapitalExpenseModel> expenses) {
    _capitalExpense = expenses;
    notifyListeners();
  }

  // Setter to safely change loading state and notify listeners
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Notify listeners about the state change
  }

  Future<void> getShopList() async {
    if (_isLoading) return; // Prevent multiple concurrent API calls

    try {
      isLoading = true; // Use setter to set isLoading to true

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      final response = await APIService.get(
        '${UrlPath.loginUrl.getShopDetails}/$token',
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response status: ${response.status}");
      print("Response fullBody: ${response.fullBody}");

      // Check if response has data
      if (response.fullBody != null && response.fullBody['result'] != null) {
        final List<dynamic> result = response.fullBody['result'];
        _resultList = ShopDetailsModel.fromList(result);

        print("Parsed resultList length: ${_resultList.length}");

        // Assuming you want to store the first shopId and userId from the result
        if (_resultList.isNotEmpty) {
          String shopId = _resultList[0].shopId;
          String userId = _resultList[0].userId;

          // Save shopId and userId in SharedPreferences
          await prefs.setString(AppConstants.SHOPID, shopId);
          await prefs.setString(AppConstants.USERID, userId);

          print("Saved shopId: $shopId and userId: $userId");
        }
      } else {
        print("No data in response");
        _resultList = [];
      }
    } catch (e) {
      print("Error in getShopDetails: $e");
      _resultList = [];
    } finally {
      isLoading = false; // Use setter to set isLoading to false
    }
  }

  Future<void> getEmployeeList() async {
    if (_isLoading) return; // Prevent multiple API calls at the same time

    try {
      isLoading = true; // Set loading to true before API call

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);
      String? shopId = prefs.getString(AppConstants.SHOPID);

      if (token == null || shopId == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication failed, missing token or shop ID",
        );
      }

      final response = await APIService.post(
        '${UrlPath.loginUrl.get_employee}/$token',
        data: {"shop_id": shopId},
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response Status: ${response.status}");
      print("Response Body: ${response.fullBody}");

      // Check if response contains employee data
      if (response.fullBody != null && response.fullBody['result'] != null) {
        final List<dynamic> result = response.fullBody['result'];

        _employeeList = result
            .map((e) => EmployeeModel.fromJson(e))
            .toList(); // ✅ Fix parsing issue
        print("Parsed Employee List Length: ${_employeeList.length}");
      } else {
        print("No employee data found in response");
        _employeeList = [];
      }
    } catch (e) {
      print("Error in getEmployeeList: $e");
      _employeeList = [];
    } finally {
      isLoading = false; // Set loading to false after API call
    }
  }

  Future<void> getPurchaseList(String shopId, String type) async {
    print("----------------------- get purchase List-----------------");
    if (_isLoading) return;

    try {
      _isLoading = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      // Changed to POST method
      final response = await APIService.post(
        // Changed from get to post
        '${UrlPath.loginUrl.get_purchaseList}/$token',
        data: {
          // Changed from params to data for POST request
          'shop_id': shopId,
          'type': type,
        },
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response status: ${response.statusCode}");
      print("Response fullBody: ${response.fullBody}");

      if (response.fullBody != null && response.fullBody['result'] != null) {
        final List<dynamic> result = response.fullBody['result'];
        print('<----------------------api result $result ---------------->');
        _Purchaselist = PurchaseModel.fromList(result);
        print(
            '<------------------------purchase $_Purchaselist ------------------->');
        print("Parsed productList length: ${_Purchaselist.length}");
      } else {
        print("No data in response");
        _Purchaselist = [];
      }
    } catch (e) {
      print("Error in getProductList: $e");
      _Purchaselist = [];
    } finally {
      _isLoading = false;
    }
  }

  Future<void> getProductCategories(String token) async {
    print("----------------------- get product categories-----------------");

    if (_isLoading) return;

    try {
      _isLoading = true;

      // Changed to POST method
      final response = await APIService.post(
        // Changed from get to post
        '${UrlPath.loginUrl.get_productCategory}/$token',
        data: {}, // Empty data object for POST request
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response status: ${response.statusCode}");
      print("Response fullBody: ${response.fullBody}");

      if (response.statusCode == 200 && response.fullBody != null) {
        final data = response.fullBody['result'];

        if (data != null) {
          _productcategories = ProductCategoryModel.fromList(data);
          print("Parsed categories length: ${_productcategories.length}");
        } else {
          print("No categories found in response");
          _productcategories = [];
        }
      } else {
        print("Failed to load categories with status: ${response.statusCode}");
        _productcategories = [];
      }
    } catch (e) {
      print("Error in getProductCategories: $e");
      _productcategories = [];
    } finally {
      _isLoading = false;
    }
  }
//recentlly worked api call
  // Future<List<ProductCategoryModel>> getDProductCategories(String token) async {
  //   print("Fetching categories...");

  //   if (_isLoading) return [];

  //   try {
  //     _isLoading = true;

  //     final response = await APIService.post(
  //       '${UrlPath.loginUrl.get_productCategory}/$token',
  //       data: {},
  //       auth: true,
  //       console: true,
  //       timeout: const Duration(seconds: 30),
  //     );

  //     print("Response status: ${response.statusCode}");
  //     print("Response fullBody: ${response.fullBody}");

  //     if (response.statusCode == 200 && response.fullBody != null) {
  //       final data = response.fullBody['result'];

  //       if (data != null) {
  //         print("Parsed categories length: ${data.length}");
  //         return ProductCategoryModel.fromList(data);
  //       } else {
  //         print("No categories found in response");
  //       }
  //     } else {
  //       print("Failed to load categories with status: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     print("Error in getProductCategories: $e");
  //   } finally {
  //     _isLoading = false;
  //   }

  //   return []; // ✅ This should only run if an actual error occurs
  // }
  Future<List<ProductCategoryModel>> getDProductCategories(String token) async {
    print("Fetching categories...");

    if (_isLoading) return [];

    try {
      _isLoading = true;

      final response = await APIService.post(
        '${UrlPath.loginUrl.get_productCategory}/$token',
        data: {},
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response status: ${response.statusCode}");
      print("Response fullBody: ${response.fullBody}");

      if (response.statusCode == 200 && response.fullBody != null) {
        final data = response.fullBody['result'];

        if (data != null && data is List) {
          print("Parsed categories length: ${data.length}");
          return data
              .map((json) => ProductCategoryModel.fromJson(json))
              .toList();
        } else {
          print("No categories found in response");
        }
      } else {
        print("Failed to load categories with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error in getProductCategories: $e");
    } finally {
      _isLoading = false;
    }

    return []; // Return empty list on failure
  }

  Future<void> getProductList() async {
    print('🔄 Checking if API call is already running...');
    if (_isLoading) {
      print("⚠️ Skipping API call: Already loading.");
      return;
    }

    _isLoading = true;
    notifyListeners(); // Notify UI that loading has started

    try {
      print('📡 Fetching product list from API...');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);
      String? shopId = prefs.getString(AppConstants.SHOPID);

      if (token == null || shopId == null) {
        throw Exception("❌ Authentication failed: Missing token or shop ID");
      }

      print("🛠️ API Call URL: ${UrlPath.loginUrl.get_productList}/$token");
      print("📦 Sending data: {shop_id: $shopId}");

      final response = await APIService.post(
        '${UrlPath.loginUrl.get_productList}/$token',
        data: {"shop_id": shopId},
        auth: true,
        timeout: const Duration(seconds: 30),
      );

      print("📩 API Response Status: ${response.statusCode}");
      print("📄 API Response Body: ${response.fullBody}");

      if (response.fullBody == null) {
        throw Exception("❌ API Error: Response body is null");
      }

      if (response.fullBody.containsKey('result') &&
          response.fullBody['result'] is List) {
        final List<dynamic> result = response.fullBody['result'];

        _productList = result.map((e) => ProductModel.fromJson(e)).toList();
        print("✅ Products Fetched: ${_productList.length}");
      } else {
        throw Exception(
            "⚠️ Unexpected API Response Structure: ${response.fullBody}");
      }
    } catch (e, stacktrace) {
      print("🚨 Error in getProductList: $e");
      print(stacktrace);
      _productList = []; // Reset product list on error
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify UI that loading is complete
    }
  }

  Future<void> getMenuList() async {
    if (_isLoading) return; // Prevent multiple API calls

    try {
      _isLoading = true; // Start loading

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);
      String? shopId = prefs.getString(AppConstants.SHOPID);

      if (token == null || shopId == null) {
        throw Exception("Authentication failed: Missing token or shop ID");
      }

      final response = await APIService.post(
        '${UrlPath.loginUrl.get_menu}/$token', // Correct API endpoint
        data: {"shop_id": shopId},
        auth: true,
        timeout: const Duration(seconds: 30),
      );

      if (response.fullBody != null && response.fullBody['result'] != null) {
        final List<dynamic> result = response.fullBody['result'];
        print("Fetched Menus: $result");

        // Convert the response into a list of MenuModel objects
        _menuList = result.map((e) => MenuModel.fromJson(e)).toList();
        print("Menu List Length: ${_menuList.length}");

        // Notify listeners to update the UI
        notifyListeners();
      } else {
        print("No menu data found");
        _menuList = [];
        notifyListeners(); // Make sure to notify listeners even if no data is found
      }
    } catch (e) {
      print("Error in getMenuList: $e");
      _menuList = [];
      notifyListeners(); // Ensure UI is updated even on error
    } finally {
      _isLoading = false; // Stop loading
    }
  }

  Future<void> getMenuIngredients(String token, String menuId) async {
    _isLoading = true;
    notifyListeners(); // Notify that loading is in progress

    print(
        '----------------- Fetching Menu Ingredient Details --------------------');

    try {
      final response = await APIService.post(
        '${UrlPath.loginUrl.get_menuIngredients}/$token',
        data: {"menu_id": menuId},
        auth: true,
        timeout: const Duration(seconds: 30),
      );

      if (response.fullBody != null && response.fullBody['result'] != null) {
        final List<dynamic> result = response.fullBody['result'];
        print('<----------------------api result $result ---------------->');

        // Map each result to the MenuIngredientModel
        _menuIngredients =
            result.map((item) => MenuIngredientModel.fromMap(item)).toList();

        print(
            '<------------------------MenuIngredients $_menuIngredients ------------------->');
        print("Parsed MenuIngredients length: ${_menuIngredients.length}");
      } else {
        print("No data in response");
        _menuIngredients = [];
      }
    } catch (e) {
      print("Error in getMenuIngredients: $e");
      _menuIngredients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Notify that loading has finished and state is updated

  Future<List> getCapitalExpenseList(String token, String shopId) async {
    print('----------------- Entering getExpense Api--------------------');
    try {
      final response = await APIService.post(
        '${UrlPath.loginUrl.getExpense}/$token',
        data: {"shop_id": shopId},
        auth: true,
        timeout: const Duration(seconds: 30),
      );

      if (response.statusCode == 200) {
        // final Map<String, dynamic> data = json.decode(response.fullBody);

        if (response.fullBody != null && response.fullBody['result'] != null) {
          final List<dynamic> expenses = response.fullBody['result'];
          print(
              '<----------------------api result $expenses ---------------->');

          // Map each result to the MenuIngredientModel
          _capitalExpense = expenses
              .map((item) => CapitalExpenseModel.fromJson(item))
              .toList();

          return expenses; // Return the list of expenses
        } else {
          throw Exception("Invalid response format");
        }
      } else {
        throw Exception(
            "Failed to load expenses. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      return []; // Return an empty list in case of error
    }
  }

  Future<APIResp> deleteExpense({
    required String token,
    required String shopId,
    required String expenseId,
  }) async {
    try {
      // Construct the API URL for deleting the expense
      final resp = await APIService.post(
        '${UrlPath.loginUrl.deleteExpense}/$token', // Ensure the correct endpoint
        data: {
          "shop_id": shopId, // Passing shopId
          "expense_id": expenseId, // Passing expenseId
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
        // Assuming the response contains a success message on successful deletion
        return APIResp(
          statusCode: resp.statusCode,
          data: resp.fullBody, // Using fullBody for the response data
          status: true,
        );
      }

      return resp;
    } catch (e) {
      print("Error in deleteExpense: $e");
      rethrow;
    }
  }

  Future<void> getSalesDetails(String shopId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(AppConstants.TOKEN);

    print("----------------- $token----------");
    print("----------------- $shopId-------------");

    if (token == null) {
      throw APIException(
        type: APIErrorType.auth,
        message: "Authentication token not found",
      );
    }

    try {
      isLoading = true; // Set loading state to true

      final response = await APIService.post(
        '${UrlPath.loginUrl.salemenuDetails}/$token', // Endpoint URL for sales details
        data: {"shop_id": shopId}, // Pass shop_id in the request body
        auth: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response status: ${response.status}");
      print("Response fullBody: ${response.fullBody}");

      if (response.statusCode == 200) {
        if (response.fullBody != null && response.fullBody['result'] != null) {
          final List<dynamic> salesListData = response.fullBody['result'];

          // Convert response data to a list of SalesDetails models
          _saleslist = salesListData.map((item) {
            // Parse string fields as double
            return SaleModel.fromMap({
              'sales_id': item['sales_id'],
              'sale_preparation_cost':
                  double.tryParse(item['sale_preparation_cost'].toString()) ??
                      0.0,
              'sale_price':
                  double.tryParse(item['sale_price'].toString()) ?? 0.0,
              'sale_date': item['sale_date'] ?? '',
              'created_at': item['created_at'] ?? '',
              'sale_menu_details': item['sale_menu_details'] ?? [],
            });
          }).toList();

          print("Parsed sales list length: ${_saleslist.length}");
        } else {
          throw Exception('No sales details found');
        }
      } else {
        throw Exception('Failed to load sales details');
      }
    } catch (e) {
      print("Error in getSalesDetails: $e");
      _saleslist = []; // Ensure the sales list is reset in case of error
    } finally {
      isLoading = false; // Set loading state to false
    }
  }

  Future<APIResp> updateMenu({
    required String shopId,
    required String menuId,
    required String menuName,
    required String preparationCost,
    required String rate,
    required String menuDate,
    required String menuImage,
    required List<String> productIds, // List of product IDs
    required List<String> productNames, // List of product names
    required List<String> quantities, // List of quantities
    required List<String> units, // List of units
  }) async {
    try {
      isLoading = true;

      // Retrieve the authentication token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString(AppConstants.TOKEN);

      if (token == null) {
        throw APIException(
          type: APIErrorType.auth,
          message: "Authentication token not found",
        );
      }

      // Prepare the data to send to the backend
      Map<String, dynamic> data = {
        'menu_id': menuId,
        'shop_id': shopId,
        'menu_name': menuName,
        'preparation_cost': preparationCost,
        'rate': rate,
        'menu_date': menuDate,
        'menu_image': menuImage,
        'product_id': productIds.join("###"), // Join product IDs as a string
        'product_name':
            productNames.join("###"), // Join product names as a string
        'quantity': quantities.join("###"), // Join quantities as a string
        'unit': units.join("###"), // Join units as a string
      };

      // Make the API call using your service (APIService)
      final response = await APIService.post(
        '${UrlPath.loginUrl.update_menu}/$token', // Ensure URL is correct
        data: data,
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print('---------------- ${response.status} ------------');

      // Check the response status
      if (response.status == true) {
        return response;
      } else {
        throw APIException(
          type: APIErrorType.auth,
          message: "Error while updating menu.",
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

  Future<void> getInventoryMenuDetails(String token, String productId) async {
    try {
      print("Request Token: $token");
      print("Request Data: $productId");

      final response = await APIService.post(
        '${UrlPath.loginUrl.getInventory}/$token',
        data: {'product_id': productId},
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      print("Response Status: ${response.statusCode}");
      print("Response FullBody: ${response.fullBody}");

      if (response.statusCode == 200) {
        // Since the response is already a map, no need to decode it again
        final responseData =
            response.fullBody; // Assuming it's already a Map<String, dynamic>

        print("Parsed Response Data: $responseData");

        final List<dynamic> result = responseData['result'];

        // If result is not empty, update inventoryList
        if (result.isNotEmpty) {
          _inventoryList =
              result.map((item) => InventoryModel.fromJson(item)).toList();
        } else {
          _inventoryList = [];
        }

        notifyListeners();
      } else {
        throw Exception('Failed to load inventory menu details');
      }
    } catch (e) {
      print("Error fetching inventory menu details: $e");
      rethrow;
    }
  }

  Future<void> updatePurchase(
    String token,
    String shopId,
    String purchaseId,
    String productId,
    double purchaseCost,
    double mrp,
    String unit,
    int stock,
    String purchaseDate,
  ) async {
    Map<String, dynamic> data = {
      'shop_id': shopId,
      'purchase_id': purchaseId,
      'product_id': productId,
      'purchase_cost': purchaseCost,
      'mrp': mrp,
      'unit': unit,
      'stock': stock,
      'purchase_date': purchaseDate,
    };

    try {
      final response = await APIService.post(
        '${UrlPath.loginUrl.updatePurchase}/$token',
        data: data,
        auth: true,
        console: true,
        timeout: const Duration(seconds: 30),
      );

      // Check if the response is a success and handle accordingly
      if (response.statusCode == 200) {
        // No need to decode the response as it's already a Map
        var jsonResponse = response.fullBody;

        if (jsonResponse['success'] == true) {
          print('Purchase updated successfully: ${jsonResponse['message']}');
        } else {
          print('Failed to update purchase: ${jsonResponse['message']}');
        }
      } else {
        print(
            'Error: Unable to update purchase. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error while making the request: $e');
    }
  }
}
