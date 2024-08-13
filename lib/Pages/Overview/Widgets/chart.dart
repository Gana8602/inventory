import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/api_services/chart_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatelessWidget {
  Chart({super.key});
  final ChartController chartController = Get.put(ChartController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (chartController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        final DateTime now = DateTime.now();
        final DateTime lastWeek = now.subtract(const Duration(days: 7));
        final List<SalesData> lastWeekData = chartController.data
            .where((sales) => sales.date.isAfter(lastWeek))
            .toList();
        return Center(
          child: SfCartesianChart(
              tooltipBehavior: TooltipBehavior(
                enable: true,
                activationMode: ActivationMode.singleTap,
                builder: (dynamic data, dynamic point, dynamic series,
                    int pointIndex, int seriesIndex) {
                  final SalesData sales = data;
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      '${sales.name}\n${chartController.dateFormat.format(sales.date)}\nQty: ${sales.qty}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
              primaryXAxis: DateTimeAxis(
                title: const AxisTitle(
                    text: 'Date Wise',
                    textStyle:
                        TextStyle(color: Colors.lightBlue, fontSize: 20)),
                intervalType: DateTimeIntervalType.days,
                interval: 1,
                labelRotation: -47,
                minimum: lastWeek,
                maximum: now,
              ),
              series: <CartesianSeries<SalesData, DateTime>>[
                StackedColumnSeries<SalesData, DateTime>(
                    dataSource: lastWeekData,
                    xValueMapper: (SalesData sales, _) => sales.date,
                    yValueMapper: (SalesData sales, _) => sales.qty,
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),
        );
      }
    });
  }
}
