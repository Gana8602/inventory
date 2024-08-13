import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory/Constants/controllers.dart';
import 'package:inventory/Constants/style.dart';
import 'package:inventory/Widgets/custom_text.dart';
import 'package:inventory/api_services/auth_service_controller.dart';

import '../../Routing/routes.dart';

class AuthenticationPage extends StatelessWidget {
  AuthenticationPage({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/image/bg-image.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: SizedBox(
                        height: 70,
                        child: Image.asset(
                          'assets/image/Tridel-logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Expanded(child: Container())
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text(
                      'Login',
                      style: GoogleFonts.roboto(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  children: [
                    CustomText(
                      text: "Enter Your Credentials",
                      color: lightGray,
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  controller: authController.userController,
                  decoration: InputDecoration(
                      labelText: "Email or userName",
                      hintText: "abc@domain.com",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(
                  height: 15,
                ),
                Obx(
                  () => TextField(
                    obscureText: !authController.isPasswordVisible.value,
                    controller: authController.passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Case Sensitive",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          color: Colors.grey,
                          authController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          authController.isPasswordVisible.value =
                              !authController.isPasswordVisible.value;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        const CustomText(text: 'Remember Me')
                      ],
                    ),
                    CustomText(
                      text: 'Forgot password',
                      color: active,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    authController.loginUser(context);
                    Get.offAllNamed(rootRoute);
                    menuController.changeActiveItemTo(overViewPageDisplayName);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const CustomText(
                      text: "Login",
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
