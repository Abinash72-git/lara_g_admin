class MenuIngredientModel {
  final String menuIngredientId;
  final String productName;
  final String category;
  final String productImage;
  final String menuIngredientQuantity;
  final String menuIngredientUnit;

  MenuIngredientModel({
    required this.menuIngredientId,
    required this.productName,
    required this.category,
    required this.productImage,
    required this.menuIngredientQuantity,
    required this.menuIngredientUnit,
  });

  factory MenuIngredientModel.fromMap(Map<String, dynamic> map) {
    return MenuIngredientModel(
      menuIngredientId: map['menu_ingredient_id'], // Ensure the key is correct
      productName: map['product_name'], // Ensure the key is correct
      category: map['category'],
      productImage: map['product_image'],
      menuIngredientQuantity: map['menu_ingredient_quantity'],
      menuIngredientUnit: map['menu_ingredient_unit'],
    );
  }
}
