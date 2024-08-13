// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';
import 'package:get/get.dart';
import 'package:inventory/api_services/api_config.dart';
import 'package:http/http.dart' as http;

class VendorController extends GetxController {
  var vendor = <Vendor>[].obs;
  RxString selectedVendor = ''.obs;
  List<String> vendorList = [];
  RxBool isLoading = true.obs;

  Future<void> fetchVendors() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.fetchVendor}'));

      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['vendors'] != null) {
          // print("vendors   $jsonResponse");
          List<Vendor> vendors = (jsonResponse['vendors'] as List)
              .map((vendorJson) => Vendor.fromJson(vendorJson))
              .toList();
          vendorList = vendors.map((e) => e.vendorName).toList();

          vendor.assignAll(vendors);
          // print('vendorResponse : ${vendor}');
        } else {
          throw Exception('Vendor data is null');
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
  }
}

class Vendor {
  final String id;
  final String vendorName;

  Vendor({required this.id, required this.vendorName});

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(id: json['id'], vendorName: json['vendorName']);
  }
}
