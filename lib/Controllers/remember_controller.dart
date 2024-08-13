// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class RememberMeController extends GetxController {
//   var isRememberChecked = false.obs;

//   Future<void> loadRememberMe() async {
//     final prefs = await SharedPreferences.getInstance();
//     isRememberChecked.value = prefs.getBool('remember_me') ?? false;
//     print("Remember Me Loaded: ${isRememberChecked.value}");
//   }

//   Future<void> saveRememberMe(bool value) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setBool('remember_me', value);
//     isRememberChecked.value = value;
//     print("Remember Me Saved: $value");
//   }

//   Future<void> saveCredentials(String email, String password) async {
//     if (isRememberChecked.value) {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString(email, email);
//       await prefs.setString(password, password);
//       print("Credentials Saved: Email - $email, Password - $password");
//     }
//   }

//   Future<Map<String, String>> getCredentials() async {
//     final prefs = await SharedPreferences.getInstance();
//     final email = prefs.getString('email') ?? '';
//     final password = prefs.getString('password') ?? '';
//     print("Credentials Loaded: Email - $email, Password - $password");
//     return {'email': email, 'password': password};
//   }

//   Future<void> clearCredentials() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('email');
//     await prefs.remove('password');
//     print("Credentials Cleared");
//   }
// }
