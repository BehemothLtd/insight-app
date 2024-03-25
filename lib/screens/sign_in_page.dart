import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/constanst.dart';
import 'package:insight_app/controllers/auth_controller.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/widgets/auth/auth_input_field.dart';
import 'package:insight_app/widgets/uis/primary_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  static final authController = Get.put(AuthController());

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String email = "";
  String password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SYSTEM_UI_STYLE,
        toolbarHeight: 0,
      ),
      backgroundColor: LightColors.kDarkYellow,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AuthInputField(
                label: "Email Address",
                obscureText: false,
                controller: emailController,
                textColor: Colors.black,
                fontSize: 14,
                hintText: "user@behemoth.vn",
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              AuthInputField(
                label: "Password",
                obscureText: true,
                controller: passwordController,
                textColor: Colors.black,
                fontSize: 14,
                hintText: "* * * * * *",
                padding: const EdgeInsets.only(bottom: 8),
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              PrimaryButton(
                buttonText: "Login",
                onPressed: () {
                  authController.signIn(email, password);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
