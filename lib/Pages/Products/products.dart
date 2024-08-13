import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Constants/controllers.dart';
import '../../Helpers/responsiveness.dart';
import '../../Widgets/custom_text.dart';
import 'widgets/products_table.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: ListView(
            children: const [
              ProductsTable(),
            ],
          ),
        ),
      ],
    );
  }
}
