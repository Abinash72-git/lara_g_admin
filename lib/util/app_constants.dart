import 'package:flutter/material.dart';
import 'package:lara_g_admin/models/api_validation_model.dart';



class AppConstants {
  static const String appName = 'Lara_g_update';

  //API URL Constants
  // static const String BASE_URL = 'https://new.dev-healthplanner.xyz/api/'; //Dev
  static const String BASE_URL =
      'https://tsitfilemanager.in/vignesh/wellbits/public/api/'; //Prod

  // static final String BASE_URL = AppConfig.instance.baseUrl;

  static Map<String, String> headers = {
    //"X-API-KEY": "OpalIndiaKeysinUse",
    'Charset': 'utf-8',
    'Accept': 'application/json',
  };
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  static late ApiValidationModel apiValidationModel;

  static String networkImage =
      "https://creazilla-store.fra1.digitaloceanspaces.com/cliparts/3174456/profile-clipart-xl.png";
  // Shared Key
  static const String TOKEN = 'token';
  static const String ISFIRSTREGISTER = 'is_first_register';
  static const String SHOPID = 'shop_id';
  static const String USERNAME = 'user_name';
  static const String USEREMAIL = 'user_email';
  static const String USERMOBILE = 'user_mobile';
  static const String SHOPNAME = 'shop_name';
  static const String USERID = 'user_id';
  //Route Key constants
  static const String APPPAGES = '/pages';
  static const String LOGIN = '/login';
  static const String OTPPAGE = '/otp_verify_page';
  static const String REGISTERPAGE = '/register';
  static const String ADDSHOPPAGE = '/add_shop';
  static const String EMPLOYEESPAGE = '/employees_page';
  static const String ADDEMPLOYEEPAGE = '/add_employee';
  static const String PURCHASELISTPAGE = '/purchase_page';
  static const String PRODUCTLISTPAGE = '/product_page';
  static const String MENULISTPAGE = '/menu_page';
  static const String SALESLISTPAGE = '/sales_page';
  static const String SHOPUPDATEPAGE = '/shop_update_page';
  static const String PRODUCTADDPAGE = '/product_add_page';
  static const String PURCHASEADDPAGE = '/purchase_add_page';
  static const String PRODUCTSELECTLISTPAGE = '/purchase_product_select_page';
  static const String PURCHASEPRODUCTSELECTPAGE = '/product_select_list_page';
  static const String PURCHASEUPDATEPAGE = '/purchase_update_page';
  static const String MENUADDPAGE = '/menu_add_page';
  static const String SHOPCHOOSEPAGE = '/shop_choose_page';
  static const String SALEADDPAGE = '/sale_add_page';
  static const String SALEMENULISTPAGE = '/sale_menu_list_page';
  static const String EMPLOYEEDETAILSPAGE = '/employee_details_page';
  static const String PURCHASEDETAILSPAGE = '/purchase_details_page';
  static const String PRODUCTDETAILSPAGE = '/product_details_page';
  static const String MENUINGREDIENTLISTPAGE = '/menu_ingredient_page';
  static const String MENUEDITPAGE = '/menu_edit_page';
  static const String CAPITALEXPENSELISTPAGE = '/capital_expense_list_page';
  static const String CAPITALEXPENSEADDUPDATEPAGE =
      '/capital_expense_add_update_page';
  static const String EMPLOYEESELECTPAGE = '/employee_select_page';
  static const String INVENTORYPURCHASELISTPAGE = '/inventory_purchase_page';
  static const String WASTAGELISTPAGE = '/wastage_page';
  static const String WASTAGEADDPAGE = '/wastage_add_page';
  static const String WASTAGEMENULISTPAGE = '/wastage_menu_list_page';
  static const String INVENTORYPURCHASEADDPAGE = '/inventory_purchase_add_page';
  static const String TARGETPAGE = '/target_page';
  static const String TARGETDETAILSPAGE = '/target_details_page';
}
