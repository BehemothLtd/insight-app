import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/models/user.dart';
import 'package:insight_app/utils/custom_snackbar.dart';

class UserController extends GetxController {
  var userProfile = Rxn<User>(User());

  setCurrentUserProfile(User user) {
    print("CAME HERE");
    userProfile.value = user;
  }

  fetchSelfProfile() async {
    User? user = await User.fetchProfile();

    if (user != null) {
      setCurrentUserProfile(user);
    }
  }

  Future<bool> updateProfile(SelfUpdateProfileInput input) async {
    User? user = await User.updateProfile(input);

    if (user != null) {
      showCustomSnackbar(
        message: "Updated",
        title: 'Success',
        backgroundColor: Colors.blue,
        iconData: Icons.check,
      );

      setCurrentUserProfile(user);

      return true;
    }

    return false;
  }
}
