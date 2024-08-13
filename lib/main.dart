import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory/404/error_page.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Controllers/menu_controller.dart' as menu_controller;
import 'package:inventory/Controllers/navigation_controller.dart';
import 'package:inventory/Pages/Authentication/authentication.dart';
import 'package:inventory/api_services/stockout_revenue_service.dart';
import 'package:oktoast/oktoast.dart';
import 'Routing/routes.dart';
import 'api_services/auth_service_controller.dart';
import 'layout.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  Get.put(AuthController());
  Get.put(RevenueService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: GetMaterialApp(
        initialRoute: authenticationPageRoute,
        unknownRoute: GetPage(
            name: '/not-found',
            page: () => const PageNotFound(),
            transition: Transition.fadeIn),
        getPages: [
          GetPage(
              name: rootRoute,
              page: () {
                return Layout();
              }),
          GetPage(
              name: authenticationPageRoute, page: () => AuthenticationPage()),
        ],
        debugShowCheckedModeBanner: false,
        title: 'DashBoard',
        theme: ThemeData(
          scaffoldBackgroundColor: light,
          textTheme: GoogleFonts.mulishTextTheme(
            Theme.of(context).textTheme,
          ).apply(bodyColor: Colors.black),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          }),
          primaryColor: Colors.lightBlue,
        ),
      ),
    );
  }
}
