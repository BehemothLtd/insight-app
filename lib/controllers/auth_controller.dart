// ignore_for_file: avoid_print

import 'package:get/get.dart';

class AuthController extends GetxController {
  var token = Rxn<String>();

  bool get signedIn => token.value != null;

  setToken(value) {
    token.value = value;
  }

  signIn(String email, String password) {
    print(email);
    print(password);
  }
}
