// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Widgets/custom_search_field.dart';
import 'package:inventory/Widgets/custom_text.dart';
import 'package:inventory/Widgets/icon_button.dart';
import 'package:inventory/api_services/dispatch_service_controller.dart';
import 'package:inventory/api_services/stockout_revenue_service.dart';

class Tab2 extends StatefulWidget {
  const Tab2({super.key});

  @override
  State<Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<Tab2> {
  final DispatchController dispatchController = Get.put(DispatchController());
  final StockOutService stockOutList = Get.put(StockOutService());
  final TextEditingController customerSearchController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      dispatchController.fetchDispatchedProducts().then((_) {
        dispatchController.filteredDispatchedProducts
            .assignAll(dispatchController.dispatchedProducts);
      });
    });
    customerSearchController.addListener(_filterDispatchedProducts);
  }

  void _filterDispatchedProducts() {
    final query = customerSearchController.text.toLowerCase();
    print('Filtering with query: $query');
    if (query.isNotEmpty) {
      final filtered = dispatchController.dispatchedProducts.where((product) {
        final customerName = product['customer_name'].toLowerCase();
        print('Checking product: $customerName');
        return customerName.contains(query);
      }).toList();
      dispatchController.filteredDispatchedProducts.assignAll(filtered);
    } else {
      dispatchController.filteredDispatchedProducts
          .assignAll(dispatchController.dispatchedProducts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (dispatchController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (dispatchController.filteredDispatchedProducts.isEmpty) {
          return const Center(
              child: CustomText(
            text: 'No dispatched products found.',
            weight: FontWeight.bold,
            size: 30,
          ));
        } else {
          return Padding(
            padding: const EdgeInsets.all(16.0),
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
                                  controller: customerSearchController)),
                          Row(
                            children: [
                              IconTextButton(
                                onPressed:
                                    dispatchController.customerdownloadPDF,
                                icon: Icons.picture_as_pdf,
                                tooltip: 'Download PDF',
                                label: 'PDF',
                              ),
                              IconTextButton(
                                onPressed:
                                    dispatchController.customerdownloadExcel,
                                icon: Icons.download,
                                tooltip: 'Download Excel',
                                label: 'Excel',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: dispatchController
                            .filteredDispatchedProducts.length,
                        itemBuilder: (context, index) {
                          final product = dispatchController
                              .filteredDispatchedProducts[index];
                          final productDetails =
                              List<Map<String, dynamic>>.from(
                                  jsonDecode(product['products']));
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: active.withOpacity(0.5), width: .5),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 6),
                                      color: lightGray.withOpacity(.1),
                                      blurRadius: 12)
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CustomText(
                                          text: 'Customer: ',
                                          weight: FontWeight.bold,
                                          size: 18,
                                        ),
                                        CustomText(
                                          text: '${product['customer_name']}'
                                              .toUpperCase(),
                                          weight: FontWeight.bold,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                    CustomText(
                                      text: 'Date: ${product['created_at']}',
                                      weight: FontWeight.bold,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Table(
                                      children: productDetails.map((detail) {
                                        return TableRow(children: [
                                          CustomText(
                                            text:
                                                'Product: ${detail['product_name']}',
                                          ),
                                          CustomText(
                                            text:
                                                'Serial No: ${detail['serial_no']}',
                                          ),
                                          CustomText(
                                            text:
                                                'Model No: ${detail['model_no']}',
                                          ),
                                          CustomText(
                                            text:
                                                'Category: ${detail['category']}',
                                          ),
                                          CustomText(
                                            text:
                                                'Quantity: ${detail['quantity']}',
                                          ),
                                          CustomText(
                                            text: 'Price: ${detail['price']}',
                                          ),
                                          CustomText(
                                            text:
                                                'Total Price: ${detail['total_price']}',
                                          ),
                                        ]);
                                      }).toList(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
