class ProductModel {
  String productId;
  String shopId;
  String productCategoryId;
  String productName;
  String category;
  double purchaseCost;
  double? mrp;
  String unit;
  double stock;
  double stockMinValue;
  bool isStockMin;
  String image;

  ProductModel({
    required this.productId,
    required this.shopId,
    required this.productCategoryId,
    required this.productName,
    required this.category,
    required this.purchaseCost,
    required this.mrp,
    required this.unit,
    required this.stock,
    required this.stockMinValue,
    required this.isStockMin,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      productId: json['product_id'].toString(),
      shopId: json['shop_id'].toString(),
      productCategoryId: json['product_category_id']?.toString() ?? '',
      productName: json['product_name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      purchaseCost:
          double.tryParse(json['purchase_cost']?.toString() ?? '0.0') ?? 0.0,
      mrp: json['mrp'] != null
          ? double.tryParse(json['mrp']?.toString() ?? '0.0')
          : null,
      unit: json['unit']?.toString() ?? '',
      stock: double.tryParse(json['stock']?.toString() ?? '0.0') ?? 0.0,
      stockMinValue:
          double.tryParse(json['stock_min_value']?.toString() ?? '0.0') ??
              0.0, // Fixed typo 'stock_min_vaue' -> 'stock_min_value'
      isStockMin: json['isStockMin']?.toString().toLowerCase() ==
          'true', // Ensure boolean conversion
      image: json['image']?.toString() ?? '',
    );
  }
}
