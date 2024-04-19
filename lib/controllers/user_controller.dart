import 'package:get/get.dart';

import 'package:insight_app/models/user.dart';

class UserController extends GetxController {
  var userProfile = Rxn<User>(User());

  setCurrentUserProfile(User user) {
    userProfile.value = user;
  }

  fetchSelfProfile() async {
    User? user;

    user = await User.fetchProfile();

    if (user != null) {
      setCurrentUserProfile(user);
    }
  }
}
