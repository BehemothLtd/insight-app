import 'package:get/get.dart';

import 'package:insight_app/screens/home_page.dart';
import 'package:insight_app/screens/sign_in_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialRoute = Routes.signIn;

  static final routes = [
    GetPage(name: _Paths.signIn, page: () => const SignInPage()),
    GetPage(name: _Paths.home, page: () => const HomePage()),
  ];
}
