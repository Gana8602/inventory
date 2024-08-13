// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory/api_services/api_config.dart';
import 'package:inventory/model/stockout_revenue_model.dart';

import 'package:http/http.dart' as http;

class StockOutService extends GetxController {
  var stockOutList = <StockOutRecord>[].obs;
  var isLoading = false.obs;

  Future<void> fetchStockOutRecords() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.stockOutRevenue}'));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        List<StockOutRecord> records = (jsonResponse as List)
            .map((recordJson) => StockOutRecord.fromJson(recordJson))
            .toList();

        stockOutList.assignAll(records);
        // print('stockOutList: $stockOutList');
      } else {
        throw Exception('Failed to load stock out records.');
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading(false);
    }
  }
}

class RevenueService extends GetxController {
  var revenue =
      Revenue(today: 0.0, last7Days: 0.0, last30Days: 0.0, last12Months: 0.0)
          .obs;
  var isLoading = true.obs;

  Future<void> fetchAndCalculateRevenue() async {
    try {
      isLoading(true);

      final StockOutService stockOutService = Get.put(StockOutService());
      await stockOutService.fetchStockOutRecords();

      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);
      final last7DaysStart = todayStart.subtract(const Duration(days: 7));
      final last30DaysStart = todayStart.subtract(const Duration(days: 30));
      final last12MonthsStart = DateTime(now.year - 1, now.month, now.day);

      double todayRevenue = 0.0;
      double last7DaysRevenue = 0.0;
      double last30DaysRevenue = 0.0;
      double last12MonthsRevenue = 0.0;

      for (var record in stockOutService.stockOutList) {
        // print('Record date: ${record.date}');
        // print('Today start: $todayStart');
        if (record.date.isAtSameMomentAs(todayStart) ||
            record.date.isAfter(todayStart)) {
          todayRevenue += record.totalPrice;
          // print('Adding to todayRevenue: ${record.totalPrice}');
        }
        if (record.date.isAtSameMomentAs(last7DaysStart) ||
            record.date.isAfter(last7DaysStart)) {
          last7DaysRevenue += record.totalPrice;
        }
        if (record.date.isAtSameMomentAs(last30DaysStart) ||
            record.date.isAfter(last30DaysStart)) {
          last30DaysRevenue += record.totalPrice;
        }
        if (record.date.isAtSameMomentAs(last12MonthsStart) ||
            record.date.isAfter(last12MonthsStart)) {
          last12MonthsRevenue += record.totalPrice;
        }
      }

      revenue.value = Revenue(
        today: todayRevenue,
        last7Days: last7DaysRevenue,
        last30Days: last30DaysRevenue,
        last12Months: last12MonthsRevenue,
      );
    } catch (e) {
      print('Error calculating revenue: $e');
    } finally {
      isLoading(false);
    }
  }
}

class Revenue {
  final double today;
  final double last7Days;
  final double last30Days;
  final double last12Months;

  Revenue({
    required this.today,
    required this.last7Days,
    required this.last30Days,
    required this.last12Months,
  });
}
