import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Routing/routes.dart';

class MenuController extends GetxController {
  static MenuController instance = Get.find();
  var activeItem = overViewPageDisplayName.obs;
  var hoverItem = ''.obs;

  changeActiveItemTo(String itemName) {
    activeItem.value = itemName;
  }

  onHover(String itemName) {
    if (!isActive(itemName)) hoverItem.value = itemName;
  }

  bool isActive(String itemName) => activeItem.value == itemName;
  bool isHovering(String itemName) => hoverItem.value == itemName;

  Widget returnIconFor(String itemName) {
    switch (itemName) {
      case overViewPageDisplayName:
        return customIcon(Icons.trending_up, itemName);
      case inventoryPageDisplayName:
        return customIcon(Icons.inventory, itemName);
      case productsPageDisplayName:
        return customIcon(Icons.production_quantity_limits_sharp, itemName);
      case userPageDisplayName:
        return customIcon(Icons.people_alt_outlined, itemName);
      case barcodePageDisplayName:
        return customIcon(Icons.barcode_reader, itemName);
      case dispatchPageDisplayName:
        return customIcon(Icons.local_shipping, itemName);
      case authenticationPageDisplayName:
        return customIcon(Icons.exit_to_app, itemName);
      case pendingWorkDisplayName:
        return customIcon(CupertinoIcons.exclamationmark_circle_fill, itemName);
      case TrashDisplayName:
        return customIcon(Icons.delete, itemName);
      default:
        return customIcon(Icons.exit_to_app, itemName);
    }
  }

  Widget customIcon(IconData icon, String itemName) {
    if (isActive(itemName)) {
      return Icon(
        icon,
        size: 22,
        color: dark,
      );
    }
    return Icon(
      icon,
      color: isHovering(itemName) ? dark : lightGray,
    );
  }
}
