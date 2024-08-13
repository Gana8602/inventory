// ignore_for_file: depend_on_referenced_packages, avoid_print
import 'dart:convert';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/api_services/api_config.dart';
import '../model/product_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class ProductsController extends GetxController {
  var apiResponse = <Product>[].obs;
  List<dynamic> dataListProduct = <dynamic>[].obs;
  List<dynamic> filteredDataList = <dynamic>[].obs;
  var error = Rxn<String>();
  RxBool isLoading = false.obs;

  String selectedCategory = 'All';
  String selectedType = 'All';
  String selectedLocation = 'All';
  String searchData = '';
  DateTimeRange? selectedDateRange;

  @override
  void onInit() {
    super.onInit();
    fetchListProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.fetchProducts}'));
      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['products'] != null) {
          List<Product> products = (jsonResponse['products'] as List)
              .map((productJson) => Product.fromJson(productJson))
              .toList();

          apiResponse.assignAll(products);
          print('apiResponse : ${apiResponse}');
        } else {
          throw Exception('Products data is null');
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      error.value = e.toString();
      print('Error fetching dataa: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchListProducts() async {
    try {
      isLoading(true);
      var response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.fetchProducts}'));
      // print('Response status code: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> productList = data['products'];
        dataListProduct.assignAll(productList);
        filteredDataList.assignAll(productList);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error fetching dataaaa: $error');
    } finally {
      isLoading(false);
    }
  }

  void filterData() {
    filteredDataList.clear();

    // Filter based on selected category
    if (selectedCategory.isNotEmpty && selectedCategory != 'All') {
      filteredDataList.addAll(dataListProduct
          .where((product) => product['category'] == selectedCategory));
    } else {
      filteredDataList.addAll(dataListProduct);
    }

    // Filter based on selected type
    if (selectedType.isNotEmpty && selectedType != 'All') {
      filteredDataList
          .retainWhere((product) => product['type'] == selectedType);
    }

    if (selectedLocation.isNotEmpty && selectedLocation != 'All') {
      filteredDataList
          .retainWhere((product) => product['location'] == selectedLocation);
    }

    // Filter based on date range
    if (selectedDateRange != null) {
      final startDate = selectedDateRange!.start;
      final endDate = selectedDateRange!.end;
      filteredDataList.retainWhere((product) {
        final productDate = DateTime.parse(product['date']);
        return productDate
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            productDate.isBefore(endDate.add(const Duration(days: 1)));
      });
    }

    // Filter based on search data
    if (searchData.isNotEmpty) {
      String lowerSearchData = searchData.toLowerCase();
      filteredDataList.retainWhere((product) =>
          product['name'].toString().toLowerCase().contains(lowerSearchData) ||
          product['vendor_name']
              .toString()
              .toLowerCase()
              .contains(lowerSearchData) ||
          product['serial_no']
              .toString()
              .toLowerCase()
              .contains(lowerSearchData) ||
          product['model_no']
              .toString()
              .toLowerCase()
              .contains(lowerSearchData) ||
          product['category']
              .toString()
              .toLowerCase()
              .contains(lowerSearchData));
    }
  }

  Future<void> downloadPDF() async {
    final pdf = pw.Document();
    const int itemsPerPage = 20;
    int serialNumberCounter = 1;

    final filteredDataList = this.filteredDataList;

    // Initialize totals
    int grandTotalQty = 0;
    double grandTotalAmount = 0;
    double grandTotalTotalAmount = 0;

    // Split the data into chunks of 20 items each
    try {
      for (int i = 0; i < filteredDataList.length; i += itemsPerPage) {
        final chunk = filteredDataList.sublist(
          i,
          i + itemsPerPage > filteredDataList.length
              ? filteredDataList.length
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
                  'Products List',
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
                      'Model No',
                      'Serial No',
                      'Vendor Name',
                      'Category',
                      'Date',
                      'Qty',
                      'Amt',
                      'Total Amt',
                    ],
                    ...chunk.map((product) {
                      final serialNumber = serialNumberCounter++;
                      final qty = int.tryParse(product['qty'].toString()) ?? 0;
                      final price =
                          double.tryParse(product['price'].toString()) ?? 0.0;
                      final totalPrice =
                          double.tryParse(product['total_price'].toString()) ??
                              0.0;

                      // Update totals
                      totalQty += qty;
                      totalAmount += price;
                      totalTotalAmount += totalPrice;

                      grandTotalQty += qty;
                      grandTotalAmount += price;
                      grandTotalTotalAmount += totalPrice;

                      return [
                        serialNumber.toString(),
                        product['name'].toString(),
                        product['model_no'].toString(),
                        product['serial_no'].toString(),
                        product['vendor_name'].toString(),
                        product['category'].toString(),
                        product['date'].toString(),
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
                    6: const pw.FixedColumnWidth(70),
                    7: const pw.FixedColumnWidth(30),
                    8: const pw.FixedColumnWidth(60),
                    9: const pw.FixedColumnWidth(60),
                  },
                  cellPadding: const pw.EdgeInsets.all(4),
                ),

                // If it's the last page, add grand totals
                if (i + itemsPerPage >= filteredDataList.length)
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
      final file = File('${directory.path}/products.pdf');
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

  Future<void> downloadExcel() async {
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

      // Header row
      sheetObject.updateCell(headerCells[0], const TextCellValue('S.No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[1], const TextCellValue('Name'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[2], const TextCellValue('Model No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[3], const TextCellValue('Serial No'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[4], const TextCellValue('Vendor Name'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[5], const TextCellValue('Category'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[6], const TextCellValue('Date'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[7], const TextCellValue('Quantity'),
          cellStyle: headerStyle);
      sheetObject.updateCell(headerCells[8], const TextCellValue('Amount'),
          cellStyle: headerStyle);
      sheetObject.updateCell(
          headerCells[9], const TextCellValue('Total Amount'),
          cellStyle: headerStyle);

      int totalQty = 0;
      double totalAmount = 0;
      double totalTotalAmount = 0;

      // Data rows
      for (int i = 0; i < filteredDataList.length; i++) {
        final record = filteredDataList[i];
        final qty = int.tryParse(record['qty'].toString()) ?? 0;
        final amount = double.tryParse(record['price'].toString()) ?? 0.0;
        final totalAmountValue =
            double.tryParse(record['total_price'].toString()) ?? 0.0;

        List<CellValue> row = [
          IntCellValue(i + 1),
          TextCellValue(record['name']),
          TextCellValue(record['model_no']),
          TextCellValue(record['serial_no']),
          TextCellValue(record['vendor_name']),
          TextCellValue(record['category']),
          TextCellValue(record['date']),
          IntCellValue(qty),
          DoubleCellValue(amount),
          DoubleCellValue(totalAmountValue),
        ];
        sheetObject.appendRow(row);

        // Update totals
        totalQty += qty;
        totalAmount += amount;
        totalTotalAmount += totalAmountValue;
      }

      // Totals row
      List<CellValue> totalsRow = [
        const TextCellValue(''),
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

      // Save the file
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/products.xlsx');
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
