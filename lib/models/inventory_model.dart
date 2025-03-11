class InventoryModel {
  final int inventoryId;
  final int menuId;
  final int shopId;
  final int menuCategoryId;
  final String menuName;
  final double rate;
  final double preparationCost;
  final String image;

  InventoryModel({
    required this.inventoryId,
    required this.menuId,
    required this.shopId,
    required this.menuCategoryId,
    required this.menuName,
    required this.rate,
    required this.preparationCost,
    required this.image,
  });

  // Factory constructor to create a MenuItem from JSON
  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      inventoryId: json['inventory_id'] ?? 0, // Default to 0 if not present
      menuId: json['menu_id'] ?? 0, // Default to 0 if not present
      shopId: json['shop_id'] ?? 0, // Default to 0 if not present
      menuCategoryId: json['menu_category_id'] ?? 0, // Default to 0 if not present
      menuName: json['menu_name'] ?? '', // Default to empty string if not present
      rate: (json['rate'] != null) ? json['rate'].toDouble() : 0.0, // Default to 0.0 if null
      preparationCost: (json['preparation_cost'] != null)
          ? json['preparation_cost'].toDouble()
          : 0.0, // Default to 0.0 if null
      image: json['image'] ?? '', // Default to empty string if image is missing
    );
  }
}
