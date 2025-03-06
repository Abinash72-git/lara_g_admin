class MenuModel {
  final String menuId;
  final String shopId;
  final String? menuCategoryId;
  final String menuName;
  final double rate;
  final double preparationCost;
  final String? menuDate;
  final String image;

  MenuModel({
    required this.menuId,
    required this.shopId,
    this.menuCategoryId,
    required this.menuName,
    required this.rate,
    required this.preparationCost,
    this.menuDate,
    required this.image,
  });

  // Factory method to create MenuModel from JSON
  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      menuId: json['menu_id'].toString(),
      shopId: json['shop_id'].toString(),
      menuCategoryId: json['menu_category_id']?.toString(),
      menuName: json['menu_name'].toString(),
      rate: (json['rate'] != null)
          ? double.tryParse(json['rate'].toString()) ?? 0.0
          : 0.0, // Safely parse as double
      preparationCost: (json['preparation_cost'] != null)
          ? double.tryParse(json['preparation_cost'].toString()) ?? 0.0
          : 0.0, // Safely parse as double
      menuDate: json['menu_date']?.toString(),
      image: json['image'] ?? "", // Handle null images
    );
  }
}
