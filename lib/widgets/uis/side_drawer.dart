import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/auth_controller.dart';
import 'package:insight_app/models/user.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/widgets/user/circle_avatar.dart';

// Define a class for menu items
class MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  MenuItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class SideDrawer extends StatelessWidget {
  final User? currentUser;

  const SideDrawer({
    super.key,
    required this.currentUser,
  });

  static final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Define a list of menu items
    final List<MenuItem> menuItems = [
      MenuItem(
        title: 'Home',
        icon: Icons.home,
        onTap: () {
          Navigator.pop(context); // Close the drawer
          // Navigate to the Home screen
        },
      ),
      MenuItem(
        title: 'Profile',
        icon: Icons.person,
        onTap: () {
          Navigator.pop(context); // Close the drawer
          // Navigate to the Profile screen
        },
      ),
      // Add more menu items here
    ];

    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: LightColors.kDarkYellow, // The background color
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      UserCircleAvatar(currentUser: currentUser),
                      const SizedBox(width: 16.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser?.fullName ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                          Text(
                            currentUser?.email ?? '',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: ListView(
              children: menuItems.map((item) {
                return ListTile(
                  leading: Icon(item.icon), // The menu item icon
                  title: Text(item.title),
                  onTap: item.onTap,
                );
              }).toList(),
            ),
          ),
          const Divider(
            height: 32,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () {
              authController.signOut();
            },
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
