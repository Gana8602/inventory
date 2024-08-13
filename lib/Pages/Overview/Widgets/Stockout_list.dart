// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/api_services/stockout_revenue_service.dart';

import '../../../Constants/style.dart';
import '../../../Helpers/responsiveness.dart';
import '../../../Widgets/custom_text.dart';

class StockOutList extends StatefulWidget {
  const StockOutList({super.key});

  @override
  State<StockOutList> createState() => _StockOutListState();
}

class _StockOutListState extends State<StockOutList> {
  final StockOutService stockOutList = Get.put(StockOutService());

  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stockOutList.fetchStockOutRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (stockOutList.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (stockOutList.stockOutList.isEmpty) {
        return const Center(
            child: CustomText(
          text: 'No stock out records found.',
          weight: FontWeight.bold,
          size: 30,
        ));
      } else {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: active.withOpacity(.4), width: .5),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 6),
                  color: lightGray.withOpacity(.1),
                  blurRadius: 12)
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 10,
              ),
              CustomText(
                text: "StockOut List",
                color: lightGray,
                weight: FontWeight.bold,
                size: 20,
              ),
              SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: ResponsiveWidget.isLargeScreen(context)
                        ? MediaQuery.of(context).size.width / 16
                        : ResponsiveWidget.isCustomScreen(context)
                            ? MediaQuery.of(context).size.width / 26
                            : ResponsiveWidget.isMediumScreen(context)
                                ? MediaQuery.of(context).size.width / 60
                                : MediaQuery.of(context).size.width / 60,
                    horizontalMargin:
                        ResponsiveWidget.isLargeScreen(context) ? 30 : 10,
                    columns: const [
                      DataColumn(
                          label: Text('ID',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center)),
                      DataColumn(
                          label: Text('Name',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center)),
                      DataColumn(
                          label: Text('Serial No',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center)),
                      DataColumn(
                          label: Text(
                        'Model No',
                        style: TextStyle(fontSize: 20),
                      )),
                      DataColumn(
                          label: Text(
                        'Category',
                        style: TextStyle(fontSize: 20),
                      )),
                      DataColumn(
                          label: Text('In/Out',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center)),
                      DataColumn(
                          label: Text('Quantity',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center)),
                    ],
                    rows: List.generate(
                      stockOutList.stockOutList.length,
                      (index) => DataRow(
                        cells: [
                          DataCell(CustomText(text: (index + 1).toString())),
                          DataCell(CustomText(
                              text: stockOutList.stockOutList[index].name)),
                          DataCell(CustomText(
                              text: stockOutList.stockOutList[index].serialNo)),
                          DataCell(CustomText(
                              text: stockOutList.stockOutList[index].modelNo)),
                          DataCell(CustomText(
                              text: stockOutList.stockOutList[index].category)),
                          DataCell(CustomText(
                              text: stockOutList.stockOutList[index].stock)),
                          DataCell(Center(
                            child: CustomText(
                                text: stockOutList.stockOutList[index].qty),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    });
  }
}
