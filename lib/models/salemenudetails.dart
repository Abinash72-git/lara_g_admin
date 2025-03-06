import 'package:lara_g_admin/models/menudetails_model.dart';

class SaleMenuDetails {
  final String saleMenuId;
  final String menuId;
  final double menuPreparationCost;
  final int menuQuantity;
  final MenuDetails menuDetails;

  SaleMenuDetails({
    required this.saleMenuId,
    required this.menuId,
    required this.menuPreparationCost,
    required this.menuQuantity,
    required this.menuDetails,
  });

  factory SaleMenuDetails.fromJson(Map<String, dynamic> json) {
    return SaleMenuDetails(
      saleMenuId: json['sale_menu_id'],
      menuId: json['menu_id'],
      menuPreparationCost: json['menu_preparation_cost'],
      menuQuantity: json['menu_quantity'],
      menuDetails: MenuDetails.fromJson(json['menu_details']),
    );
  }
}
