import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Widgets/custom_text.dart';
import 'package:inventory/api_services/auth_service_controller.dart';
import 'package:inventory/helpers/responsiveness.dart';

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      automaticallyImplyLeading: false,

      title: !ResponsiveWidget.isSmallScreen(context) &&
              !ResponsiveWidget.isMediumScreen(context)
          ? Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Row(
                children: [
                  Image.asset(
                    "assets/image/inventory2.png",
                    fit: BoxFit.cover,
                    height: 40,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Visibility(
                      child: CustomText(
                    text: "Admin Panel",
                    color: lightGray,
                    size: 20,
                    weight: FontWeight.bold,
                  )),
                  Expanded(child: Container()),
                  Obx(
                    () => CustomText(
                      text: 'Welcome, ${Get.find<AuthController>().userName}',
                      color: lightGray,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue.withOpacity(.5),
                        borderRadius: BorderRadius.circular(30)),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundColor: light,
                        child: Icon(
                          Icons.person_outline,
                          color: dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 26,
                  ),
                  Image.asset(
                    'assets/image/Tridel-logo.png',
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            )
          : ResponsiveWidget.isMediumScreen(context)
              ? Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/image/inventory2.png",
                            fit: BoxFit.cover,
                            height: 35,
                          ),
                          Visibility(
                              child: CustomText(
                            text: "Admin Panel",
                            color: lightGray,
                            size: 16,
                            weight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    CustomText(
                      text: 'Welcome, ${Get.find<AuthController>().userName}',
                      color: lightGray,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          backgroundColor: light,
                          child: Icon(
                            Icons.person_outline,
                            color: dark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 26,
                    ),
                    Image.asset(
                      'assets/image/Tridel-logo.png',
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ],
                )
              : Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          key.currentState!.openDrawer();
                        },
                        icon: const Icon(Icons.menu)),
                    Expanded(child: Container()),
                    CustomText(
                      text: 'Welcome, ${Get.find<AuthController>().userName}',
                      color: lightGray,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.withOpacity(.5),
                          borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.all(2),
                        margin: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          backgroundColor: light,
                          child: Icon(
                            Icons.person_outline,
                            color: dark,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 26,
                    ),
                    Image.asset(
                      'assets/image/Tridel-logo.png',
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),

      // leading: !ResponsiveWidget.isSmallScreen(context)
      //     ? Row(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.only(left: 16),
      //             child: Image.asset(
      //               "assets/image/inventory2.png",
      //               fit: BoxFit.cover,
      //               height: 40,
      //             ),
      //           ),
      //         ],
      //       )
      //     : IconButton(
      //         onPressed: () {
      //           key.currentState!.openDrawer();
      //         },
      //         icon: const Icon(Icons.menu)),
      // elevation: 0,
      // title: Row(
      //   children: [
      //     Visibility(
      //         child: CustomText(
      //       text: "Admin Panel",
      //       color: lightGray,
      //       size: 20,
      //       weight: FontWeight.bold,
      //     )),
      //     Expanded(child: Container()),
      //     CustomText(
      //       text: 'Person Name',
      //       color: lightGray,
      //     ),
      //     const SizedBox(
      //       width: 10,
      //     ),
      //     Container(
      //       decoration: BoxDecoration(
      //           color: Colors.lightBlue.withOpacity(.5),
      //           borderRadius: BorderRadius.circular(30)),
      //       child: Container(
      //         decoration: BoxDecoration(
      //             color: Colors.white, borderRadius: BorderRadius.circular(30)),
      //         padding: const EdgeInsets.all(2),
      //         margin: const EdgeInsets.all(2),
      //         child: CircleAvatar(
      //           backgroundColor: light,
      //           child: Icon(
      //             Icons.person_outline,
      //             color: dark,
      //           ),
      //         ),
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 26,
      //     ),
      //     Image.asset(
      //       'assets/image/Tridel-logo.png',
      //       height: 56,
      //       fit: BoxFit.cover,
      //     ),
      //   ],
      // ),
      iconTheme: IconThemeData(color: dark),
      backgroundColor: Colors.transparent,
    );
