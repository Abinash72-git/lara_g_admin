import 'package:flutter/material.dart';
import 'package:lara_g_admin/models/employee_models.dart';
import 'package:lara_g_admin/models/menu_model.dart';
import 'package:lara_g_admin/models/menuingredients_model.dart';
import 'package:lara_g_admin/models/purchaselist_model.dart';
import 'package:lara_g_admin/models/route_argument.dart';
import 'package:lara_g_admin/models/salemenudetails.dart';
import 'package:lara_g_admin/models/salemenumodel.dart';
import 'package:lara_g_admin/util/extension.dart';
import 'package:lara_g_admin/views/pages/employee/add_employee_page.dart';
import 'package:lara_g_admin/views/pages/employee/employee_details_page.dart';
import 'package:lara_g_admin/views/pages/add_shop_page.dart';
import 'package:lara_g_admin/views/pages/app_pages.dart';
import 'package:lara_g_admin/views/pages/capital_expense_add_update_page.dart';
import 'package:lara_g_admin/views/pages/capital_expense_list_page.dart';
import 'package:lara_g_admin/views/pages/employee/employee_select_list_page.dart';
import 'package:lara_g_admin/views/pages/employee/employees_page.dart';
import 'package:lara_g_admin/views/pages/homepage.dart';
import 'package:lara_g_admin/views/pages/login_page.dart';
import 'package:lara_g_admin/views/pages/menu/menu_add_page.dart';
import 'package:lara_g_admin/views/pages/menu/menu_edit_page.dart';
import 'package:lara_g_admin/views/pages/menu/menu_ingredient_list_page.dart';
import 'package:lara_g_admin/views/pages/menu/menu_list_page.dart';
import 'package:lara_g_admin/views/pages/otp_verification_page.dart';
import 'package:lara_g_admin/views/pages/product/product_add_page.dart';
import 'package:lara_g_admin/views/pages/product/product_list_page.dart';
import 'package:lara_g_admin/views/pages/profile_edit.dart';
import 'package:lara_g_admin/views/pages/purchase/purchase_add_page.dart';
import 'package:lara_g_admin/views/pages/purchase/purchase_details_page.dart';

import 'package:lara_g_admin/views/pages/purchase/purchase_list_page.dart';
import 'package:lara_g_admin/views/pages/purchase/purchase_product_select_page.dart';
import 'package:lara_g_admin/views/pages/purchase/purchase_update_page.dart';
import 'package:lara_g_admin/views/pages/register_page.dart';
import 'package:lara_g_admin/views/pages/sale_add_page.dart';
import 'package:lara_g_admin/views/pages/sale_menu_list_page.dart';
import 'package:lara_g_admin/views/pages/sales_list_page.dart';
import 'package:lara_g_admin/views/pages/shop_choose_page.dart';
import 'package:lara_g_admin/views/pages/shop_list_page.dart';

import 'package:lara_g_admin/views/pages/splash_page.dart';
import 'package:lara_g_admin/workspace/demoaddproduct.dart';
import 'package:lara_g_admin/workspace/demoshopchoose.dart';

enum AppRouteName {
  splashPage('/splash_page'),
  loginpage('/login_page'),
  verifyOtp('/otp_verification_page'),
  registerpage('/register_page'),
  addShoppage('/add_shop_page'),
  appPage('/app_pages'),
  demoshopchoose('/demoshopchoose'),
  shopChoose('/shop_choose_page'),
  shop_list('/shop_list_page'),
  profile_editpage('/profile_edit'),

  homepage('/homepage'),

  employeePage('/employees_page'),
  addemployee('/add_employee_page'),
  employeedetails('/employee_details_page'),
  employeeselectedpage('/employee_select_list_page'),

  salesListpage('/sales_list_page'),
  salesMenuListpage('/sale_menu_list_page'),
  salesAddpage('/sale_add_page'),

  purchase_list('/purchase_list_page'),
  purchaseProductSelectPage('/purchase_product_select_page'),
  purchaseaddpage('purchase_add_page'),
  purchasedetailspage('/purchase_details_page'),
  purchaseupdatepage('/purchase_update_page'),
  menuList_page('/menu_list_page'),
  menuAdd_page('/menu_add_page.'),
  menuIngredients_page('menu_ingredient_list_page'),

