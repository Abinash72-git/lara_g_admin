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
  final int stockMinValue;
  final bool isStockMin;

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
    required this.stockMinValue,
    required this.isStockMin,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      purchaseId: json['purchase_id'] ?? '',
      productId: json['product_id'] ?? '',
      shopId: json['shop_id'] ?? '',
      productName: json['product_name'] ?? '',
      category: json['category'] ?? '',
      purchaseCost: _parseToDouble(json['purchase_cost']),
      mrp: _parseToDouble(json['mrp']),
      unit: json['unit'] ?? '',
      stock: _parseToInt(json['stock']),
      purchaseDate: json['purchase_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      productCategoryId: json['product_category_id'] ?? '',
      image: json['image'] ?? '',
      stockMinValue: _parseToInt(json['stock_min_value']),
      isStockMin:
          _parseToInt(json['stock']) <= _parseToInt(json['stock_min_value']),
    );
  }

  static double _parseToDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }
    return (value as num?)?.toDouble() ?? 0.0;
  }

  static int _parseToInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return (value as int?) ?? 0;
  }

  static List<PurchaseModel> fromList(List<dynamic> list) {
    return list.map((item) => PurchaseModel.fromJson(item)).toList();
  }
}
