class PurchaseModel {
  final String purchaseId;
  final String productId;
  final String shopId;
  final String productName;
  final String category;
  final double purchaseCost;
  final double mrp;
  final String unit;
  final int stock;
  final String purchaseDate;
  final String createdAt;
  final String productCategoryId;
  final String image;
  final int stockMinValue;  // Added field
  final bool isStockMin;    // Added field

  PurchaseModel({
    required this.purchaseId,
    required this.productId,
    required this.shopId,
    required this.productName,
    required this.category,
    required this.purchaseCost,
    required this.mrp,
    required this.unit,
    required this.stock,
    required this.purchaseDate,
    required this.createdAt,
    required this.productCategoryId,
    required this.image,
    required this.stockMinValue,  // Added parameter
    required this.isStockMin,     // Added parameter
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      purchaseId: json['purchase_id'] ?? '',
      productId: json['product_id'] ?? '',
      shopId: json['shop_id'] ?? '',
      productName: json['product_name'] ?? '',
      category: json['category'] ?? '',
      purchaseCost: (json['purchase_cost'] as num?)?.toDouble() ?? 0.0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
      stock: json['stock'] ?? 0,
      purchaseDate: json['purchase_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      productCategoryId: json['product_category_id'] ?? '',
      image: json['image'] ?? '',
      stockMinValue: json['stock_min_value'] ?? 0,  // Default to 0 if null
      isStockMin: json['stock'] <= (json['stock_min_value'] ?? 0), // Check if stock is below or equal to stockMinValue
    );
  }

  static List<PurchaseModel> fromList(List<dynamic> list) {
    return list.map((item) => PurchaseModel.fromJson(item)).toList();
  }
}
