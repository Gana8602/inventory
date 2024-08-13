// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class ChartController extends GetxController {
  var data = <SalesData>[].obs;
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    try {
      isLoading.value = true;

      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.chartData}'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        data.value = jsonData.map((item) {
          final date = DateTime.parse(item['date']);
          final qty = item['qty'];
          final name = item['name'] ?? 'Unknown';

          return SalesData(
              date, qty is int ? qty.toDouble() : double.parse(qty), name);
        }).toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching chart data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}

class SalesData {
  SalesData(this.date, this.qty, this.name);

  final DateTime date;
  final double qty;
  final String name;
}
