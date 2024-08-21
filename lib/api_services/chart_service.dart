// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class ChartController extends GetxController {
  var data = <SalesData>[].obs;
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Updated format
  var isLoading = false.obs;

  Future<void> fetchChartData() async {
    try {
      print("start");

      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chartData}'));

      print("mid");
      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Convert JSON data to a list of SalesData objects
        data.value = jsonData.map((item) {
          // Parse the date using the correct format
          final date = dateFormat.parse(item['date']);
          final qty = item['qty'];
          final name = item['main_category'] ?? 'Unknown';

          // Ensure quantity is parsed as double
          return SalesData(
              date, qty is int ? qty.toDouble() : double.parse(qty), name);
        }).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching chart data: $e');
    }
  }
}

class SalesData {
  SalesData(this.date, this.qty, this.category);

  final DateTime date;
  final double qty;
  final String category;
}
