import 'package:get/get.dart';
import 'package:inventory/api_services/trash_service.dart';
import 'package:inventory/model/trashModel.dart';

class TrashController extends GetxController {
  var trash = <Trash>[].obs;

  Future<void> fetchBin() async {
    var response = await TrashService().getBin();

    if (response != null && response is List<Trash>) {
      trash.assignAll(response);
    } else {
      trash.assignAll([]);
    }
  }
}
