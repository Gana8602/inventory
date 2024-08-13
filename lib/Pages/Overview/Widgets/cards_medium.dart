import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/style.dart';

import '../../../Constants/controllers.dart';
import '../../../Routing/routes.dart';
import '../../../api_services/stockCount_service.dart';
import 'info_card.dart';

class OverviewCardsMediumScreen extends StatefulWidget {
  const OverviewCardsMediumScreen({super.key});

  @override
  State<OverviewCardsMediumScreen> createState() =>
      _OverviewCardsMediumScreenState();
}

class _OverviewCardsMediumScreenState extends State<OverviewCardsMediumScreen> {
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
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
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
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              InfoCard(
                  title: "GeoEngineering",
                  value: stockCountController.geoengineeringCount.toString(),
                  textColor: Colors.redAccent,
                  onTap: () {
                    menuController.changeActiveItemTo(barcodePageDisplayName);
                    navigationController.navigateTo(barcodePageroute);
                  },
                  topcolor: Colors.redAccent),
              SizedBox(
                width: width / 64,
              ),
              InfoCard(
                title: "Office",
                value: stockCountController.employeecount.toString(),
                textColor: active,
                onTap: () {
                  menuController.changeActiveItemTo(userPageDisplayName);
                  navigationController.navigateTo(userPageRoute);
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
