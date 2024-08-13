import 'package:flutter/material.dart';
import 'package:inventory/Widgets/large_screen.dart';
import 'package:inventory/Widgets/side_menu.dart';
import 'package:inventory/Widgets/small_screen.dart';
import 'package:inventory/Widgets/top_nav.dart';
import 'package:inventory/helpers/responsiveness.dart';

class Layout extends StatelessWidget {
  Layout({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // extendBodyBehindAppBar: true,
      appBar: topNavigationBar(context, scaffoldKey),
      drawer: const Drawer(
        child: SideMenu(),
      ),
      body: const ResponsiveWidget(
          largeScreen: LargeScreen(),
          mediumScreen: LargeScreen(),
          smallScreen: SmallScreen()),
    );
  }
}
