import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:inventory/Pages/Employee/widgets/employee_table.dart';
import 'package:inventory/Widgets/custom_button.dart';
import 'package:inventory/Widgets/elevated_button.dart';
import 'package:inventory/api_services/employee_addService.dart';

import '../../Constants/controllers.dart';
import '../../Helpers/responsiveness.dart';
import '../../Widgets/custom_text.dart';
import '../../Widgets/custom_text_field.dart';
import '../../Widgets/dropdown.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({super.key});

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  final EmployeeAddController employeeAddController =
      Get.put(EmployeeAddController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                  child: CustomText(
                    text: menuController.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                CustomButton(
                  width: 170,
                  onTap: () async {
                    _showDialog();
                  },
                  text: 'Add Users',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: employeeAddController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : const EmployeeTable(),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    // print("Add Employee called");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create User'),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 400,
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: employeeAddController.idController,
                    fieldTitle: 'Employee ID',
                    color: Colors.grey,
                    keyboard: TextInputType.number,
                    textInput: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  CustomTextField(
                    textEditingController: employeeAddController.nameController,
                    fieldTitle: 'Name',
                    color: Colors.grey,
                  ),
                  CustomTextField(
                    textEditingController:
                        employeeAddController.userNameController,
                    fieldTitle: 'User Name',
                    color: Colors.grey,
                  ),
                  CustomTextField(
                    textEditingController:
                        employeeAddController.phoneController,
                    fieldTitle: 'Mobile No',
                    color: Colors.grey,
                    keyboard: TextInputType.number,
                    textInput: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  CustomTextField(
                    textEditingController:
                        employeeAddController.emailController,
                    fieldTitle: 'Mail Id',
                    color: Colors.grey,
                    hintText: 'example@mail.com',
                  ),
                  CustomTextField(
                    textEditingController:
                        employeeAddController.passwordController,
                    fieldTitle: 'Password',
                    color: Colors.grey,
                  ),
                  CustomDropDown(
                    items: employeeAddController.roleList,
                    val: employeeAddController.selectedRole.value,
                    onChanged: (newValue) {
                      setState(() {
                        employeeAddController.selectedRole.value = newValue!;
                      });
                    },
                    fieldTitle: 'Role',
                    borderColor: Colors.grey,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            Center(
              child: Obx(() => employeeAddController.isLoading.value
                  ? const CircularProgressIndicator()
                  : Button(
                      onPressed: () async {
                        bool status = await employeeAddController.addEmployee();
                        if (status) {
                          Get.back();
                        }
                      },
                      text: 'Add  User')),
            ),
          ],
        );
      },
    );
  }
}
