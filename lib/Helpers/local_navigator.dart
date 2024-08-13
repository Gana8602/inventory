import 'package:flutter/material.dart';
import 'package:inventory/Constants/controllers.dart';
import 'package:inventory/Routing/router.dart';
import 'package:inventory/Routing/routes.dart';

Navigator localNavigator() => Navigator(
      key: navigationController.navigatorKey,
      initialRoute: overViewPageRoute,
      onGenerateRoute: generateRoute,
    );
