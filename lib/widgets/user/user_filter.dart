import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:insight_app/controllers/user_controller.dart';

class UsersFilter extends StatefulWidget {
  const UsersFilter({
    super.key,
    required this.onSearch,
  });

  final VoidCallback onSearch;

  @override
  State<UsersFilter> createState() => _UsersFilterState();
}

class _UsersFilterState extends State<UsersFilter> {
  late TextEditingController nameController;
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController stateController;
  late TextEditingController slackIdController;

  final userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();

    nameController =
        TextEditingController(text: userController.usersQuery.value?.nameCont);
    fullNameController = TextEditingController(
        text: userController.usersQuery.value?.fullNameCont);
    emailController =
        TextEditingController(text: userController.usersQuery.value?.emailCont);
    stateController =
        TextEditingController(text: userController.usersQuery.value?.stateEq);
    slackIdController = TextEditingController(
        text: userController.usersQuery.value?.slackIdLike);
  }

  // @override
  // Widget build(BuildContext context) {
  //   final UserController = Get.find<UserController>();

  //   return
  // }
}
