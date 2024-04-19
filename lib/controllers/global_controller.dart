import 'package:get/get.dart';

class GlobalController extends GetxController {
  // Initialize errors as an observable with an empty map.
  var errors = <String, List<String>>{}.obs;

  void setErrors(Map<String, List<String>> value) {
    // Use .value to correctly update the observable's value.
    errors.value = value;
  }

  void resetErrors() {
    errors.value = <String, List<String>>{};
  }
}
