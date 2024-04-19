import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:insight_app/models/user.dart';

import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/controllers/auth_controller.dart';
import 'package:insight_app/widgets/uis/primary_button.dart';
import 'package:insight_app/widgets/user/user_circle_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.find<AuthController>();

  bool _isEditting = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController slackIdController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();

    ever(authController.userProfile, (callback) => _setFormData());

    authController.fetchSelfProfile();
  }

  void _setFormData() {
    User? user = authController.userProfile.value;

    if (user != null) {
      nameController.text = user.name ?? "";
      emailController.text = user.email ?? "";
      fullNameController.text = user.fullName ?? "";
      phoneController.text = user.phone ?? "";
      addressController.text = user.address ?? "";
      slackIdController.text = user.slackId ?? "";
      aboutController.text = user.about ?? "";
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    slackIdController.dispose();
    aboutController.dispose();
    super.dispose();
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
                  _buildTextField(emailController, 'Email', cantEdit: true),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildTextField(nameController, 'Name', cantEdit: true),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildTextField(phoneController, 'Phone'),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildTextField(addressController, 'Address', maxLine: 2),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildTextField(slackIdController, 'Slack Id'),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildTextField(aboutController, 'About', maxLine: 3),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      elevation: 2,
                    ),
                    onPressed: () => {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Row(
                              children: [
                                Icon(
                                  Icons.save,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Update Info',
                                  style: TextStyle(
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            content: const Text(
                              'Are you sure you want to update your info?',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Dismiss the dialog and perform the check-in action
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      )
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextField(TextEditingController controller, String label,
      {bool cantEdit = false, int maxLine = 1}) {
    return TextFormField(
      controller: controller,
      autocorrect: false,
      maxLines: maxLine,
      style: GoogleFonts.lato(
        textStyle: const TextStyle(
          fontSize: 14.0,
          color: LightColors.kDarkBlue,
        ),
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: cantEdit ? Colors.grey[300] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        floatingLabelStyle: const TextStyle(
          fontSize: 20,
          color: LightColors.kDarkBlue,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabled: cantEdit ? false : _isEditting,
      ),
    );
  }
}
