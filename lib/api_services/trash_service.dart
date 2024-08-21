import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:inventory/api_services/api_config.dart';
import 'package:inventory/model/trashModel.dart';

class TrashService {
  Future<dynamic> getBin() async {
    var response =
        await http.get(Uri.parse("${ApiConfig.baseUrl}${ApiConfig.getBin}"));
    var data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      List<dynamic> list = data['data'];
      List<Trash> trash = list.map((e) => Trash.fromjson(e)).toList();
      return trash;
    } else {
      return null;
    }
  }
}
