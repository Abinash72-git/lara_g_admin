class AddMenuRequest {
  String shopId;
  String menuName;
  String menuImage;
  double preparationCost;
  String menuCategoryId;
  double rate;
  String menuDate;
  List<String> productIds;
  List<String> productNames;
  List<String> quantities;
  List<String> units;

  AddMenuRequest({
    required this.shopId,
    required this.menuName,
    required this.menuImage,
    required this.preparationCost,
    required this.menuCategoryId,
    required this.rate,
    required this.menuDate,
    required this.productIds,
    required this.productNames,
    required this.quantities,
    required this.units,
  });

  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'menu_name': menuName,
      'menu_image': menuImage,
      'preparation_cost': preparationCost,
      'menu_category_id': menuCategoryId,
      'rate': rate,
      'menu_date': menuDate,
      'product_id': productIds.join('###'),
      'product_name': productNames.join('###'),
      'quantity': quantities.join('###'),
      'unit': units.join('###'),
    };
  }
}
