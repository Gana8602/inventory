import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:inventory/api_services/api_config.dart';
import 'package:inventory/model/box_model.dart';

class BoxService {
  Future<List<BoxModel>?> fetchBox() async {
    var response =
        await http.get(Uri.parse("${ApiConfig.baseUrl}${ApiConfig.getBox}"));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var boxes = data['data'];
      List<BoxModel> boxList =
          (boxes as List).map((e) => BoxModel.fromJson(e)).toList();
      return boxList;
    } else {
      return null;
    }
  }
}
