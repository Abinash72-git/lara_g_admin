import 'dart:convert';

class UpdateProduct {
  final String productId;
  final String shopId;
  final String productName;
  final String category;
  final String purchaseCost;
  final String productCategoryId;
  final String mrp;
  final String unit;
  final String? productImage;

  UpdateProduct({
    required this.productId,
    required this.shopId,
    required this.productName,
    required this.category,
    required this.purchaseCost,
    required this.productCategoryId,
    required this.mrp,
    required this.unit,
    this.productImage,
  });

  // Convert JSON to Product object
  factory UpdateProduct.fromJson(Map<String, dynamic> json) {
    return UpdateProduct(
      productId: json['product_id'],
      shopId: json['shop_id'],
      productName: json['product_name'],
      category: json['category'],
      purchaseCost: json['purchase_cost'],
      productCategoryId: json['product_category_id'],
      mrp: json['mrp'],
      unit: json['unit'],
      productImage: json['image'],
    );
  }

  // Convert Product object to JSON
  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'shop_id': shopId,
      'product_name': productName,
      'category': category,
      'purchase_cost': purchaseCost,
      'product_category_id': productCategoryId,
      'mrp': mrp,
      'unit': unit,
      'product_image': productImage,
    };
  }
}
