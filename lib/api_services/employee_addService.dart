// ignore_for_file: file_names, depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/Constants/toaster.dart';
import 'package:inventory/api_services/api_config.dart';
import 'package:inventory/api_services/employee_service_controller.dart';

class EmployeeAddController extends GetxController {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> roleList = ['Admin', 'User'];
  RxString selectedRole = "Admin".obs;

  var isLoading = false.obs;

  Future<bool> addEmployee() async {
    isLoading.value = true;
    try {
      var response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addEmployee}'),
          headers: {
            'content-type': 'application/x-www-form-urlencoded'
          },
          body: {
            'name': nameController.text,
            'user_name': userNameController.text,
            'email_id': emailController.text,
            'phone_number': phoneController.text,
            'password': passwordController.text,
            'role': selectedRole.value,
            'employee_id': idController.text
          });

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final msg = jsonResponse['message'];
          Toaster().showsToast(msg, Colors.green, Colors.white);

          EmployeeServiceController().fetchEmployees();
          nameController.clear();
          userNameController.clear();
          emailController.clear();
          phoneController.clear();
          passwordController.clear();
          idController.clear();
          return true;
        } else {
          final msg = jsonResponse['message'];
          Toaster().showsToast(msg, Colors.red, Colors.white);
          return false;
        }
      } else {
        final jsonResponse = json.decode(response.body);
        final msg = jsonResponse['message'];
        Toaster().showsToast(msg, Colors.red, Colors.white);
        print('Failed to add: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return false;
    } finally {
      isLoading(false);
    }
  }
}
