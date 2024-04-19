import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: LightColors.kDarkYellow,
        elevation: 0,
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
                Positioned(
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          ListTile(
            title: Text('Name'),
            subtitle: Text('Test Test'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Implement navigation or functionality for editing the name
            },
          ),
          ListTile(
            title: Text('Phone'),
            subtitle: Text('(208) 206-5039'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Implement navigation or functionality for editing the phone
            },
          ),
          ListTile(
            title: Text('Email'),
            subtitle: Text('test.test@gmail.com'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Implement navigation or functionality for editing the email
            },
          ),
          ListTile(
            title: Text('Tell Us About Yourself'),
            subtitle: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
            isThreeLine: true,
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              // Implement navigation or functionality for editing the bio
            },
          ),
        ],
      ),
    );
  }
}
