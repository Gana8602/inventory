import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Pages/Products/widgets/mydata.dart';
import 'package:inventory/api_services/products_service_controller.dart';
import 'package:inventory/api_services/trashController.dart';
import 'package:inventory/model/trashModel.dart';
import 'package:http/http.dart' as http;
import '../../Constants/controllers.dart';
import '../../Widgets/custom_text.dart';
import '../../api_services/api_config.dart';
import '../../helpers/responsiveness.dart';

class TrashPage extends StatefulWidget {
  const TrashPage({super.key});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  final TrashController _trash = Get.put(TrashController());
  final ProductsController controller = Get.put(ProductsController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _trash.fetchBin();
  }

  List<DataColumn> col = [
    DataColumn(label: Text("ID", style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Name', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Model No', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Serial No', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Vendor Name', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Category', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Date', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Quantity', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Amount', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Total Amount', style: TextStyle(fontSize: 20))),
    DataColumn(label: Text('Actions', style: TextStyle(fontSize: 20))),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
          child: Padding(
            padding: const EdgeInsets.only(left: 18),
            child: CustomText(
              text: menuController.activeItem.value,
              size: 24,
              weight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(child: Obx(() {
          if (_trash.trash.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }
          return DataTable(
              columns: col,
              columnSpacing: 25,
              rows: List<DataRow>.generate(
                  _trash.trash.length,
                  (index) => DataRow(cells: [
                        DataCell(Text(_trash.trash[index].id)),
                        DataCell(Text(_trash.trash[index].name)),
                        DataCell(Text(_trash.trash[index].modelNo)),
                        DataCell(Text(_trash.trash[index].serialNo)),
                        DataCell(Text(_trash.trash[index].vendorName)),
                        DataCell(Text(_trash.trash[index].category)),
                        DataCell(Text(_trash.trash[index].date)),
                        DataCell(Text(_trash.trash[index].qty)),
                        DataCell(Text(_trash.trash[index].price)),
                        DataCell(Text(_trash.trash[index].totalPrice)),
                        DataCell(InkWell(
                          onTap: () async {
                            bool status = await _undo(_trash.trash[index].id,
                                _trash.trash[index].mainCategory);
                            if (status) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Product Undo Successfully")));
                            }
                          },
                          child: Container(
                            height: 30,
                            width: 60,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.amber.withOpacity(0.5)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Center(
                              child: Text(
                                "Undo",
                              ),
                            ),
                          ),
                        )),
                      ])));
        }))
      ],
    );
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
          _trash.trash.clear();
          _trash.fetchBin();
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
}
