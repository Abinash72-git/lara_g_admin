import 'package:lara_g_admin/models/salemenudetails.dart';

class SaleModel {
  final String salesId;
  final double salePreparationCost;
  final double salePrice;
  final String saleDate;
  final String createdAt;
  final List<SaleMenuDetails> saleMenu;

  SaleModel({
    required this.salesId,
    required this.salePreparationCost,
    required this.salePrice,
    required this.saleDate,
    required this.createdAt,
    required this.saleMenu,
  });

  factory SaleModel.fromMap(Map<String, dynamic> json) {
    return SaleModel(
      salesId: json['sales_id'] == null ? "" : json['sales_id'].toString(),
      salePreparationCost: json['sale_preparation_cost'] == null
          ? 0.0
          : double.tryParse(json['sale_preparation_cost'].toString()) ?? 0.0,
      salePrice: json['sale_price'] == null
          ? 0.0
          : double.tryParse(json['sale_price'].toString()) ?? 0.0,
      saleDate: json['sale_date'] == null ? "" : json['sale_date'].toString(),
      createdAt: json['created_at'] == null
          ? ""
          : json['created_at'].toString(),
      saleMenu: json['sale_menu_details'] == null
          ? <SaleMenuDetails>[]
          : List.from(json['sale_menu_details'])
              .map((e) => SaleMenuDetails.fromMap(e))
              .toList(),
    );
  }
}