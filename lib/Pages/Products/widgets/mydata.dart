// ignore_for_file: depend_on_referenced_packages, unused_local_variable, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Widgets/elevated_button.dart';
import 'package:inventory/api_services/api_config.dart';

import '../../../Widgets/custom_text.dart';
import '../../../api_services/products_service_controller.dart';
import 'package:http/http.dart' as http;

import '../../../api_services/stockout_revenue_service.dart';

class MyData extends DataTableSource {
  final ProductsController controller;
  final BuildContext context;

  MyData({required this.controller, required this.context});

  @override
  DataRow getRow(int index) {
    final product = controller.filteredDataList[index];
    return DataRow(cells: [
      _buildDataCell((index + 1).toString()),
      _buildDataCell(product['name']),
      _buildDataCell(product['model_no']),
      _buildDataCell(product['serial_no']),
      _buildDataCell(product['vendor_name']),
      _buildDataCell(product['category']),
      _buildDataCell(product['date']),
      _buildDataCell(product['qty']),
      _buildDataCell(product['price']),
      _buildDataCell(product['total_price']),
      _buildActionsCell(context, controller, product),
    ]);
  }

  DataCell _buildDataCell(String value) {
    return DataCell(CustomText(text: value));
  }

  DataCell _buildActionsCell(BuildContext context,
      ProductsController controller, Map<String, dynamic> product) {
    String? msg;
    return DataCell(Row(
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          color: Colors.indigo,
          onPressed: () {
            _showEditPopup(context, controller, product);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.redAccent,
          onPressed: () async {
            bool status = await _deleteProduct(
                product['id'].toString(), product["main_category"]);

            if (status) {
              msg = "Product removed successfully";
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(msg!),
                  Button(
                      onPressed: () async {
                        msg = "Product Undo Successfully";
                        bool status = await _undo(
                            product['id'], product['main_category']);
                        if (status) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Product Undo Successfully")));
                        }
                      },
                      text: "Undo")
                ],
              )));
            }
          },
        ),
      ],
    ));
  }

  void _showEditPopup(BuildContext context, ProductsController controller,
      Map<String, dynamic> product) {
    final TextEditingController nameController =
        TextEditingController(text: product['name']);
    final TextEditingController serialController =
        TextEditingController(text: product['serial_no']);
    final TextEditingController modelNoController =
        TextEditingController(text: product['model_no']);
    final TextEditingController quantityController =
        TextEditingController(text: product['qty'].toString());
    final TextEditingController categoryController =
        TextEditingController(text: product['category']);
    final TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    final TextEditingController stockInOutController =
        TextEditingController(text: product['Stock_in_out']);
    // String selectedStock = "Stock In";
    // List<String> stockList = ["Stock In", "Stock Out"];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(nameController.text.toUpperCase()),
          content: SingleChildScrollView(
            child: SizedBox(
              height: 400,
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(nameController, 'Name'),
                  _buildTextField(modelNoController, 'Model No'),
                  _buildTextField(
                    quantityController,
                    'Quantity',
                  ),
                  _buildTextField(stockInOutController, 'Stock In/Out')
                  // CustomDropDown(
                  //   items: stockList,
                  //   val: selectedStock,
                  //   onChanged: (value) {
                  //     selectedStock = value!;
                  //   },
                  //   color: Colors.transparent,
                  //   borderColor: Colors.black,
                  //   label: 'Stock In/Out',
                  // )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Update', style: TextStyle(fontSize: 18)),
              onPressed: () async {
                final updatedProduct = {
                  'name': nameController.text,
                  'serial_no': serialController.text,
                  'model_no': modelNoController.text,
                  'category': categoryController.text,
                  'qty': quantityController.text,
                  'Stock_in_out': stockInOutController.text,
                  'price': priceController.text,
                };
                // print('updatedProduct : $updatedProduct');

                await _updateProduct(updatedProduct);

                controller.fetchListProducts();
                RevenueService().fetchAndCalculateRevenue();
                StockOutService().fetchStockOutRecords();

                Get.back(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Cancel', style: TextStyle(fontSize: 18)),
              onPressed: () {
                Get.back(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.lightBlue),
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct(Map<String, dynamic> product) async {
    const String url = '${ApiConfig.baseUrl}${ApiConfig.updateProduct}';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'content-type': 'application/x-www-form-urlencoded'},
        body: product,
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<bool> _deleteProduct(String id, String category) async {
    print(id);
    print(category);
    try {
      var response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}${ApiConfig.deleteProduct}"),
        // headers: {
        //   "Content-Type": "application/json",
        // },
        body: {
          'id': id,
          'category': category,
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          print(data);
          controller.fetchListProducts();
          return true;
        } else {
          print('Empty response from the server');
          return false;
        }
      } else {
        print('Failed to delete product. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  Future<bool> _undo(String id, String category) async {
    print(id);
    print(category);
    try {
      var response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}${ApiConfig.undo}"),
        // headers: {
        //   "Content-Type": "application/json",
        // },
        body: {
          'id': id,
          'category': category,
        },
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          print(data);
          controller.fetchListProducts();
          return true;
        } else {
          print('Empty response from the server');
          return false;
        }
      } else {
        print('Failed to delete product. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error occurred: $e');
      return false;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => controller.filteredDataList.length;

  @override
  int get selectedRowCount => 0;
}
