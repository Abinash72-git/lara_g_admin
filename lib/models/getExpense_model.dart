class CapitalExpenseModel {
  final String id,
      expenseId,
      shopId,
      expenseName,
      expenseDescription,
      expenseAmount,
      expenseDate,
      employeeId,
      employeeName,
      status,
      createdAt,
      updatedAt;
  CapitalExpenseModel(
      {required this.id,
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
      required this.updatedAt});
  factory CapitalExpenseModel.fromMap(Map<String, dynamic> json) {
    return CapitalExpenseModel(
      id: json['id'] == null ? "" : json['id'].toString(),
      expenseId:
          json['expense_id'] == null ? "" : json['expense_id'].toString(),
      shopId: json['shop_id'] == null ? "" : json['shop_id'].toString(),
      expenseName:
          json['expense_name'] == null ? "" : json['expense_name'].toString(),
      expenseDescription: json['expense_description'] == null
          ? ""
          : json['expense_description'].toString(),
      expenseAmount: json['expense_amount'] == null
          ? ""
          : json['expense_amount'].toString(),
      expenseDate:
          json['expense_date'] == null ? "" : json['expense_date'].toString(),
      employeeId:
          json['employee_id'] == null ? "" : json['employee_id'].toString(),
      employeeName:
          json['employee_name'] == null ? "" : json['employee_name'].toString(),
      status: json['status'] == null ? "" : json['status'].toString(),
      createdAt:
          json['created_at'] == null ? "" : json['created_at'].toString(),
      updatedAt:
          json['updated_at'] == null ? "" : json['updated_at'].toString(),
    );
  }
}
