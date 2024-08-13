import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Pages/Overview/Widgets/info_card_small.dart';

import '../../../Constants/controllers.dart';
import '../../../Routing/routes.dart';
import '../../../api_services/stockCount_service.dart';

class OverviewCardsSmallScreen extends StatefulWidget {
  const OverviewCardsSmallScreen({super.key});

  @override
  State<OverviewCardsSmallScreen> createState() =>
      _OverviewCardsSmallScreenState();
}

class _OverviewCardsSmallScreenState extends State<OverviewCardsSmallScreen> {
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
      () => SizedBox(
        height: 400,
        child: Column(
          children: [
            InfoCardSmall(
              title: "GeoScience Stock",
              value: stockCountController.geoscienceCount.toString(),
              onTap: () {
                menuController.changeActiveItemTo(productsPageDisplayName);
                navigationController.navigateTo(productsPageRoute);
              },
              isActive: true,
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCardSmall(
              title: "GeoInformatics Stock",
              value: stockCountController.geoinformaticsCount.toString(),
              onTap: () {
                menuController.changeActiveItemTo(productsPageDisplayName);
                navigationController.navigateTo(productsPageRoute);
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCardSmall(
              title: "GeoEngineering",
              value: stockCountController.geoengineeringCount.toString(),
              onTap: () {
                menuController.changeActiveItemTo(barcodePageDisplayName);
                navigationController.navigateTo(barcodePageroute);
              },
            ),
            SizedBox(
              width: width / 64,
            ),
            InfoCardSmall(
              title: "Office",
              value: stockCountController.officeCount.toString(),
              onTap: () {
                menuController.changeActiveItemTo(userPageDisplayName);
                navigationController.navigateTo(userPageRoute);
              },
            ),
          ],
        ),
      ),
    );
  }
}
