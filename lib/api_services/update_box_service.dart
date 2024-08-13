import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:inventory/api_services/api_config.dart';
import 'package:inventory/api_services/boxController.dart';

class UpdateBox {
  Future<bool> boxUpdate(String name, String qty, String token) async {
    var response =
        await http.post(Uri.parse("${ApiConfig.baseUrl}${ApiConfig.boxUpdate}"),
            body: jsonEncode({
              'token': token,
              'name': name,
              'qty': qty,
            }));
    if (response.statusCode == 200) {
      jsonDecode(response.body);

      return true;
    } else {
      return false;
    }
  }
}
