// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:inventory/api_services/api_config.dart';
import 'dart:convert';
import 'dart:io';
import 'package:excel/excel.dart';
import 'package:inventory/model/stockout_revenue_model.dart';
import '../Constants/toaster.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class DispatchController extends GetxController {
  final TextEditingController customerNameController = TextEditingController();
  var selectedProducts = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final RxList<Map<String, dynamic>> dispatchedProducts =
      <Map<String, dynamic>>[].obs;

  final RxList<StockOutRecord> filteredStockOutList = <StockOutRecord>[].obs;
  final RxList<Map<String, dynamic>> filteredDispatchedProducts =
      <Map<String, dynamic>>[].obs;

  Future<void> dispatchProducts() async {
    try {
      isLoading.value = true;

      String currentDate = DateTime.now().toIso8601String().split('T').first;

      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.dispatchItems}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'customerName': customerNameController.text,
          'date': currentDate,
          'products': selectedProducts.map((product) {
            int quantity = int.tryParse(product['qty'].toString()) ?? 0;
            double price = double.tryParse(product['price'].toString()) ?? 0.0;
            double totalPrice = quantity * price;
            return {
              'product_name': product['name'],
              'serial_no': product['serial_no'],
              'model_no': product['model_no'],
              'category': product['category'],
              'quantity': quantity,
              'price': price,
              'total_price': totalPrice.toString(),
            };
          }).toList(),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          final String success = result['message'];
          Toaster().showsToast(success, Colors.green, Colors.white);
          // Get.snackbar('Success', result['message'],
          //     snackPosition: SnackPosition.BOTTOM);
          await addCustomer();
          selectedProducts.clear();
          customerNameController.clear();
        } else {
          final String error = result['message'];
          Toaster().showsToast(error, Colors.red, Colors.white);
          // Get.snackbar('Error', result['message'],
          //     snackPosition: SnackPosition.BOTTOM);
          isLoading.value = false;
        }
      } else {
        Toaster().showsToast(
            'Failed to dispatch products', Colors.red, Colors.white);
        print("Failed to save data. Status code: ${response.statusCode}");
        // Get.snackbar('Error', 'Failed to dispatch products',
        //     snackPosition: SnackPosition.BOTTOM);
        isLoading.value = false;
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCustomer() async {
    try {
      isLoading.value = true;
      var response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.addVendor}'),
        headers: {
          "content-type": "application/x-www-form-urlencoded",
        },
        body: {
          "vendorName": customerNameController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Vendor added: $data");
        isLoading.value = false;
      } else {
        print("Failed to add vendor. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print('Error adding vendor: $e');
      isLoading.value = false;
    }
  }

  Future<void> fetchDispatchedProducts() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.fetchDispatch}'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['status'] == 'success') {
          dispatchedProducts.value =
              List<Map<String, dynamic>>.from(result['data']);
        } else {
          Toaster().showsToast(result['message'], Colors.red, Colors.white);
        }
      } else {
        Toaster().showsToast('Error: Failed to fetch dispatched products',
            Colors.red, Colors.white);
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> stockdownloadPDF() async {
    final pdf = pw.Document();
    const int itemsPerPage = 20;
    int serialNumberCounter = 1;

    // Initialize totals
    int grandTotalQty = 0;
    double grandTotalAmount = 0;
    double grandTotalTotalAmount = 0;

    // Split the data into chunks of 20 items each
    try {
      for (int i = 0; i < filteredStockOutList.length; i += itemsPerPage) {
        final chunk = filteredStockOutList.sublist(
          i,
          i + itemsPerPage > filteredStockOutList.length
              ? filteredStockOutList.length
              : i + itemsPerPage,
        );

        // Accumulate totals for this chunk
        int totalQty = 0;
        double totalAmount = 0;
        double totalTotalAmount = 0;

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(children: [
                pw.Text(
                  'StockOut List',
                  textAlign: pw.TextAlign.start,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  context: context,
                  cellAlignment: pw.Alignment.center,
                  headerStyle: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  data: <List<String>>[
                    <String>[
                      'No',
                      'Name',
                      'Serial No',
                      'Model No',
                      'Category',
                      'Date',
                      'Qty',
                      'Amt',
                      'Total Amt',
                    ],
                    ...chunk.map((record) {
                      final serialNumber = serialNumberCounter++;
                      final qty = int.tryParse(record.qty) ?? 0;
                      final price =
                          double.tryParse(record.price.toString()) ?? 0.0;
                      final totalPrice =
                          double.tryParse(record.totalPrice.toString()) ?? 0.0;
                      final formattedDate =
                          DateFormat('yyyy-MM-dd').format(record.date);

                      // Update totals
                      totalQty += qty;
                      totalAmount += price;
                      totalTotalAmount += totalPrice;

                      grandTotalQty += qty;
                      grandTotalAmount += price;
                      grandTotalTotalAmount += totalPrice;

                      return [
                        serialNumber.toString(),
                        record.name,
                        record.serialNo,
                        record.modelNo,
                        record.category,
                        formattedDate,
                        qty.toString(),
                        price.toString(),
                        totalPrice.toString(),
                      ];
                    }),
                    // Add totals row for the current page
                    <String>[
                      '',
                      '',
                      '',
                      '',
                      '',
                      'Total',
                      totalQty.toString(),
                      totalAmount.toString(),
                      totalTotalAmount.toString(),
                    ],
                  ],
                  columnWidths: {
                    0: const pw.FixedColumnWidth(25),
                    1: const pw.FixedColumnWidth(60),
                    2: const pw.FixedColumnWidth(60),
                    3: const pw.FixedColumnWidth(60),
                    4: const pw.FixedColumnWidth(70),
                    5: const pw.FixedColumnWidth(75),
                    6: const pw.FixedColumnWidth(30),
                    7: const pw.FixedColumnWidth(60),
                    8: const pw.FixedColumnWidth(60),
                  },
                  cellPadding: const pw.EdgeInsets.all(4),
                ),

                // If it's the last page, add grand totals
                if (i + itemsPerPage >= filteredStockOutList.length)
                  pw.TableHelper.fromTextArray(
                    context: context,
                    cellAlignment: pw.Alignment.center,
                    headerStyle: pw.TextStyle(
                        fontSize: 10, fontWeight: pw.FontWeight.bold),
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    data: <List<String>>[
                      <String>[
                        '',
                        '',
                        '',
                        '',
                        '',
                        'Grand Total',
                        grandTotalQty.toString(),
                        grandTotalAmount.toString(),
                        grandTotalTotalAmount.toString(),
                      ],
                    ],
                    columnWidths: {
                      0: const pw.FixedColumnWidth(25),
                      1: const pw.FixedColumnWidth(60),
                      2: const pw.FixedColumnWidth(60),
                      3: const pw.FixedColumnWidth(60),
                      4: const pw.FixedColumnWidth(70),
                      5: const pw.FixedColumnWidth(75),
                      6: const pw.FixedColumnWidth(30),
                      7: const pw.FixedColumnWidth(60),
                      8: const pw.FixedColumnWidth(60),
                    },
                    cellPadding: const pw.EdgeInsets.all(4),
                  ),
              ]);
            },
          ),
        );
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/stockOut_Products.pdf');
      await file.writeAsBytes(await pdf.save());
      Get.snackbar(
        'Success',
        'PDF downloaded to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error generating PDF: $e');
    }
  }

  Future<void> stockdownloadExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      var headerStyle = CellStyle(
        // Light green background color
        fontFamily: getFontFamily(FontFamily.Calibri),
        fontSize: 14,
        // bold: true,
        underline: Underline.Single,
      );

      // Apply style and set values for header row
      sheetObject.insertRow(0); // Insert header row at index 0
      var headerCells = [
        CellIndex.indexByString('A1'),
        CellIndex.indexByString('B1'),
        CellIndex.indexByString('C1'),
        CellIndex.indexByString('D1'),
        CellIndex.indexByString('E1'),
        CellIndex.indexByString('F1'),
        CellIndex.indexByString('G1'),
        CellIndex.indexByString('H1'),
        CellIndex.indexByString('I1'),
      ];

      sheetObject.updateCell(headerCells[0], const TextCellValue('S.No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[1], const TextCellValue('Name'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[2], const TextCellValue('Model No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[3], const TextCellValue('Serial No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[4], const TextCellValue('Category'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[5], const TextCellValue('Date'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[6], const TextCellValue('Qty'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[7], const TextCellValue('Amount'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[8], const TextCellValue('Total Amt'),
          cellStyle: headerStyle);

      int totalQty = 0;
      double totalAmount = 0;
      double totalTotalAmount = 0;

      // Data rows
      for (int i = 0; i < filteredStockOutList.length; i++) {
        final record = filteredStockOutList[i];
        final qty = int.tryParse(record.qty) ?? 0;
        final price = double.tryParse(record.price.toString()) ?? 0.0;
        final totalPrice = double.tryParse(record.totalPrice.toString()) ?? 0.0;
        final formattedDate = DateFormat('yyyy-MM-dd').format(record.date);

        List<CellValue> row = [
          IntCellValue(i + 1),
          TextCellValue(record.name),
          TextCellValue(record.modelNo),
          TextCellValue(record.serialNo),
          TextCellValue(record.category),
          TextCellValue(formattedDate),
          IntCellValue(qty),
          DoubleCellValue(price),
          DoubleCellValue(totalPrice),
        ];
        sheetObject.appendRow(row);

        totalQty += qty;
        totalAmount += price;
        totalTotalAmount += totalPrice;
      }
      List<CellValue> totalsRow = [
        const TextCellValue(''),
        const TextCellValue(''),
        const TextCellValue(''),
        const TextCellValue(''),
        const TextCellValue(''),
        const TextCellValue('Total'),
        IntCellValue(totalQty),
        DoubleCellValue(totalAmount),
        DoubleCellValue(totalTotalAmount),
      ];
      sheetObject.appendRow(totalsRow);

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/stockOut_Products.xlsx');
      final bytes = excel.save();
      await file.writeAsBytes(bytes!);
      Get.snackbar(
        'Success',
        'Excel downloaded to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate Excel: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error generating Excel: $e');
    }
  }

  Future<void> customerdownloadPDF() async {
    final pdf = pw.Document();
    const int itemsPerPage = 10;
    int serialNumberCounter = 1;

    try {
      for (int i = 0;
          i < filteredDispatchedProducts.length;
          i += itemsPerPage) {
        final chunk = filteredDispatchedProducts.sublist(
          i,
          i + itemsPerPage > filteredDispatchedProducts.length
              ? filteredDispatchedProducts.length
              : i + itemsPerPage,
        );

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(children: [
                pw.Text(
                  'Dispatch List',
                  textAlign: pw.TextAlign.start,
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  context: context,
                  cellAlignment: pw.Alignment.center,
                  headerStyle: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold),
                  cellStyle: const pw.TextStyle(fontSize: 10),
                  data: <List<String>>[
                    <String>[
                      'No',
                      'Customer',
                      'Date',
                      'Product Name',
                      'Serial No',
                      'Model No',
                      'Category',
                      'Qty',
                      'Amt',
                      'Total Amt'
                    ],
                    ...chunk.map((product) {
                      final serialNumber = serialNumberCounter++;
                      final dateString = product['created_at'];
                      final DateTime createdDate =
                          DateTime.parse(dateString); // Parse the date string
                      final formattedDate = DateFormat('yyyy-MM-dd')
                          .format(createdDate)
                          .toString();

                      final productDetails =
                          jsonDecode(product['products']) as List<dynamic>;

                      return [
                        serialNumber.toString(),
                        product['customer_name'],
                        formattedDate,
                        productDetails
                            .map((detail) => detail['product_name'])
                            .join(',\n '),
                        productDetails
                            .map((detail) => detail['serial_no'])
                            .join(',\n '),
                        productDetails
                            .map((detail) => detail['model_no'])
                            .join(',\n '),
                        productDetails
                            .map((detail) => detail['category'])
                            .join(',\n '),
                        productDetails
                            .map((detail) => detail['quantity'])
                            .join(',\n '),
                        productDetails
                            .map((detail) => detail['price'])
                            .join(',\n '),
                        productDetails
                            .map((detail) => detail['total_price'])
                            .join(',\n '),
                      ];
                    }),
                  ],
                  columnWidths: {
                    0: const pw.FixedColumnWidth(25),
                    1: const pw.FixedColumnWidth(65),
                    2: const pw.FixedColumnWidth(70),
                    3: const pw.FixedColumnWidth(70),
                    4: const pw.FixedColumnWidth(60),
                    5: const pw.FixedColumnWidth(60),
                    6: const pw.FixedColumnWidth(70),
                    7: const pw.FixedColumnWidth(30),
                    8: const pw.FixedColumnWidth(60),
                    9: const pw.FixedColumnWidth(60),
                  },
                  cellPadding: const pw.EdgeInsets.all(4),
                ),
              ]);
            },
          ),
        );
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/dispatched_products.pdf');
      await file.writeAsBytes(await pdf.save());
      Get.snackbar(
        'Success',
        'PDF downloaded to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error generating PDF: $e');
    }
  }

  Future<void> customerdownloadExcel() async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      var headerStyle = CellStyle(
        // Light green background color
        fontFamily: getFontFamily(FontFamily.Calibri),
        fontSize: 14,
        // bold: true,
        underline: Underline.Single,
      );

      // Apply style and set values for header row
      sheetObject.insertRow(0); // Insert header row at index 0
      var headerCells = [
        CellIndex.indexByString('A1'),
        CellIndex.indexByString('B1'),
        CellIndex.indexByString('C1'),
        CellIndex.indexByString('D1'),
        CellIndex.indexByString('E1'),
        CellIndex.indexByString('F1'),
        CellIndex.indexByString('G1'),
        CellIndex.indexByString('H1'),
        CellIndex.indexByString('I1'),
        CellIndex.indexByString('J1'),
      ];

      sheetObject.updateCell(headerCells[0], const TextCellValue('S.No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(
          headerCells[1], const TextCellValue('Customer Name'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[2], const TextCellValue('Date'),
          cellStyle: headerStyle);
      sheetObject.updateCell(
          headerCells[3], const TextCellValue('Product Name'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[4], const TextCellValue('Serial No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[5], const TextCellValue('Model No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[6], const TextCellValue('Category'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[7], const TextCellValue('Quantity'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[8], const TextCellValue('Amount'),
          cellStyle: headerStyle);
      sheetObject.updateCell(
          headerCells[9], const TextCellValue('Total Amount'),
          cellStyle: headerStyle);

      // int totalQty = 0;
      // double totalAmount = 0;
      // double totalTotalAmount = 0;

      // Header row
      // List<CellValue> header = [
      //   TextCellValue('S.No'),
      //   TextCellValue('Customer Name'),
      //   TextCellValue('Product Name'),
      //   TextCellValue('Serial No'),
      //   TextCellValue('Model No'),
      //   TextCellValue('Quantity'),
      // ];
      // sheetObject.appendRow(header);

      for (int i = 0; i < filteredDispatchedProducts.length; i++) {
        final product = filteredDispatchedProducts[i];
        final dateTime =
            DateTime.tryParse(product['created_at']) ?? DateTime.now();
        final formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
        final productDetails = jsonDecode(product['products']) as List<dynamic>;

        List<CellValue> row = [
          IntCellValue(i + 1),
          TextCellValue(product['customer_name']),
          TextCellValue(formattedDate.toString()),
          TextCellValue(
              productDetails.map((e) => e['product_name']).join(', ')),
          TextCellValue(productDetails.map((e) => e['serial_no']).join(', ')),
          TextCellValue(productDetails.map((e) => e['model_no']).join(', ')),
          TextCellValue(productDetails.map((e) => e['category']).join(', ')),
          TextCellValue(productDetails.map((e) => e['quantity']).join(', ')),
          TextCellValue(productDetails.map((e) => e['price']).join(', ')),
          TextCellValue(productDetails.map((e) => e['total_price']).join(', ')),
        ];
        sheetObject.appendRow(row);
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/dispatched_products.xlsx');
      final bytes = excel.save();
      await file.writeAsBytes(bytes!);
      Get.snackbar(
        'Success',
        'Excel downloaded to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to generate Excel: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print('Error generating Excel: $e');
    }
  }
}
