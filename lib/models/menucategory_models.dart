import 'dart:convert';

class MenuCategoryModel {
  final String menuCategoryId;
  final String menuCategoryName;

  MenuCategoryModel({
    required this.menuCategoryId,
    required this.menuCategoryName,
  });

  factory MenuCategoryModel.fromMap(Map<String, dynamic> json) {
    return MenuCategoryModel(
      menuCategoryId: json['menu_category_id'] ?? '',
      menuCategoryName: json['menu_category_name'] ?? '',
    );
  }

  static List<MenuCategoryModel> fromList(List<dynamic> list) {
    return list.map((item) => MenuCategoryModel.fromMap(item)).toList();
  }
}
