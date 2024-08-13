import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Pages/Overview/Widgets/info_card.dart';
import 'package:inventory/api_services/stockCount_service.dart';

import '../../../Constants/controllers.dart';
import '../../../Routing/routes.dart';

class OverviewCardsLargeScreen extends StatefulWidget {
  const OverviewCardsLargeScreen({super.key});

  @override
  State<OverviewCardsLargeScreen> createState() =>
      _OverviewCardsLargeScreenState();
}

class _OverviewCardsLargeScreenState extends State<OverviewCardsLargeScreen> {
  StockCountController stockCountController = Get.put(StockCountController());

  @override
  void initState() {
    super.initState();
    stockCountController.productsCount();
    stockCountController.vendorCount();
    stockCountController.employeeCount();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Obx(
      () => Row(
        children: [
          InfoCard(
              title: "GeoScience Stock",
              value: stockCountController.geoscienceCount.toString(),
              textColor: Colors.orange,
              onTap: () {
                menuController.changeActiveItemTo(productsPageDisplayName);
                navigationController.navigateTo(productsPageRoute);
              },
              topcolor: Colors.orange),
          SizedBox(
            width: width / 64,
          ),
          InfoCard(
              title: "GeoInformatics Stock",
              value: stockCountController.geoinformaticsCount.toString(),
              textColor: Colors.lightGreen,
              onTap: () {
                menuController.changeActiveItemTo(productsPageDisplayName);
                navigationController.navigateTo(productsPageRoute);
              },
              topcolor: Colors.lightGreen),
          SizedBox(
            width: width / 64,
          ),
          InfoCard(
              title: "GeoEngineering",
              value: stockCountController.geoengineeringCount.toString(),
              textColor: Colors.redAccent,
              onTap: () {
                menuController.changeActiveItemTo(productsPageDisplayName);
                navigationController.navigateTo(productsPageRoute);
              },
              topcolor: Colors.redAccent),
          SizedBox(
            width: width / 64,
          ),
          InfoCard(
            title: "Office",
            value: stockCountController.officeCount.toString(),
            textColor: active,
            onTap: () {
              menuController.changeActiveItemTo(userPageDisplayName);
              navigationController.navigateTo(userPageRoute);
            },
          ),
        ],
      ),
    );
  }
}
