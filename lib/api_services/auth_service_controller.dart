// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/Constants/toaster.dart';
import 'package:inventory/api_services/api_config.dart';
import 'package:inventory/Routing/routes.dart';

import '../../Constants/controllers.dart';

class AuthController extends GetxController {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isPasswordVisible = false.obs;
  RxString userName = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> loginUser(BuildContext context) async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.auth}'),
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        body: {
          'email_or_username': userController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          final String success = jsonResponse['message'];
          Toaster().showsToast(success, Colors.green, Colors.white);
          userName.value = jsonResponse['user']['username'];

          Get.offAllNamed(rootRoute);
          menuController.changeActiveItemTo(overViewPageDisplayName);
        } else {
          final msg = jsonResponse['message'];
          Toaster().showsToast(msg, Colors.red, Colors.white);
        }
      } else {
        print(response.statusCode);
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error logging in: $e');
      Toaster().showsToast('Failed to login', Colors.red, Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
