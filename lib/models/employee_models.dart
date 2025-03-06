class EmployeeModel {
  String employeeId;
  String name;
  String age;
  String mobile;
  String dob;
  String address;
  String salary;
  String designation;
  String dateOfJoin;
  List<String> target;
  String image;

  EmployeeModel({
    required this.employeeId,
    required this.name,
    required this.age,
    required this.mobile,
    required this.dob,
    required this.address,
    required this.salary,
    required this.designation,
    required this.dateOfJoin,
    required this.target,
    required this.image,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['employee_id'],
      name: json['name'],
      age: json['age'],
      mobile: json['mobile'],
      dob: json['dob'],
      address: json['address'],
      salary: json['salary'],
      designation: json['deignation'],
      dateOfJoin: json['date_of_join'],
      target: List<String>.from(json['target']),
      image: json['image'],
    );
  }
}
