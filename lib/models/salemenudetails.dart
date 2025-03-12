import 'package:lara_g_admin/models/salemenumodel.dart';

class SaleMenuDetails {
  final String saleMenuId;
  final String menuId;
  final double menuPreparationCost;
  final int menuQuantity;  // This should be an int
  final MenuDetails menuDetails;

  SaleMenuDetails({
    required this.saleMenuId,
    required this.menuId,
    required this.menuPreparationCost,
    required this.menuQuantity,
    required this.menuDetails,
  });

  // Method to create SaleMenuDetails from a map (usually from API response)
  factory SaleMenuDetails.fromMap(Map<String, dynamic> json) {
    return SaleMenuDetails(
      saleMenuId: json['sale_menu_id'] ?? '',
      menuId: json['menu_id'] ?? '',
      menuPreparationCost: double.tryParse(json['menu_preparation_cost'].toString()) ?? 0.0,
      menuQuantity: int.tryParse(json['menu_quantity'].toString()) ?? 0, // Parse as int here
      menuDetails: MenuDetails.fromMap(json['menu_details']),
    );
  }
}
