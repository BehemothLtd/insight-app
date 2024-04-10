// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/routes/app_pages.dart';
import 'package:insight_app/utils/api.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/utils/custom_snackbar.dart';

class AuthController extends GetxController {
  var token = Rxn<String>();
  var currentUser = Rxn<User>();

  ApiProvider apiProvider = Get.find<ApiProvider>();

  // computed
  bool get signedIn => token.value != null;

  setToken(value) {
    token.value = value;
  }

  setCurrentUser(user) {
    currentUser.value = user;
  }

  signIn(String email, String password) async {
    var result = await User.signIn(email, password);

    if (result != null) {
      setToken(result['SignIn']['token']);

      User? user;
      // Get User Info
      user = await User.fetchSelfGeneralInfo();

      if (user != null) {
        setCurrentUser(user);
      }

      showCustomSnackbar(
        message: "Signed In",
        title: 'Success',
        backgroundColor: Colors.blue,
        iconData: Icons.check,
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.close(1);
        Get.toNamed(Routes.home);
      });
    }
  }

  signOut() {
    setToken(null);
    showCustomSnackbar(
      message: "Signed Out",
      title: 'Success',
      backgroundColor: Colors.blue,
      iconData: Icons.check,
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      Get.close(1);
      Get.toNamed(Routes.signIn);
    });
  }
}
