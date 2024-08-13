import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Helpers/responsiveness.dart';
import 'package:inventory/Widgets/custom_search_field.dart';
import 'package:inventory/Widgets/custom_text.dart';
import 'package:inventory/Widgets/icon_button.dart';
import 'package:inventory/api_services/dispatch_service_controller.dart';
import 'package:inventory/api_services/stockout_revenue_service.dart';

class Tab1 extends StatefulWidget {
  const Tab1({super.key});

  @override
  State<Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<Tab1> {
  final DispatchController dispatchController = Get.put(DispatchController());
  final StockOutService stockOutList = Get.put(StockOutService());
  final TextEditingController stockSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      stockOutList.fetchStockOutRecords().then((_) {
        dispatchController.filteredStockOutList
            .assignAll(stockOutList.stockOutList);
      });
    });
    stockSearchController.addListener(_filterStockOutList);
  }

  void _filterStockOutList() {
    final query = stockSearchController.text.toLowerCase();
    if (query.isNotEmpty) {
      dispatchController.filteredStockOutList
          .assignAll(stockOutList.stockOutList.where((record) {
        return record.name.toLowerCase().contains(query) ||
            record.serialNo.toLowerCase().contains(query) ||
            record.modelNo.toLowerCase().contains(query) ||
            record.category.toLowerCase().contains(query);
      }).toList());
    } else {
      dispatchController.filteredStockOutList
          .assignAll(stockOutList.stockOutList);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (stockOutList.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (dispatchController.filteredStockOutList.isEmpty) {
        return const Center(
            child: CustomText(
          text: 'No stock out records found.',
          weight: FontWeight.bold,
          size: 30,
        ));
      } else {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 2)
                ]),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            height: 50,
                            width: 600,
                            child: CustomSearchField(
                                controller: stockSearchController)),
                        Row(
                          children: [
                            IconTextButton(
                              onPressed: dispatchController.stockdownloadPDF,
                              icon: Icons.picture_as_pdf,
                              tooltip: 'Download PDF',
                              label: 'PDF',
                            ),
                            IconTextButton(
                              onPressed: dispatchController.stockdownloadExcel,
                              icon: Icons.download,
                              tooltip: 'Download Excel',
                              label: 'Excel',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CustomText(
                      text: "StockOut List",
                      color: lightGray,
                      weight: FontWeight.bold,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columnSpacing: ResponsiveWidget.isLargeScreen(context)
                            ? MediaQuery.of(context).size.width / 22
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
                              label: Text('Date',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Quantity',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Amount',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Total Amount',
                                  style: TextStyle(fontSize: 20),
                                  textAlign: TextAlign.center)),
                        ],
                        rows: List.generate(
                          dispatchController.filteredStockOutList.length,
                          (index) => DataRow(
                            cells: [
                              DataCell(
                                  CustomText(text: (index + 1).toString())),
                              DataCell(CustomText(
                                  text: dispatchController
                                      .filteredStockOutList[index].name)),
                              DataCell(CustomText(
                                  text: dispatchController
                                      .filteredStockOutList[index].serialNo)),
                              DataCell(CustomText(
                                  text: dispatchController
                                      .filteredStockOutList[index].modelNo)),
                              DataCell(CustomText(
                                  text: dispatchController
                                      .filteredStockOutList[index].category)),
                              DataCell(CustomText(
                                  text: dispatchController
                                      .filteredStockOutList[index].stock)),
                              DataCell(CustomText(
                                text: DateFormat('yyyy-MM-dd').format(
                                    dispatchController
                                        .filteredStockOutList[index].date),
                              )),
                              DataCell(Center(
                                child: CustomText(
                                    text: dispatchController
                                        .filteredStockOutList[index].qty),
                              )),
                              DataCell(Center(
                                child: CustomText(
                                    text: dispatchController
                                        .filteredStockOutList[index].price
                                        .toStringAsFixed(2)),
                              )),
                              DataCell(Center(
                                child: CustomText(
                                    text: dispatchController
                                        .filteredStockOutList[index].totalPrice
                                        .toStringAsFixed(2)),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
