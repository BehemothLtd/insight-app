// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/routes/app_pages.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/utils/custom_snackbar.dart';

class AuthController extends GetxController {
  var token = Rxn<String>();
  var currentUser = Rxn<User>(User());
  var selfPermissions = Rxn<List<SelfPermission>>([SelfPermission()]);

  // computed
  bool get signedIn => token.value != null;

  // =======COMMIT==========
  setToken(String? value) {
    token.value = value;
  }

  setCurrentUser(User user) {
    currentUser.value = user;
  }

  setSelfPermission(List<SelfPermission> permissions) {
    selfPermissions.value = permissions;
  }

  // =======ACTIONS==========
  fetchSelfGeneralInfo() async {
    User? user;
    user = await User.fetchSelfGeneralInfo();

    if (user != null) {
      setCurrentUser(user);
    }
  }

  fetchSelfPermissions() async {
    List<SelfPermission> permissions = await User.fetchPermissions();

    if (permissions.isNotEmpty) {
      setSelfPermission(permissions);
    }
  }

  signIn(String email, String password) async {
    var result = await User.signIn(email, password);

    if (result != null) {
      setToken(result['SignIn']['token']);

      fetchSelfGeneralInfo();

      fetchSelfPermissions();

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

    Future.delayed(const Duration(milliseconds: 200), () {
      Get.close(1);
      Get.toNamed(Routes.signIn);
    });
  }
}
