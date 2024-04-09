// ignore_for_file: avoid_print

import 'package:get/get.dart';

import 'package:insight_app/gqls/index.dart' as gql;
import 'package:insight_app/routes/app_pages.dart';
import 'package:insight_app/utils/api.dart';

import 'package:insight_app/models/user.dart';

class AuthController extends GetxController {
  var token = Rxn<String>();
  var currentUser = Rxn<User>();

  ApiProvider apiProvider = Get.put(ApiProvider());

  bool get signedIn => token.value != null;

  setToken(value) {
    token.value = value;
  }

  setCurrentUser(user) {
    currentUser.value = user;
  }

  signIn(String email, String password) async {
    const signInMutation = gql.signInGQL;

    var variables = {
      "email": email,
      "password": password,
    };

    var result =
        await apiProvider.request(query: signInMutation, variables: variables);

    if (result != null) {
      setToken(result['SignIn']['token']);

      User? user;
      // Get User Info
      user = await User.fetchSelfGeneralInfo();

      if (user != null) {
        setCurrentUser(user);
      }

      Get.close(1);
      Get.toNamed(Routes.home);
    }
  }
}
