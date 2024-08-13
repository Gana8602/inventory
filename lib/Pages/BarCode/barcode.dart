// ignore_for_file: library_prefixes, avoid_print

import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory/Widgets/icon_button.dart';
import 'package:inventory/api_services/vendor_service.dart';
import 'package:inventory/api_services/products_service_controller.dart';
import 'package:inventory/model/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWidgets;

import '../../Constants/controllers.dart';
import '../../Constants/style.dart';
import '../../Widgets/custom_text.dart';

class BarCodePage extends StatefulWidget {
  const BarCodePage({super.key});

  @override
  State<BarCodePage> createState() => _BarCodePageState();
}

class _BarCodePageState extends State<BarCodePage> {
  final VendorController _vendorController = Get.put(VendorController());
  final ProductsController _productsController = Get.put(ProductsController());

  String selectedCategory = 'All Vendor';
  List<Product> filteredData = [];
  bool isLoading = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productsController.fetchProducts().then((_) => setState(() {
            filteredData = _productsController.apiResponse;
          }));
    });
    _vendorController.fetchVendors();
  }

  Future<void> generatePDF(List<Product> products) async {
    // print('Products received for PDF generation: $products');
    final pdf = pdfWidgets.Document();
    final ByteData fontByteData =
        await rootBundle.load('assets/OpenSans-Regular.ttf');
    final Uint8List fontData = fontByteData.buffer.asUint8List();
    final pdfWidgets.TtfFont font =
        pdfWidgets.TtfFont(fontData.buffer.asByteData());

    int itemsPerPage = 10; // Adjust the number of items per page
    int totalPages = (products.length / itemsPerPage).ceil();

    try {
      for (int pageIndex = 0; pageIndex < totalPages; pageIndex++) {
        int startIndex = pageIndex * itemsPerPage;
        int endIndex = startIndex + itemsPerPage;
        List<Product> pageProducts = products.sublist(
          startIndex,
          endIndex > products.length ? products.length : endIndex,
        );

        pdf.addPage(
          pdfWidgets.Page(
            build: (context) {
              return pdfWidgets.Column(
                crossAxisAlignment: pdfWidgets.CrossAxisAlignment.center,
                children: [
                  pdfWidgets.Text(
                    'Bar Code Details',
                    textAlign: pdfWidgets.TextAlign.start,
                    style: pdfWidgets.TextStyle(
                      font: font,
                      fontSize: 24,
                      fontWeight: pdfWidgets.FontWeight.bold,
                    ),
                  ),
                  pdfWidgets.SizedBox(height: 26),
                  pdfWidgets.Column(
                    crossAxisAlignment: pdfWidgets.CrossAxisAlignment.start,
                    children: pageProducts.map((product) {
                      return pdfWidgets.Container(
                        margin:
                            const pdfWidgets.EdgeInsets.symmetric(vertical: 8),
                        child: pdfWidgets.Row(
                          crossAxisAlignment:
                              pdfWidgets.CrossAxisAlignment.start,
                          children: [
                            pdfWidgets.Column(
                                crossAxisAlignment:
                                    pdfWidgets.CrossAxisAlignment.start,
                                children: [
                                  pdfWidgets.Text(
                                    'Product Name: ${product.name}',
                                    style: pdfWidgets.TextStyle(font: font),
                                  ),
                                  pdfWidgets.SizedBox(height: 5),
                                  pdfWidgets.Text(
                                    'Model No: ${product.modelNo}',
                                    style: pdfWidgets.TextStyle(font: font),
                                  ),
                                ]),
                            pdfWidgets.Spacer(),
                            pdfWidgets.BarcodeWidget(
                              barcode: pdfWidgets.Barcode.code128(),
                              data: product.barCode.toString(),
                              width: 140,
                              height: 35,
                              color: const PdfColor(0, 0, 0),
                            ),
                            pdfWidgets.SizedBox(height: 8),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              );
            },
          ),
        );
      }

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/barcode List.pdf');
      await file.writeAsBytes(await pdf.save());
      Get.snackbar(
        'Success',
        'PDF downloaded to ${file.path}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // print('PDF generation completed.');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: active.withOpacity(.4), width: .5),
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    offset: const Offset(0, 2),
                    blurRadius: 2)
              ]),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Obx(() => Container(
                          margin: const EdgeInsets.only(top: 6),
                          child: CustomText(
                            text: menuController.activeItem.value,
                            size: 24,
                            weight: FontWeight.bold,
                          ),
                        )),
                    const Spacer(),
                    buildFilterDropdown(
                      'vendor',
                      _vendorController.vendorList,
                      selectedCategory,
                      (value) {
                        setState(() {
                          selectedCategory = value!;
                          filteredData = _productsController.apiResponse
                              .where((product) => product.vendorName
                                  .toLowerCase()
                                  .contains(selectedCategory.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconTextButton(
                      onPressed: () async {
                        if (selectedCategory == 'All Vendor') {
                          await generatePDF(_productsController.apiResponse);
                        } else if (filteredData.isNotEmpty) {
                          await generatePDF(filteredData);
                        } else {
                          Get.snackbar(
                            'No Data',
                            'No products found for the selected vendor.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      icon: Icons.download,
                      label: 'PDF',
                      tooltip: 'Download PDF',
                    ),
                    const SizedBox(
                      width: 10,
                    )
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _productsController.apiResponse
                      .length, // Use DataPro.length instead of filteredData.length
                  itemBuilder: (context, index) {
                    if (selectedCategory == 'All Vendor' ||
                        _productsController.apiResponse[index].vendorName
                            .toLowerCase()
                            .contains(selectedCategory.toLowerCase())) {
                      return ListTile(
                        title: Text(
                            'Name: ${_productsController.apiResponse[index].name}'),
                        subtitle: Text(
                          'Model No: ${_productsController.apiResponse[index].modelNo}',
                        ),
                        trailing: BarcodeWidget(
                          barcode: Barcode.code128(),
                          data: _productsController.apiResponse[index].barCode,
                          width: 200,
                          height: 80,
                          color: Colors.black,
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for non-matching items
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFilterDropdown(String label, List<String> items, String value,
      Function(String?) onChanged) {
    return Container(
      width: 175,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey), // Add border decoration
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DropdownButton<String>(
          value: value,
          items: buildDropdownMenuItems(['All Vendor'] + items),
          onChanged: onChanged,
          hint: Text(label),
          underline: Container(), // Remove the default underline
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List<String> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ))
        .toList();
  }
}
