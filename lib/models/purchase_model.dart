class PurchaseModel {
  final String purchaseId;
  final String productId;
  final String shopId;
  final String category;
  final String productName;
  final int quantity;
  final double purchaseCost;
  final double mrp;
  final String unit;
  final String status;
  final String purchaseDate;
  final String createdAt;

  PurchaseModel({
    required this.purchaseId,
    required this.productId,
    required this.shopId,
    required this.category,
    required this.productName,
    required this.quantity,
    required this.purchaseCost,
    required this.mrp,
    required this.unit,
    required this.status,
    required this.purchaseDate,
    required this.createdAt,
  });

  // Convert from JSON
  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      purchaseId: json['purchase_id'],
      productId: json['product_id'],
      shopId: json['shop_id'],
      category: json['category'],
      productName: json['product_name'],
      quantity: json['quantity'],
      purchaseCost: json['purchase_cost'].toDouble(),
      mrp: json['mrp'].toDouble(),
      unit: json['unit'],
      status: json['status'],
      purchaseDate: json['purchase_date'],
      createdAt: json['created_at'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'purchase_id': purchaseId,
      'product_id': productId,
      'shop_id': shopId,
      'category': category,
      'product_name': productName,
      'quantity': quantity,
      'purchase_cost': purchaseCost,
      'mrp': mrp,
      'unit': unit,
      'status': status,
      'purchase_date': purchaseDate,
      'created_at': createdAt,
    };
  }

  // Override toString method for better logging
  @override
  String toString() {
    return 'PurchaseModel(purchaseId: $purchaseId, productId: $productId, shopId: $shopId, category: $category, productName: $productName, quantity: $quantity, purchaseCost: $purchaseCost, mrp: $mrp, unit: $unit, status: $status, purchaseDate: $purchaseDate, createdAt: $createdAt)';
  }
}
