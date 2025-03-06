class AddPurchaseModel {
  String shopId;
  String productName;
  String category;
  String purchaseCost;
  String productCategoryId;
  String unit;
  String stock;
  String productStatus;
  String purchaseDate;
  String mrp;
  String? productImage; // Base64 encoded image
  List<String> menuIds;
  String menuRate;
  String productId;

  AddPurchaseModel({
    required this.shopId,
    required this.productName,
    required this.category,
    required this.purchaseCost,
    required this.productCategoryId,
    required this.unit,
    required this.stock,
    required this.productStatus,
    required this.purchaseDate,
    required this.mrp,
    this.productImage,
    required this.menuIds,
    required this.menuRate,
    required this.productId,
  });

  // Converts the AddPurchaseModel instance to a Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'shop_id': shopId,
      'product_name': productName,
      'category': category,
      'purchase_cost': purchaseCost,
      'product_category_id': productCategoryId,
      'unit': unit,
      'stock': stock,
      'product_status': productStatus,
      'purchase_date': purchaseDate,
      'mrp': mrp,
      'product_image': productImage,
      'menu_ids': menuIds,
      'menu_rate': menuRate,
      'product_id': productId,
    };
  }

  // Factory constructor to create an AddPurchaseModel instance from JSON data
  factory AddPurchaseModel.fromJson(Map<String, dynamic> json) {
    return AddPurchaseModel(
      shopId: json['shop_id'],
      productName: json['product_name'],
      category: json['category'],
      purchaseCost: json['purchase_cost'],
      productCategoryId: json['product_category_id'],
      unit: json['unit'],
      stock: json['stock'],
      productStatus: json['product_status'],
      purchaseDate: json['purchase_date'],
      mrp: json['mrp'],
      productImage: json['product_image'],
      menuIds: List<String>.from(json['menu_ids']),
      menuRate: json['menu_rate'],
      productId: json['product_id'],
    );
  }
}
