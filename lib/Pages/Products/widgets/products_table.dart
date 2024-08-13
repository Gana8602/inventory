// ProductsTable Widget (Updated with Obx)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Widgets/custom_button.dart';
import 'package:inventory/Widgets/custom_search_field.dart';
import 'package:inventory/Widgets/icon_button.dart';
import '../../../Helpers/responsiveness.dart';
import '../../../Widgets/custom_daterange.dart';
import '../../../api_services/products_service_controller.dart';
import 'mydata.dart';

class ProductsTable extends StatefulWidget {
  const ProductsTable({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProductsTableState createState() => _ProductsTableState();
}

class _ProductsTableState extends State<ProductsTable> {
  final ProductsController _productsController = Get.put(ProductsController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _productsController.fetchListProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(
        () => Column(
          children: [
            _buildFilterRow(),
            const SizedBox(height: 10),
            _productsController.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : _buildDataTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            _buildFilterDropdown(
              'Category List',
              ['Electrical', 'Mechanical', 'IT', 'Office'],
              _productsController.selectedCategory,
              (value) {
                setState(() {
                  _productsController.selectedCategory = value!;
                  _productsController.filterData();
                });
              },
            ),
            const SizedBox(width: 10),
            _buildFilterDropdown(
              'Type product',
              ['Rental', 'Assets', 'Stock'],
              _productsController.selectedType,
              (value) {
                setState(() {
                  _productsController.selectedType = value!;
                  _productsController.filterData();
                });
              },
            ),
            const SizedBox(width: 10),
            _buildFilterDropdown(
              'Location List',
              ['Inhouse', 'Warehouse', 'Onfield'],
              _productsController.selectedLocation,
              (value) {
                setState(() {
                  _productsController.selectedLocation = value!;
                  _productsController.filterData();
                });
              },
            ),
          ],
        ),
        const Spacer(),
        CustomButton(
          height: 45,
          onTap: () async {
            final DateTimeRange? pickedDateRange =
                await showDialog<DateTimeRange>(
              context: context,
              builder: (BuildContext context) {
                return CustomDateRangePickerDialog(
                  initialDateRange: _productsController.selectedDateRange,
                  onDateRangeSelected: (DateTimeRange dateRange) {
                    setState(() {
                      _productsController.selectedDateRange = dateRange;
                      _productsController.filterData();
                    });
                  },
                );
              },
            );
          },
          text: 'Select Date Range',
          textSize: 15,
          icon: Icons.date_range,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(String label, List<String> items, String value,
      void Function(String?) onChanged) {
    return Container(
      width: 140,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DropdownButton<String>(
          value: value,
          items: _buildDropdownMenuItems(['All'] + items),
          onChanged: onChanged,
          focusColor: Colors.transparent,
          hint: Text(label),
          underline: Container(),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildDropdownMenuItems(List<String> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            ))
        .toList();
  }

  Widget _buildDataTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  width: 440,
                  child: CustomSearchField(
                    onChanged: (value) {
                      setState(() {
                        _productsController.searchData = value;
                        _productsController.filterData();
                      });
                    },
                  ),
                ),
                Row(
                  children: [
                    IconTextButton(
                      onPressed: _productsController.downloadPDF,
                      icon: Icons.download,
                      tooltip: 'Download PDF',
                      label: 'PDF',
                    ),
                    const SizedBox(width: 10),
                    IconTextButton(
                      onPressed: _productsController.downloadExcel,
                      icon: Icons.download,
                      tooltip: 'Download Excel',
                      label: 'Excel',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          PaginatedDataTable(
            columns: const [
              DataColumn(label: Text("ID", style: TextStyle(fontSize: 20))),
              DataColumn(label: Text('Name', style: TextStyle(fontSize: 20))),
              DataColumn(
                  label: Text('Model No', style: TextStyle(fontSize: 20))),
              DataColumn(
                  label: Text('Serial No', style: TextStyle(fontSize: 20))),
              DataColumn(
                  label: Text('Vendor Name', style: TextStyle(fontSize: 20))),
              DataColumn(
                  label: Text('Category', style: TextStyle(fontSize: 20))),
              DataColumn(label: Text('Date', style: TextStyle(fontSize: 20))),
              DataColumn(
                  label: Text('Quantity', style: TextStyle(fontSize: 20))),
              DataColumn(label: Text('Amount', style: TextStyle(fontSize: 20))),
              DataColumn(
                  label: Text('Total Amount', style: TextStyle(fontSize: 20))),
              DataColumn(
                  label: Text('Actions', style: TextStyle(fontSize: 20))),
            ],
            source: MyData(controller: _productsController, context: context),
            columnSpacing: ResponsiveWidget.isLargeScreen(context)
                ? MediaQuery.of(context).size.width / 50
                : ResponsiveWidget.isCustomScreen(context)
                    ? MediaQuery.of(context).size.width / 60
                    : ResponsiveWidget.isMediumScreen(context)
                        ? MediaQuery.of(context).size.width / 120
                        : MediaQuery.of(context).size.width / 120,
            horizontalMargin: ResponsiveWidget.isLargeScreen(context) ? 30 : 10,
            rowsPerPage: 14,
            showCheckboxColumn: false,
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.blue.shade200),
            arrowHeadColor: Colors.lightBlue,
            showFirstLastButtons: true,
          ),
        ],
      ),
    );
  }
}
