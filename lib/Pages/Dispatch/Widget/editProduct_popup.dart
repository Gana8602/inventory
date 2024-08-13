// ignore_for_file: file_names, depend_on_referenced_packages, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:inventory/api_services/products_service_controller.dart';
import 'package:http/http.dart' as http;

import '../../../Widgets/dropdown.dart';
import '../../../api_services/api_config.dart';
import '../../../api_services/stockout_revenue_service.dart';

class EditProductPopup extends StatelessWidget {
  final Map<String, dynamic> product;

  const EditProductPopup({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: product['name']);
    final TextEditingController serialNoController =
        TextEditingController(text: product['serial_no']);
    final TextEditingController modelNoController =
        TextEditingController(text: product['model_no']);
    final TextEditingController quantityController =
        TextEditingController(text: product['qty'].toString());
    final TextEditingController categoryController =
        TextEditingController(text: product['category']);
    final TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    String selectedStock = "Stock Out";
    List<String> stockList = ["Stock Out"];

    return AlertDialog(
      title: Text(nameController.text.toUpperCase()),
      content: SingleChildScrollView(
        child: SizedBox(
          height: 400,
          width: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(serialNoController, 'Serial No', true),
              _buildTextField(modelNoController, 'Model No', true),
              _buildTextField(quantityController, 'Quantity', false),
              CustomDropDown(
                items: stockList,
                val: selectedStock,
                onChanged: (value) {
                  selectedStock = value!;
                },
                color: Colors.transparent,
                borderColor: Colors.black,
                label: 'Stock In/Out',
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            'Update',
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () async {
            int newQty = int.tryParse(quantityController.text) ?? 0;
            product['qty'] = newQty;
            final updatedProduct = {
              'name': nameController.text,
              'serial_no': serialNoController.text,
              'model_no': modelNoController.text,
              'qty': quantityController.text,
              'Stock_in_out': selectedStock,
              'category': categoryController.text,
              'price': priceController.text,
            };
            // print('updatedProduct : $updatedProduct');

            await _updateProduct(updatedProduct);

            ProductsController().fetchListProducts();
            RevenueService().fetchAndCalculateRevenue();
            StockOutService().fetchStockOutRecords();

            Navigator.of(context).pop(); // Close the dialog
          },
        ),
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String lable, bool readonly) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: lable,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.lightBlue),
          ),
        ),
        readOnly: readonly,
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
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print('Error updating product: $e');
    }
  }
}
