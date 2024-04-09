import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:insight_app/routes/app_pages.dart';

void main() async {
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initialRoute,
      getPages: AppPages.routes,
    );
  }
}
