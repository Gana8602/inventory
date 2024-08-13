import 'package:flutter/material.dart';
import 'package:inventory/Helpers/responsiveness.dart';
import 'package:inventory/Widgets/horizontal_menu_item.dart';
import 'package:inventory/Widgets/vertical_menu_item.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({super.key, required this.itemName, required this.onTap});

  final String itemName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isMediumScreen(context)) {
      return VerticalMenuItem(itemName: itemName, onTap: onTap);
    } else {
      return HorizontalMenuItem(itemName: itemName, onTap: onTap);
    }
  }
}
