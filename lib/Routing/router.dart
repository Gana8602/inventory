import 'package:flutter/material.dart';
import 'package:inventory/Pages/Authentication/authentication.dart';
import 'package:inventory/Pages/BarCode/barcode.dart';
import 'package:inventory/Pages/Dispatch/dispatch.dart';
import 'package:inventory/Pages/Employee/employee.dart';
import 'package:inventory/Pages/Inventory/add_box.dart';
import 'package:inventory/Pages/Inventory/inventory.dart';
import 'package:inventory/Pages/Overview/overview.dart';
import 'package:inventory/Pages/Products/products.dart';
import 'package:inventory/Pages/trash/trash.dart';
import 'package:inventory/Routing/routes.dart';

import '../Pages/pendingTask/pendingTask.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case overViewPageRoute:
      return getPageRoute(const OverViewPage());
    case inventoryPageRoute:
      return getPageRoute(const BoxAddPage());
    case productsPageRoute:
      return getPageRoute(const ProductsPage());
    case userPageRoute:
      return getPageRoute(const EmployeePage());
    case authenticationPageRoute:
      return getPageRoute(AuthenticationPage());
    case barcodePageroute:
      return getPageRoute(const BarCodePage());
    case dispatchPageRoute:
      return getPageRoute(DispatchPage());
    case PendingtaskRoute:
      return getPageRoute(const Pendingtask());
    case trashRoute:
      return getPageRoute(const TrashPage());
    default:
      return getPageRoute(const OverViewPage());
  }
}

PageRoute getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
