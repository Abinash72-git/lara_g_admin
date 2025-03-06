class ProductCategoryModel {
  final String productCategoryId;
  final String productCategoryName;

  ProductCategoryModel({
    required this.productCategoryId,
    required this.productCategoryName,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      productCategoryId: json['product_category_id'] ?? '',
      productCategoryName: json['product_category_name'] ?? '',
    );
  }

  static List<ProductCategoryModel> fromList(List<dynamic> list) {
    return list.map((item) => ProductCategoryModel.fromJson(item)).toList();
  }
}
