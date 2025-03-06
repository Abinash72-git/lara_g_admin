class Purchase {
  String purchaseId;
  String productId;
  String shopId;
  String category;
  String productName;
  int quantity;
  double purchaseCost;
  double mrp;
  String unit;
  String status;
  String purchaseDate;
  String createdAt;

  Purchase({
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
  factory Purchase.fromJson(Map<String, dynamic> json) {
    return Purchase(
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
}
