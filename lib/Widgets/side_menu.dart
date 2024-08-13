import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/controllers.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Helpers/responsiveness.dart';
import 'package:inventory/Routing/routes.dart';
import 'package:inventory/Widgets/custom_text.dart';
import 'package:inventory/Widgets/side_menu_item.dart';

import '../Helpers/autoscrolltext.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          color: light,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 6),
                color: lightGray.withOpacity(.1),
                blurRadius: 12)
          ],
          border: Border.all(color: lightGray, width: .10)),
      // color: light,
      child: ListView(
        children: [
          if (ResponsiveWidget.isSmallScreen(context))
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: width / 48,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Image.asset(
                        'assets/image/inventory2.png',
                        fit: BoxFit.cover,
                        height: 50,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: CustomText(
                        text: 'Admin Panel',
                        size: 20,
                        weight: FontWeight.bold,
                        color: lightGray,
                      ),
                    ),
                    SizedBox(width: width / 48),
                  ],
                ),
                const Divider(),
              ],
            ),
          const SizedBox(height: 20),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: sideMenuItems
                .map((item) => SideMenuItem(
                      itemName: item.name,
                      onTap: () {
                        if (item.route == authenticationPageRoute) {
                          menuController
                              .changeActiveItemTo(overViewPageDisplayName);
                          Get.offAllNamed(authenticationPageRoute);
                        }

                        if (!menuController.isActive(item.name)) {
                          menuController.changeActiveItemTo(item.name);
                          if (ResponsiveWidget.isSmallScreen(context)) {
                            Get.back();
                          }
                          navigationController.navigateTo(item.route);
                        }
                      },
                    ))
                .toList(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 8,
          ),
          Expanded(child: const InformationWarning()),
          SideMenuItem(
            itemName: pendingWorkDisplayName,
            onTap: () {
              menuController.changeActiveItemTo(pendingWorkDisplayName);
              navigationController.navigateTo(PendingtaskRoute);
            },
          )
        ],
      ),
    );
  }
}
