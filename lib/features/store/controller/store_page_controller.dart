import 'package:get/get.dart';

class StorePageController extends GetxController {
  RxInt seedNumber = 153.obs; // RxInt for reactive variable
  void incrementSeedNumber() {
    seedNumber.value++;
  }
  void decrementSeedNumber() {
    if (seedNumber.value > 0) {
      seedNumber.value--;
    }

  }
}
