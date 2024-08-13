import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/controllers.dart';
import 'package:inventory/Helpers/responsiveness.dart';
import 'package:inventory/Pages/Overview/Widgets/Stockout_list.dart';
import 'package:inventory/Pages/Overview/Widgets/cards_large.dart';
import 'package:inventory/Pages/Overview/Widgets/cards_medium.dart';
import 'package:inventory/Pages/Overview/Widgets/cards_small.dart';
import 'package:inventory/Pages/Overview/Widgets/revenue_section_large.dart';
import 'package:inventory/Pages/Overview/Widgets/revenue_section_small.dart';
import 'package:inventory/Widgets/custom_text.dart';

class OverViewPage extends StatelessWidget {
  const OverViewPage({super.key});

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
                    padding: const EdgeInsets.all(8.0),
                    child: CustomText(
                      text: menuController.activeItem.value,
                      size: 24,
                      weight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            )),
        Expanded(
            child: ListView(
          children: [
            if (ResponsiveWidget.isLargeScreen(context) ||
                ResponsiveWidget.isCustomScreen(context))
              const OverviewCardsLargeScreen(),
            if (ResponsiveWidget.isMediumScreen(context))
              const OverviewCardsMediumScreen(),
            if (ResponsiveWidget.isSmallScreen(context))
              const OverviewCardsSmallScreen(),
            if (!ResponsiveWidget.isSmallScreen(context))
              RevenueSectionLarge()
            else
              RevenueSectionSmall(),
            const StockOutList(),
          ],
        ))
      ],
    );
  }
}
