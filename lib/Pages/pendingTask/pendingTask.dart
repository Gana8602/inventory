// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Pages/Inventory/inventory.dart';
import 'package:inventory/Widgets/custom_text.dart';
import 'package:inventory/Widgets/elevated_button.dart';
import 'package:inventory/api_services/boxController.dart';

import '../../model/box_model.dart';

class Pendingtask extends StatefulWidget {
  const Pendingtask({super.key});

  @override
  State<Pendingtask> createState() => _PendingtaskState();
}

class _PendingtaskState extends State<Pendingtask> {
  final BoxController _box = Get.put(BoxController());
  @override
  void initState() {
    super.initState();

    _box.fetchBoxes();
  }

  List<DataColumn> column = [
    const DataColumn(label: Text("Id")),
    const DataColumn(label: Text("Date")),
    const DataColumn(label: Text("Bill No")),
    const DataColumn(label: Text("Po No")),
    const DataColumn(label: Text("Supplier Name")),
    const DataColumn(label: Text("Reciever")),
    const DataColumn(label: Text("Remark")),
    const DataColumn(label: Text("Status")),
  ];

  @override
  Widget build(BuildContext context) {
    var box = _box.boxes;
    return Column(
      children: [
        Expanded(
          child: Obx(() {
            if (_box.boxes.isEmpty) {
              return const CircularProgressIndicator();
            }
            return DataTable(
                columns: column,
                rows: List<DataRow>.generate(
                    box.length,
                    (index) => DataRow(cells: [
                          DataCell(Text("${index + 1}")),
                          DataCell(Text(box[index].date)),
                          DataCell(Text(box[index].billNo)),
                          DataCell(Text(box[index].poNo)),
                          DataCell(Text(box[index].supplierName)),
                          DataCell(Text(box[index].recieverName)),
                          DataCell(Text(box[index].remark)),
                          DataCell(box[index].status == '0'
                              ? InkWell(
                                  onTap: () async {
                                    Map<String, dynamic>? data =
                                        await showSheet(box[index].products,
                                            box[index].token);

                                    if (data!.isNotEmpty) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  InventoryPage(
                                                    name: data['name'],
                                                    token: data['token'],
                                                    qty: data['qty'],
                                                  )));
                                    }
                                  },
                                  child: const Icon(
                                    CupertinoIcons.exclamationmark_circle_fill,
                                    color: Colors.red,
                                  ),
                                )
                              : const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )),
                        ])));
          }),
        )
      ],
    );
  }

  Future<Map<String, dynamic>?> showSheet(
      List<Produc> product, String token) async {
    int? isSelected;
    final Map<String, dynamic> data = {};

    return await showDialog<Map<String, dynamic>>(
      // backgroundColor: Colors.white,
      context: context,

      // isScrollControlled: true,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: 300,
                width: 500,
                decoration: const BoxDecoration(
                  // color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.grey.withOpacity(0.5),
                  //     blurRadius: 15,
                  //     offset: Offset(0, 3),
                  //   ),
                  // ],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "Pending Products",
                      ),
                      const Text(
                        "Select Product which you want to add details",
                        style: TextStyle(fontSize: 13),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: product.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: isSelected == index ? Colors.blue : null,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                              ),
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    isSelected = index;
                                  });
                                },
                                selected: isSelected == index,
                                title: Text(product[index].name),
                                trailing: Text(product[index].qty),
                              ),
                            );
                          },
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Button(
                            onPressed: () {
                              if (isSelected == null) {
                                return;
                              } else {
                                data.addAll({
                                  'token': token,
                                  'name': product[isSelected!].name,
                                  'qty': product[isSelected!].qty,
                                });
                                Get.back(
                                    result:
                                        data); // Pass data back and close the sheet
                              }
                            },
                            text: "Edit",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
