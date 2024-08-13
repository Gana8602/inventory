class Employee {
  final String name;
  final String username;
  final String email;
  final String phone;
  final String role;
  final String employeeId;

  Employee(
      {required this.name,
      required this.username,
      required this.email,
      required this.phone,
      required this.role,
      required this.employeeId});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        name: json['name'],
        username: json['userName'],
        email: json['email_id'],
        phone: json['phone_number'],
        role: json['role'],
        employeeId: json['employee_id']);
  }
}