  product_list('/product_list_page'),
  product_add('/product_add_page'),
  demoproduct_add('/demoaddproduct'),
  capitalExpense_page("/capital_expense_list_page"),
  addcapitalExpense_page('/capital_expense_add_update_page');

  final String value;
  const AppRouteName(this.value);
}

extension AppRouteNameExt on AppRouteName {
  Future<T?> push<T extends Object?>(BuildContext context,
      {Object? args}) async {
    print("Attempting to push route: $value with args: $args");
    try {
      final result =
          await Navigator.pushNamed<T>(context, value, arguments: args);
      print("Push completed for route: $value");
      return result;
    } catch (e) {
      print("Error pushing route $value: $e");
      rethrow;
    }
  }

  Future<T?> pushAndRemoveUntil<T extends Object?>(
    BuildContext context,
    bool Function(Route<dynamic>) predicate, {
    Object? args,
  }) async {
    return await Navigator.pushNamedAndRemoveUntil<T>(context, value, predicate,
        arguments: args);
  }

  Future<T?> popAndPush<T extends Object?>(BuildContext context,
      {Object? args}) async {
    return await Navigator.popAndPushNamed(context, value);
  }
}

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    final name = AppRouteName.values
        .where((element) => element.value == settings.name)
        .firstOrNull;

    switch (name) {
      case AppRouteName.splashPage:
        return MaterialPageRoute(builder: (_) => Splash());
      case AppRouteName.loginpage:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case AppRouteName.addShoppage:
        final bool isFirstTime = (args as bool?) ?? false;
        return MaterialPageRoute(
            builder: (_) => AddShoppage(isFirstTime: isFirstTime));

      case AppRouteName.appPage:
        return MaterialPageRoute(builder: (_) => AppPages(tabNumber: 0));
      case AppRouteName.verifyOtp:
        return MaterialPageRoute(builder: (_) => OTPpage());
      case AppRouteName.registerpage:
        return MaterialPageRoute(builder: (_) => Registerpage());
      case AppRouteName.shopChoose:
        return MaterialPageRoute(builder: (_) => ShopChoosePage());
      case AppRouteName.demoshopchoose:
        return MaterialPageRoute(builder: (_) => DemoShopChoosePage());
      case AppRouteName.shop_list:
        return MaterialPageRoute(builder: (_) => ShopListPage());
      case AppRouteName.profile_editpage:
        return MaterialPageRoute(builder: (_) => ProfileEdit());

      case AppRouteName.employeePage:
        return MaterialPageRoute(builder: (_) => EmployeesPage());
      case AppRouteName.addemployee:
        final RouteArgument data = args as RouteArgument;
        return MaterialPageRoute(builder: (_) => AddEmployeepage(data: data));

      case AppRouteName.purchase_list:
        return MaterialPageRoute(builder: (_) => PurchaseListPage());
      case AppRouteName.purchaseProductSelectPage:
        return MaterialPageRoute(builder: (_) => PurchaseProductSelectPage());
      case AppRouteName.menuList_page:
        return MaterialPageRoute(builder: (_) => MenuListPage());
      case AppRouteName.menuAdd_page:
        return MaterialPageRoute(builder: (_) => MenuAddpage());
      case AppRouteName.product_list:
        return MaterialPageRoute(builder: (_) => ProductListPage());
      case AppRouteName.product_add:
        final RouteArgument data = args as RouteArgument;
        return MaterialPageRoute(builder: (_) => ProductAddpage(data: data));

      case AppRouteName.purchaseaddpage:
        final RouteArgument data = args as RouteArgument;
        return MaterialPageRoute(builder: (_) => PurchaseAddpage(data: data));

      case AppRouteName.capitalExpense_page:
        return MaterialPageRoute(builder: (_) => CapitalExpenseListPage());
      case AppRouteName.addcapitalExpense_page:
        final RouteArgument data = args as RouteArgument;
        return MaterialPageRoute(
            builder: (_) => CaptalExpenseAddUpdatepage(data: data));

      case AppRouteName.employeedetails:
        final RouteArgument data = args as RouteArgument;
        final EmployeeModel employee = data.data["employee"] as EmployeeModel;
        return MaterialPageRoute(
            builder: (_) => EmployeeDetailsPage(employee: employee));

      case AppRouteName.salesListpage:
        return MaterialPageRoute(builder: (_) => SalesListPage());

      case AppRouteName.salesMenuListpage:
        if (args is Map) {
          final saleMenu = args['saleMenu'] as List<SaleMenuDetails>;
          final menuDetails = args['menuDetails'] as List<MenuDetails>;
          return MaterialPageRoute(
            builder: (_) => SaleMenuListPage(
              saleMenu: saleMenu,
              menuDetails: menuDetails,
            ),
          );
        }
        return _errorRoute();
      case AppRouteName.salesAddpage:
        return MaterialPageRoute(builder: (_) => SaleAddpage());

      case AppRouteName.menuIngredients_page:
        final RouteArgument? data = args as RouteArgument?;
        final MenuModel menu = data!.data["menuIngredient"] as MenuModel;
        return MaterialPageRoute(
            builder: (_) => MenuIngredientListPage(menu: menu));

      case AppRouteName.purchaseupdatepage:
        final PurchaseModel purchase = args as PurchaseModel;
        return MaterialPageRoute(
            builder: (_) => PurchaseUpdatepage(purchase: purchase));

      case AppRouteName.purchasedetailspage:
        final PurchaseModel purchase = args as PurchaseModel;
        return MaterialPageRoute(
            builder: (_) => PurchaseDetailsPage(purchase: purchase));

      case null:
        return MaterialPageRoute(
            builder: (_) => Scaffold(body: Center(child: Text("Route Error"))));

      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(body: Center(child: Text("Route Error"))));
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(body: Center(child: Text("Page not found"))),
    );
  }
}

