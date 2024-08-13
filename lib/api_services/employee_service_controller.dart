// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory/api_services/api_config.dart';
import 'package:inventory/model/employee_model.dart';
import 'package:http/http.dart' as http;

class EmployeeServiceController extends GetxController {
  var employeeList = <Employee>[].obs;
  var isLoading = false.obs;

  Future<void> fetchEmployees() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.employeeList}'));

      // print('Response status code: ${response.statusCode}');
      // print('Response body employee: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['users'] != null) {
          List<Employee> employees = (jsonResponse['users'] as List)
              .map((employeeJson) => Employee.fromJson(employeeJson))
              .toList();

          employeeList.assignAll(employees);
          // print('userResponse : $employeeList');
        } else {
          throw Exception('employee data is null');
        }
      } else {
        throw Exception('Failed to Load');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
  }
}
