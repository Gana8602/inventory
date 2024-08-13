import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Widgets/custom_text.dart';

import '../../../Constants/style.dart';
import '../../../api_services/employee_service_controller.dart';
import '../../../helpers/responsiveness.dart';

class EmployeeTable extends StatefulWidget {
  const EmployeeTable({super.key});

  @override
  State<EmployeeTable> createState() => _EmployeeTableState();
}

class _EmployeeTableState extends State<EmployeeTable> {
  final EmployeeServiceController _employeeServiceController =
      Get.put((EmployeeServiceController()));

  final verticalScrollController = ScrollController();
  final horizontalScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _employeeServiceController.fetchEmployees();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (_employeeServiceController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container(
            width: MediaQuery.of(context).size.width,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                controller: verticalScrollController,
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  controller: horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      columnSpacing: ResponsiveWidget.isLargeScreen(context)
                          ? MediaQuery.of(context).size.width / 14
                          : ResponsiveWidget.isCustomScreen(context)
                              ? MediaQuery.of(context).size.width / 18
                              : ResponsiveWidget.isMediumScreen(context)
                                  ? MediaQuery.of(context).size.width / 30
                                  : MediaQuery.of(context).size.width / 100,
                      horizontalMargin:
                          ResponsiveWidget.isLargeScreen(context) ? 30 : 10,
                      columns: const [
                        DataColumn(
                            label: Text('ID',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('Employee ID',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('Name',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('Username',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('role',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('Email',
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center)),
                        DataColumn(
                          label: Text('Phone',
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                          _employeeServiceController.employeeList.length,
                          (index) => DataRow(cells: [
                                DataCell(Center(
                                  child:
                                      CustomText(text: (index + 1).toString()),
                                )),
                                DataCell(Center(
                                  child: CustomText(
                                      text: _employeeServiceController
                                          .employeeList[index].employeeId
                                          .toString()),
                                )),
                                DataCell(CustomText(
                                    text: _employeeServiceController
                                        .employeeList[index].name
                                        .toString())),
                                DataCell(CustomText(
                                    text: _employeeServiceController
                                        .employeeList[index].username
                                        .toString())),
                                DataCell(CustomText(
                                    text: _employeeServiceController
                                        .employeeList[index].role)),
                                DataCell(CustomText(
                                    text: _employeeServiceController
                                        .employeeList[index].email
                                        .toString())),
                                DataCell(CustomText(
                                    text: _employeeServiceController
                                        .employeeList[index].phone
                                        .toString())),
                              ]))),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
