import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/controllers/auth_controller.dart';
import 'package:insight_app/widgets/user/user_circle_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  bool _isEditting = false;

  late TextEditingController fullNameController;

  @override
  void initState() {
    super.initState();

    authController.fetchSelfProfile();

    fullNameController =
        TextEditingController(text: authController.currentUser.value?.fullName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: LightColors.kDarkYellow,
        elevation: 0,
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                    : Tween<double>(begin: 0.75, end: 1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _isEditting
                  ? const Icon(Icons.edit_off_sharp, key: ValueKey('icon1'))
                  : const Icon(
                      Icons.edit,
                      key: ValueKey('icon2'),
                    ),
            ),
            onPressed: () {
              setState(() {
                _isEditting = !_isEditting;
              });
            },
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Obx(
                  () => UserCircleAvatar(
                    user: authController.currentUser.value,
                    size: 80,
                  ),
                ),
                _isEditting
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          backgroundColor: LightColors.kDarkYellow,
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () {
                              // TODO: Implement image update functionality
                            },
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: fullNameController,
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 14.0,
                        color: LightColors.kDarkBlue,
                      ),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      floatingLabelStyle: const TextStyle(
                        fontSize: 20,
                        color: LightColors.kDarkBlue,
                        fontWeight: FontWeight.w500,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      enabled: _isEditting,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
