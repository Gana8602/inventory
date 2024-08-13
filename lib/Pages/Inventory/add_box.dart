// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inventory/Widgets/custom_text_field.dart';
import 'package:inventory/Widgets/elevated_button.dart';
import 'package:inventory/api_services/api_config.dart';

import '../../Constants/controllers.dart';
import '../../Helpers/responsiveness.dart';
import '../../Widgets/custom_text.dart';

class BoxAddPage extends StatefulWidget {
  const BoxAddPage({super.key});

  @override
  State<BoxAddPage> createState() => _BoxAddPageState();
}

class _BoxAddPageState extends State<BoxAddPage> {
  final TextEditingController _poNo = TextEditingController();
  final TextEditingController _billNo = TextEditingController();
  final TextEditingController _supplierName = TextEditingController();
  final TextEditingController _remark = TextEditingController();
  final TextEditingController _reciever = TextEditingController();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final List<Map<String, dynamic>> _list = [];
  final int count = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Obx(() => Row(
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
              ],
            )),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(children: [
                      Flexible(
                        child: CustomTextField(
                          textEditingController: _poNo,
                          fieldTitle: "Po No",
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: CustomTextField(
                          textEditingController: _date,
                          fieldTitle: 'Date',
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            size: 20,
                          ),
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );

                            if (pickedDate != null &&
                                pickedDate != DateTime.now()) {
                              // Format the selected date as needed
                              String formattedDate =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                              // Update the text field with the selected date
                              _date.text = formattedDate;
                            }
                          },
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        Flexible(
                          child: CustomTextField(
                            textEditingController: _billNo,
                            fieldTitle: "Bill No",
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: CustomTextField(
                            textEditingController: _supplierName,
                            fieldTitle: "Supplier Name",
                          ),
                        )
                      ],
                    ),
                    // CustomTextField(
                    //   textEditingController: _serial,
                    //   fieldTitle: "Product Names",
                    // ),
                    // CustomTextField(
                    //   textEditingController: _serial,
                    //   fieldTitle: "qty",
                    // ),
                    CustomTextField(
                      textEditingController: _remark,
                      fieldTitle: "Remark",
                    ),
                    CustomTextField(
                      textEditingController: _reciever,
                      fieldTitle: "Reciever Name",
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomText(text: "Producs Details"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: CustomTextField(
                                  textEditingController: _productName,
                                  fieldTitle: "Product Name",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: CustomTextField(
                                  textEditingController: _qty,
                                  fieldTitle: "qty",
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40.0),
                                child: Button(
                                    onPressed: () {
                                      if (_qty.text.isNotEmpty &&
                                          _productName.text.isNotEmpty) {
                                        // int qty = int.parse(_qty.text);
                                        setState(() {
                                          _list.add({
                                            'name': _productName.text,
                                            'qty': _qty.text,
                                          });
                                          _productName.clear();
                                          _qty.clear();
                                        });
                                      }
                                    },
                                    text: "Add"),
                              )
                            ],
                          ),
                          _list.isEmpty
                              ? const SizedBox()
                              : Expanded(
                                  child: SingleChildScrollView(
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text("id")),
                                        DataColumn(label: Text("name")),
                                        DataColumn(label: Text("qty")),
                                        DataColumn(label: Text("action"))
                                      ],
                                      rows: List<DataRow>.generate(
                                          _list.length,
                                          (index) => DataRow(cells: [
                                                DataCell(Text("${index + 1}")),
                                                DataCell(Text(
                                                    "${_list[index]['name']}")),
                                                DataCell(Text(
                                                    "${_list[index]['qty']}")),
                                                const DataCell(Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                              ])),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                    Button(
                        onPressed: () async {
                          if (_billNo.text.isNotEmpty &&
                              _date.text.isNotEmpty &&
                              _poNo.text.isNotEmpty &&
                              _reciever.text.isNotEmpty &&
                              _remark.text.isNotEmpty &&
                              _supplierName.text.isNotEmpty &&
                              _list.isNotEmpty) {
                            String status = await save();
                            if (status == 'ok') {
                              setState(() {
                                _billNo.clear();
                                _date.clear();
                                _poNo.clear();
                                _reciever.clear();
                                _remark.clear();
                                _supplierName.clear();
                                _list.clear();
                              });
                            }
                          } else {}
                        },
                        text: "Submit"),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<String> save() async {
    try {
      String list = jsonEncode(_list);

      // Prepare the request body
      var requestBody = {
        "billNo": _billNo.text,
        "poNo": _poNo.text,
        "date": _date.text,
        "supplierName": _supplierName.text,
        "remark": _remark.text,
        "recieverName": _reciever.text,
        "products": list, // Pass the JSON string here
      };

      // Send the POST request
      var response = await http.post(
        Uri.parse("${ApiConfig.baseUrl}${ApiConfig.saveBox}"),
        body: jsonEncode(requestBody),
      );

      // Decode the response
      var data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("Success", "${data['message']}");
        return "ok";
      } else {
        Get.snackbar("Success", "${data['message']}");
        return "bad";
      }
    } catch (e) {
      return "bad";
    }
    // Convert the list of products to a JSON string
  }
}
