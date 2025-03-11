class UrlPath {
  static const LoginUrl loginUrl = LoginUrl();
}

class LoginUrl {
  const LoginUrl();
  final String sendOTP = 'sentOTP';
  final String verifyOTP = 'verifyOTP';
  final String createProfile = 'create_user';
  final String createShop = 'create_shop';
  final String getShopDetails = 'shop_details';
  final String deleteShop = 'delete_shop';

  final String add_menu = 'add_menu';
  final String get_menu = 'get_menu_details';
  final String get_menuCategory = 'get_menu_category';
  final String get_menuIngredients = 'get_menu_ingredient_details';
  final String update_menu = 'update_menu';

  final String create_employee = 'create_employee';
  final String update_employeeDetails = 'update_employee';
  final String get_employee = 'get_employees';

  final String add_purchase = 'add_purchase';
  final String get_purchaseList = 'get_purchase_details';
  final String updatePurchase = 'purchase_update';

  final String createExpense = 'create_expense';
  final String updateExpense = 'update_expense';
  final String deleteExpense = 'delete_expense';

  final String get_productCategory = 'get_product_category';
  final String get_productList = 'get_product_details';
  final String addProduct = 'create_product';
  final String updateProduct = 'product_update';
  final String deleteProduct = 'delete_product';

  final String getExpense = 'get_expense';

  final String salemenuDetails = 'get_sales_details';

  final String getInventory = 'get_inventory_menu_details';
}
