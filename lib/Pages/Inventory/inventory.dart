// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory/Widgets/custom_text_field.dart';
import 'package:inventory/Widgets/dropdown.dart';
import 'package:inventory/Widgets/elevated_button.dart';
import 'package:inventory/api_services/addinventory_service.dart';
import 'package:inventory/api_services/box_service.dart';
import 'package:inventory/api_services/update_box_service.dart';

import '../../Constants/controllers.dart';
import '../../Constants/toaster.dart';
import '../../Widgets/custom_text.dart';
import '../../api_services/boxController.dart';
import '../../api_services/products_service_controller.dart';
import '../../helpers/responsiveness.dart';
import 'widgets/vendor_search.dart';

class InventoryPage extends StatefulWidget {
  final String token;
  final String name;
  final String qty;
  final String vendor;
  const InventoryPage(
      {super.key,
      required this.name,
      required this.qty,
      required this.token,
      required this.vendor});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final ProductsController productsController = Get.put(ProductsController());
  final InventoryController inventoryController =
      Get.put(InventoryController());
  final GlobalKey<VendorSearchState> vendorSearchKey =
      GlobalKey<VendorSearchState>();
  final BoxController _box = Get.put(BoxController());
  @override
  void initState() {
    super.initState();
    inventoryController.nameController.text = widget.name;
    inventoryController.qtyController.text = widget.qty;
    inventoryController.vendorNameController.text = widget.vendor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => inventoryController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.lightBlue,
              ))
            : SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                              top: ResponsiveWidget.isSmallScreen(context)
                                  ? 56
                                  : 6),
                          child: const Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomText(
                              text: "Inventory",
                              size: 24,
                              weight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Item Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  fieldTitle: 'Product Name',
                                  textEditingController:
                                      inventoryController.nameController,
                                  // hintText: 'Enter Product Name',
                                )),
                                const SizedBox(width: 50),
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.serialController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Enter Serial Number',
                                )),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.modelController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Enter Model Number',
                                )),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: CustomTextField(
                                        textEditingController:
                                            inventoryController.qtyController,
                                        fieldTitle: 'Enter Quantity',
                                        keyboard: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        textInput: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}$'),
                                          ),
                                        ],
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                          child: CustomTextField(
                                        textEditingController:
                                            inventoryController.priceController,
                                        fieldTitle: 'Enter Price',
                                        keyboard: const TextInputType
                                            .numberWithOptions(decimal: true),
                                        textInput: [
                                          FilteringTextInputFormatter.allow(
                                            RegExp(r'^\d+\.?\d{0,2}$'),
                                          ),
                                        ],
                                      )),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Flexible(
                                  child: CustomDropDown(
                                    fieldTitle: 'Main Category',
                                    items:
                                        inventoryController.mainCategoriesList,
                                    val: inventoryController
                                        .selectedMainCategory.value,
                                    onChanged: (newValue) {
                                      setState(() {
                                        inventoryController.selectedMainCategory
                                            .value = newValue!;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 50),
                                Flexible(
                                  child: CustomDropDown(
                                      fieldTitle: 'Category',
                                      items: inventoryController.categoriesList,
                                      val: inventoryController
                                          .selectedCategory.value,
                                      onChanged: (newValue) {
                                        setState(() {
                                          inventoryController.selectedCategory
                                              .value = newValue!;
                                        });
                                      }),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                    child: CustomDropDown(
                                        items: inventoryController.typeList,
                                        val: inventoryController
                                            .selectedType.value,
                                        onChanged: (newValue) {
                                          setState(() {
                                            inventoryController
                                                .selectedType.value = newValue!;
                                          });
                                        },
                                        fieldTitle: 'Type')),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomDropDown(
                                        items: inventoryController.locationList,
                                        val: inventoryController
                                            .selectedLocation.value,
                                        onChanged: (newValue) {
                                          setState(() {
                                            inventoryController.selectedLocation
                                                .value = newValue!;
                                          });
                                        },
                                        fieldTitle: 'Location')),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                    child: CustomTextField(
                                        textEditingController:
                                            inventoryController
                                                .itemRemarksController,
                                        fieldTitle: 'Remarks'))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Project Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  fieldTitle: 'Project Name',
                                  textEditingController:
                                      inventoryController.pNameController,
                                  // hintText: 'Enter Product Name',
                                )),
                                const SizedBox(width: 50),
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.pNoController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Project Number',
                                )),
                              ],
                            ),
                            const SizedBox(height: 10.0),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.pPoController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Purchase Order',
                                )),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.pInvoiceController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Invoice Number',
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
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
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Vendor Details',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 24),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, top: 8.0, bottom: 4.0),
                                        child: Text(
                                          'Vendor name',
                                          style: TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      VendorSearch(
                                          key: vendorSearchKey,
                                          controller: inventoryController
                                              .vendorNameController),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                  child: CustomTextField(
                                    textEditingController:
                                        inventoryController.dateController,
                                    fieldTitle: 'Date',
                                    suffixIcon: const Icon(
                                      Icons.calendar_today,
                                      size: 20,
                                    ),
                                    onTap: () async {
                                      DateTime? pickedDate =
                                          await showDatePicker(
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
                                        inventoryController.dateController
                                            .text = formattedDate;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.placeController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Location',
                                )),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                    child: CustomDropDown(
                                        items: inventoryController.mosList,
                                        val: inventoryController
                                            .selectedMos.value,
                                        onChanged: (newValue) {
                                          setState(() {
                                            inventoryController
                                                .selectedMos.value = newValue!;
                                          });
                                        },
                                        fieldTitle: 'Mode of Shipment')),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                    child: CustomTextField(
                                  textEditingController:
                                      inventoryController.receiversController,
                                  // hintText: 'Model Number',
                                  fieldTitle: 'Receiver Name',
                                )),
                                const SizedBox(
                                  width: 50,
                                ),
                                Flexible(
                                  child: CustomTextField(
                                      textEditingController: inventoryController
                                          .vendorRemarksController,
                                      fieldTitle: 'Remarks'),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Button(
                                onPressed: () async {
                                  try {
                                    setState(() {
                                      vendorSearchKey.currentState
                                          ?.setSelectedVendor();
                                    });
                                    inventoryController.isLoading.value = true;
                                    if (inventoryController.nameController.text.isNotEmpty &&
                                        inventoryController
                                            .modelController.text.isNotEmpty &&
                                        inventoryController
                                            .serialController.text.isNotEmpty &&
                                        inventoryController
                                            .qtyController.text.isNotEmpty &&
                                        inventoryController
                                            .priceController.text.isNotEmpty &&
                                        inventoryController
                                            .itemRemarksController
                                            .text
                                            .isNotEmpty &&
                                        inventoryController.vendorNameController
                                            .text.isNotEmpty &&
                                        inventoryController
                                            .vendorRemarksController
                                            .text
                                            .isNotEmpty &&
                                        inventoryController
                                            .dateController.text.isNotEmpty) {
                                      print("Started");

                                      String stat =
                                          await inventoryController.saveData();
                                      if (stat == 'ok') {
                                        _box.boxes.clear();
                                        if (_box.boxes.isEmpty) {
                                          bool status = await UpdateBox()
                                              .boxUpdate(widget.name,
                                                  widget.qty, widget.token);

                                          if (status) {
                                            Get.snackbar("Success",
                                                "Details updated Successfully");
                                          }
                                          productsController
                                              .fetchListProducts();
                                          inventoryController.clearFields();
                                          Get.back();
                                          Navigator.pop(context);
                                          print("End");
                                        }
                                      }
                                    } else {
                                      inventoryController.isLoading.value =
                                          false;
                                      print("null value handled");
                                      Toaster().showsToast(
                                          'Please fill all fields',
                                          Colors.red,
                                          Colors.white);
                                    }
                                  } catch (e) {
                                    print('error: $e');
                                    inventoryController.isLoading.value = false;
                                  }
                                },
                                text: "Add"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
      ),
    );
  }
}
