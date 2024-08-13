import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/controllers.dart';
import 'package:inventory/Pages/Inventory/widgets/vendor_search.dart';
import 'package:inventory/Widgets/custom_button.dart';
import 'package:inventory/Widgets/custom_text.dart';
import 'package:inventory/Widgets/elevated_button.dart';
import 'package:inventory/api_services/dispatch_service_controller.dart';
import '../../../api_services/products_service_controller.dart';
import '../../helpers/responsiveness.dart';
import 'Widget/dispatchList_products.dart';
import 'Widget/editProduct_popup.dart';

class DispatchPage extends StatelessWidget {
  final ProductsController productsController = Get.put(ProductsController());
  final DispatchController dispatchController = Get.put(DispatchController());
  final GlobalKey<VendorSearchState> vendorSearchKey =
      GlobalKey<VendorSearchState>();

  DispatchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (dispatchController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: ResponsiveWidget.isSmallScreen(context)
                                  ? 56
                                  : 6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              text: menuController.activeItem.value,
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        CustomButton(
                          onTap: () {
                            Get.to(() => DispatchedProductsPage());
                          },
                          text: 'Dispatched List',
                          icon: Icons.arrow_forward,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView(children: [
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
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
                                ..._buildCategoryList(),
                                const SizedBox(
                                  height: 20,
                                ),
                                _buildSelectedProductsList(context),
                                const SizedBox(height: 10),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      left: 10.0, top: 8.0, bottom: 4.0),
                                  child: Text(
                                    'Customer name',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                VendorSearch(
                                  key: vendorSearchKey,
                                  controller:
                                      dispatchController.customerNameController,
                                ),
                                const SizedBox(height: 50),
                                Button(
                                    onPressed: () {
                                      dispatchController.dispatchProducts();
                                    },
                                    text: 'Dispatch'),
                                const SizedBox(height: 50),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ));
          }
        },
      ),
    );
  }

  List<Widget> _buildCategoryList() {
    Map<String, List<Map<String, dynamic>>> categorizedProducts = {};

    for (var product in productsController.dataListProduct) {
      String category = product['category'];
      if (!categorizedProducts.containsKey(category)) {
        categorizedProducts[category] = [];
      }
      categorizedProducts[category]!.add(product);
    }

    List<Widget> categoryList = [];
    categorizedProducts.forEach((category, products) {
      categoryList.add(
        ExpansionTile(
          title: Text(category,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          children: products.map((product) {
            bool isSelected =
                dispatchController.selectedProducts.contains(product);
            return ListTile(
              title: Text(product['name']),
              subtitle: Text('Model No: ${product['model_no']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (bool? value) {
                      if (value == true) {
                        dispatchController.selectedProducts.add(product);
                      } else {
                        dispatchController.selectedProducts.remove(product);
                      }
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      );
    });

    return categoryList;
  }

  Widget _buildSelectedProductsList(BuildContext context) {
    return Obx(
      () {
        if (dispatchController.selectedProducts.isEmpty) {
          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('No products selected',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey)),
              Divider(),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Selected Products:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Column(
              children: dispatchController.selectedProducts.map((product) {
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Model No: ${product['model_no']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showEditPopup(context, product);
                          // Get.to(() => EditProductPage(product: product));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        color: Colors.red,
                        onPressed: () {
                          dispatchController.selectedProducts.remove(product);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}

void _showEditPopup(BuildContext context, Map<String, dynamic> product) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return EditProductPopup(
        product: product,
      );
    },
  );
}
