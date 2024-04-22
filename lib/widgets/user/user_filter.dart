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

  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(Icons.search, color: Colors.blue),
            SizedBox(width: 10),
            Text("Search",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
          ],
        ),
        titlePadding: const EdgeInsets.fromLTRB(23.0, 24.0, 24.0, 0),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 20.0,
        ),
        content: SingleChildScrollView(
          child: Form(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onChanged: (value) {
                  userController.usersQuery.update((val) {
                    val?.nameCont = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onChanged: (value) {
                  userController.usersQuery.update((val) {
                    val?.fullNameCont = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onChanged: (value) {
                  userController.usersQuery.update((val) {
                    val?.emailCont = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: slackIdController,
                decoration: InputDecoration(
                  labelText: 'Slack Id',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                onChanged: (value) {
                  userController.usersQuery.update((val) {
                    val?.slackIdLike = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: stateController.text.isNotEmpty
                    ? stateController.text
                    : null,
                decoration: InputDecoration(
                  labelText: 'State',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  stateController.text = value ?? '';

                  userController.usersQuery.update((val) {
                    val?.stateEq = value ?? '';
                  });
                },
                items: const [
                  DropdownMenuItem(value: null, child: Text('Both')),
                  DropdownMenuItem(value: 'active', child: Text('Active')),
                  DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
                ],
              ),
            ]),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              nameController.clear();
              fullNameController.clear();
              emailController.clear();
              slackIdController.clear();
              stateController.clear();

              userController.resetParams();
              setState(() {});
            },
            child: const Text(
              'Clear',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onSearch();
            },
            child: Text(
              'Search',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ]);
  }
}
