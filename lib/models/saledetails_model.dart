import 'package:lara_g_admin/models/salemenudetails.dart';

class SalesDetails {
  final String salesId;
  final double salePreparationCost;
  final double salePrice;
  final String saleDate;
  final String createdAt;
  final List<SaleMenuDetails> saleMenuDetails;

  SalesDetails({
    required this.salesId,
    required this.salePreparationCost,
    required this.salePrice,
    required this.saleDate,
    required this.createdAt,
    required this.saleMenuDetails,
  });

  factory SalesDetails.fromJson(Map<String, dynamic> json) {
    var list = json['sale_menu_details'] as List;
    List<SaleMenuDetails> saleMenuDetailsList =
        list.map((i) => SaleMenuDetails.fromJson(i)).toList();

    return SalesDetails(
      salesId: json['sales_id'],
      salePreparationCost: json['sale_preparation_cost'],
      salePrice: json['sale_price'],
      saleDate: json['sale_date'],
      createdAt: json['created_at'],
      saleMenuDetails: saleMenuDetailsList,
    );
  }
}