// class RouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     final args = settings.arguments;
//     switch (settings.name) {
//       case AppConstants.APPPAGES:
//         return MaterialPageRoute(
//             builder: (_) => AppPages(tabNumber: args as int));
//       case AppConstants.LOGIN:
//         return MaterialPageRoute(builder: (_) => LoginPage());
//       case AppConstants.OTPPAGE:
//         return MaterialPageRoute(
//             builder: (_) => OTPpage(mobile: args as String));
//       case AppConstants.REGISTERPAGE:
//         return MaterialPageRoute(
//             builder: (_) => Registerpage(mobile: args as String));
//       case AppConstants.ADDSHOPPAGE:
//         return MaterialPageRoute(
//             builder: (_) => AddShoppage(
//                   isFirstTime: args as bool,
//                 ));
//       case AppConstants.EMPLOYEESPAGE:
//         return MaterialPageRoute(builder: (_) => EmployeesPage());
//       case AppConstants.ADDEMPLOYEEPAGE:
//         return MaterialPageRoute(
//             builder: (_) => AddEmployeepage(
//                   data: args as RouteArgument,
//                 ));
//       case AppConstants.PURCHASELISTPAGE:
//         return MaterialPageRoute(builder: (_) => PurchaseListPage());
//       case AppConstants.PRODUCTLISTPAGE:
//         return MaterialPageRoute(builder: (_) => ProductListPage());
//       case AppConstants.MENULISTPAGE:
//         return MaterialPageRoute(builder: (_) => MenuListPage());
//       case AppConstants.SALESLISTPAGE:
//         return MaterialPageRoute(builder: (_) => SalesListPage());
//       case AppConstants.SHOPUPDATEPAGE:
//         return MaterialPageRoute(
//             builder: (_) => UpdateShoppage(
//                   shop: args as ShopModel,
//                 ));
//       case AppConstants.PRODUCTADDPAGE:
//         return MaterialPageRoute(
//             builder: (_) => ProductAddpage(
//                   data: args as RouteArgument,
//                 ));
//       case AppConstants.PURCHASEADDPAGE:
//         return MaterialPageRoute(
//             builder: (_) => PurchaseAddpage(
//                   data: args as RouteArgument,
//                 ));
//       case AppConstants.PURCHASEPRODUCTSELECTPAGE:
//         return MaterialPageRoute(builder: (_) => PurchaseProductSelectPage());
//       case AppConstants.PRODUCTSELECTLISTPAGE:
//         return MaterialPageRoute(builder: (_) => ProductSelectListPage());
//       case AppConstants.PURCHASEUPDATEPAGE:
//         return MaterialPageRoute(
//             builder: (_) => PurchaseUpdatepage(
//                   purchase: args as PurchaseModel,
//                 ));
//       case AppConstants.MENUADDPAGE:
//         return MaterialPageRoute(builder: (_) => MenuAddpage());
//       case AppConstants.SHOPCHOOSEPAGE:
//         return MaterialPageRoute(builder: (_) => ShopChoosePage());
//       case AppConstants.SALEADDPAGE:
//         return MaterialPageRoute(builder: (_) => SaleAddpage());
//       case AppConstants.SALEMENULISTPAGE:
//         return MaterialPageRoute(
//             builder: (_) => SaleMenuListPage(
//                   saleMenu: args as List<SaleMenuModel>,
//                 ));
//       case AppConstants.EMPLOYEEDETAILSPAGE:
//         return MaterialPageRoute(
//             builder: (_) => EmployeeDetailsPage(
//                   employee: args as EmployeeModel,
//                 ));
//       case AppConstants.PURCHASEDETAILSPAGE:
//         return MaterialPageRoute(
//             builder: (_) => PurchaseDetailsPage(
//                   purchase: args as PurchaseModel,
//                 ));
//       case AppConstants.PRODUCTDETAILSPAGE:
//         return MaterialPageRoute(
//             builder: (_) => ProductDetailsPage(
//                   product: args as ProductModel,
//                 ));
//       case AppConstants.MENUINGREDIENTLISTPAGE:
//         return MaterialPageRoute(
//             builder: (_) => MenuIngredientListPage(
//                   menu: args as MenuModel,
//                 ));
//       case AppConstants.MENUEDITPAGE:
//         return MaterialPageRoute(
//             builder: (_) => MenuEditpage(
//                   data: args as dynamic,
//                 ));
//       case AppConstants.CAPITALEXPENSELISTPAGE:
//         return MaterialPageRoute(builder: (_) => CapitalExpenseListPage());
//       case AppConstants.CAPITALEXPENSEADDUPDATEPAGE:
//         return MaterialPageRoute(
//             builder: (_) => CaptalExpenseAddUpdatepage(
//                   data: args as RouteArgument,
//                 ));
//       case AppConstants.EMPLOYEESELECTPAGE:
//         return MaterialPageRoute(builder: (_) => EmployeeSelectListPage());
//       case AppConstants.INVENTORYPURCHASELISTPAGE:
//         return MaterialPageRoute(builder: (_) => InventoryPurchaseListPage());
//       case AppConstants.WASTAGELISTPAGE:
//         return MaterialPageRoute(builder: (_) => WastageListPage());
//       case AppConstants.WASTAGEADDPAGE:
//         return MaterialPageRoute(builder: (_) => WastageAddpage());
//       case AppConstants.WASTAGEMENULISTPAGE:
//         return MaterialPageRoute(
//             builder: (_) => WastageMenuListPage(
//                   wastageMenu: args as List<WastageMenuModel>,
//                 ));
//       case AppConstants.INVENTORYPURCHASEADDPAGE:
//         return MaterialPageRoute(
//             builder: (_) => InventoryPurchaseAddpage(
//                   data: args as RouteArgument,
//                 ));
//       // case '/choose_product_page':
//       //   return MaterialPageRoute(builder: (_) => ChooseProductPage());
//       case AppConstants.TARGETPAGE:
//         return MaterialPageRoute(
//             builder: (_) => TargetPage(
//                 //  data: args as RouteArgument,
//                 ));
//       case AppConstants.TARGETDETAILSPAGE:
//         return MaterialPageRoute(
//             builder: (_) => TargetDetailsPage(
//                   employee: args as EmployeeModel,
//                   // TargetDetailsPage: args as ,
//                 ));
//       default:
//         return MaterialPageRoute(
//             builder: (_) =>
//                 const SafeArea(child: Scaffold(body: Text("Route Error"))));
//     }
//   }
// }
// // MaterialPageRoute(builder: (_) => Page())
