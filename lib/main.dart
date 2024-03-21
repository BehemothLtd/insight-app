import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/auth_controller.dart';
import 'package:insight_app/screens/home_page.dart';
import 'package:insight_app/screens/sign_in_page.dart';
import 'package:insight_app/theme/colors/light_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static final AuthController authController = Get.put(AuthController());

  // var initWidget = Obx(
  //   () => authController.token.value != null
  //       ? const HomePage()
  //       : const SignInPage(),
  // );

  var initWidget = authController.token.value != null
      ? const HomePage()
      : const SignInPage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: LightColors.kDarkBlue,
              displayColor: LightColors.kDarkBlue,
              fontFamily: 'Poppins',
            ),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
              color: LightColors.kDarkYellow,
            ),
      ),
      home: initWidget,
      debugShowCheckedModeBanner: false,
    );
  }
}
