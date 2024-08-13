// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:inventory/api_services/box_service.dart';
import 'package:inventory/model/box_model.dart';

class BoxController extends GetxController {
  var boxes = <BoxModel>[].obs;

  Future<void> fetchBoxes() async {
    var response = await BoxService().fetchBox();
    if (response != null) {
      boxes.assignAll(response.reversed);
    } else {
      boxes.assignAll([]);
    }
  }
}
