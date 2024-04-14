import 'package:get/get.dart';

import 'package:insight_app/screens/home.dart';
import 'package:insight_app/screens/sign_in.dart';
import 'package:insight_app/screens/projects.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialRoute = Routes.signIn;

  static final routes = [
    GetPage(name: _Paths.signIn, page: () => const SignInScreen()),
    GetPage(name: _Paths.home, page: () => const HomeScreen()),
    GetPage(name: _Paths.projects, page: () => const ProjectsScreen()),
  ];
}
