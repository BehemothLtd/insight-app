import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insight_app/controllers/user_controller.dart';
import 'package:insight_app/models/file_upload.dart';
import 'package:insight_app/models/user.dart';

import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/utils/time.dart';
import 'package:insight_app/widgets/form/form_validator.dart';
import 'package:insight_app/widgets/user/user_circle_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => ProfileScreenState();
}

typedef DateSelector = Future<void> Function(BuildContext);
typedef GenderSelector = Future<void> Function(BuildContext);

class ProfileScreenState extends State<ProfileScreen> {
  final UserController userController = Get.put(UserController());

  bool _isEditting = false;
  final ImagePicker _picker = ImagePicker();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController slackIdController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController avatarController = TextEditingController();

  Map<String, String> genderOptions = {
    'Male': 'male',
    'Female': 'female',
    'Bisexuality': 'bisexuality',
  };

  @override
  void initState() {
    super.initState();

    ever(userController.userProfile, (callback) => _setFormData());

    userController.fetchSelfProfile();
  }

  void _setFormData() {
    User? user = userController.userProfile.value;

    if (user != null) {
      nameController.text = user.name ?? "";
      emailController.text = user.email ?? "";
      fullNameController.text = user.fullName ?? "";
      phoneController.text = user.phone ?? "";
      addressController.text = user.address ?? "";
      slackIdController.text = user.slackId ?? "";
      aboutController.text = user.about ?? "";
      birthdayController.text =
          user.birthday != null ? formatTime(user.birthday, "dd-MM-yyyy") : "";
      if (user.gender != null) {
        genderController.text = genderOptions.entries
            .firstWhere((entry) => entry.value == user.gender,
                orElse: () => const MapEntry('', ''))
            .key;
      }
    }
  }

  void _submit() async {
    SelfUpdateProfileInput profileForm = SelfUpdateProfileInput(
      about: nameController.text,
      slackId: slackIdController.text,
      address: addressController.text,
      phone: phoneController.text,
      fullName: fullNameController.text,
      birthday: birthdayController.text,
      gender: genderOptions[genderController.text] ?? '',
    );

    if (avatarController.text != "") {
      profileForm.avatarKey = avatarController.text;
    }

    bool result = await userController.updateProfile(profileForm);

    if (result) {
      setState(() {
        _isEditting = false;
      });
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
    birthdayController.dispose();
    genderController.dispose();
    avatarController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        birthdayController.text = formatTime(picked, "dd-MM-yyyy");
      });
    }
  }

  Future<void> _selectGender(BuildContext context) async {
    final selectedGender = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Gender'),
          children: genderOptions.entries.map((entry) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, entry.value);
              },
              child: Text(entry.key),
            );
          }).toList(),
        );
      },
    );

    // Use the selected value to update the controller
    if (selectedGender != null) {
      genderController.text = genderOptions.entries
          .firstWhere((entry) => entry.value == selectedGender,
              orElse: () => const MapEntry('', ''))
          .key;
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Update the user profile picture with the new image
        // For example, you might want to upload this file to a server, or you can directly display it
        // userController.updateUserProfileImage(pickedFile.path);
        var result = await FileUpload.upload(pickedFile);

        if (result != null) {
          setState(() {
            avatarController.text = result[0].key;
            userController.userProfile.value?.avatarUrl = result[0].url;
          });
        }
      }
    } catch (e) {
      // Handle errors or user cancellation
      print('Failed to pick image: $e');
    }
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
                    user: userController.userProfile.value,
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
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                            onPressed: _pickImage,
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
                children: _buildForm(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildForm(BuildContext context) {
    return <Widget>[
      _buildTextField(
        emailController,
        'Email',
        'Email',
        cantEdit: true,
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        nameController,
        'Name',
        'Name',
        cantEdit: true,
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        fullNameController,
        'Full Name',
        'FullName',
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        birthdayController,
        'Birthday',
        'Birthday',
        onSelectDate: _selectDate,
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        genderController,
        'Gender',
        'Gender',
        onSelectGender: _selectGender,
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        phoneController,
        'Phone',
        'Phone',
        type: TextInputType.phone,
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        addressController,
        'Address',
        'Address',
        maxLine: 2,
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        slackIdController,
        'Slack Id',
        'SlackId',
      ),
      const SizedBox(
        height: 20,
      ),
      _buildTextField(
        aboutController,
        'About',
        "About",
        maxLine: 3,
      ),
      const SizedBox(
        height: 20,
      ),
      _isEditting ? _buildSubmitBtn(context) : const SizedBox.shrink(),
    ];
  }

  ElevatedButton _buildSubmitBtn(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(
        Icons.save,
        color: Colors.white,
      ),
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
                  onPressed: () async {
                    Navigator.of(context).pop();

                    _submit();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        )
      },
    );
  }

  FormValidator _buildTextField(
    TextEditingController controller,
    String label,
    String errorKey, {
    bool cantEdit = false,
    int maxLine = 1,
    TextInputType type = TextInputType.text,
    DateSelector? onSelectDate,
    GenderSelector? onSelectGender,
  }) {
    return FormValidator(
      errorKey: errorKey,
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        autocorrect: false,
        maxLines: maxLine,
        style: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14.0,
            color: LightColors.kDarkBlue,
          ),
        ),
        decoration: generalInputDecoration(label, cantEdit),
        onTap: () => {
          if (onSelectDate != null)
            {onSelectDate(context)}
          else if (onSelectGender != null)
            {onSelectGender(context)}
        },
      ),
    );
  }

  InputDecoration generalInputDecoration(String label, bool cantEdit) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: cantEdit
          ? Colors.grey[300]
          : (_isEditting ? Colors.white : Colors.grey[300]),
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
    );
  }
}
