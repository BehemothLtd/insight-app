import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:insight_app/controllers/auth_controller.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/widgets/auth/auth_input_field.dart';
import 'package:insight_app/widgets/form/form_validator.dart';
import 'package:insight_app/widgets/uis/primary_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String email = "";
  String password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  static final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kDarkYellow,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFFFE0B2), // A light peach color
              Color(0xFFF57C00) // Darker orange
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: <Widget>[
                          const Spacer(flex: 2),
                          SvgPicture.asset(
                            'assets/images/behemoth-logo.svg',
                            width: MediaQuery.of(context).size.width *
                                0.5, // Logo is 50% of screen width
                          ),
                          const Spacer(),
                          // Your TextFields and Login button
                          FormValidator(
                            errorKey: "email",
                            child: AuthInputField(
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
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FormValidator(
                            errorKey: "password",
                            child: AuthInputField(
                              label: "Password",
                              obscureText: true,
                              controller: passwordController,
                              textColor: Colors.black,
                              fontSize: 14,
                              hintText: "* * * * * *",
                              onChanged: (String value) {
                                setState(() {
                                  password = value;
                                });
                              },
                            ),
                          ),
                          PrimaryButton(
                            buttonText: "Login",
                            onPressed: () {
                              authController.signIn(email, password);
                            },
                            buttonColor: const Color(0xFF1565C0),
                          ),
                          const Spacer(flex: 3),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
