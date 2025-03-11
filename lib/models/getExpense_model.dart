class CapitalExpenseModel {
  final String id;
  final String expenseId;
  final String shopId;
  final String expenseName;
  final String expenseDescription;
  final double expenseAmount;
  final String expenseDate;
  final String employeeId;
  final String employeeName;
  final String status;
  final String createdAt;
  final String updatedAt;

  CapitalExpenseModel({
    required this.id,
    required this.expenseId,
    required this.shopId,
    required this.expenseName,
    required this.expenseDescription,
    required this.expenseAmount,
    required this.expenseDate,
    required this.employeeId,
    required this.employeeName,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a CapitalExpenseModel from a Map
  factory CapitalExpenseModel.fromJson(Map<String, dynamic> json) {
    return CapitalExpenseModel(
      id: json['id']?.toString() ?? "",
      expenseId: json['expense_id']?.toString() ?? "",
      shopId: json['shop_id']?.toString() ?? "",
      expenseName: json['expense_name']?.toString() ?? "",
      expenseDescription: json['expense_description']?.toString() ?? "",
      expenseAmount: json['expense_amount'] != null
          ? double.tryParse(json['expense_amount'].toString()) ?? 0.0
          : 0.0,
      expenseDate: json['expense_date']?.toString() ?? "",
      employeeId: json['employee_id']?.toString() ?? "",
      employeeName: json['employee_name']?.toString() ?? "",
      status: json['status']?.toString() ?? "",
      createdAt: json['created_at']?.toString() ?? "",
      updatedAt: json['updated_at']?.toString() ?? "",
    );
  }
}
