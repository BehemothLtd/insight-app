import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:insight_app/controllers/global_controller.dart';

class FormValidator extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final String errorKey;

  const FormValidator({
    super.key,
    required this.child,
    required this.errorKey,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.put(GlobalController());

    return Column(
      children: [
        Container(
          padding: padding,
          child: child,
        ),
        Obx(() {
          var fieldErrors = globalController.errors[errorKey];
          // Ensure fieldErrors is not null and has elements before building the ListView
          if (fieldErrors != null && fieldErrors.isNotEmpty) {
            return ListView.builder(
              shrinkWrap: true, // Add shrinkWrap to true for nested ListViews
              physics:
                  const NeverScrollableScrollPhysics(), // Disable scrolling within the ListView
              itemCount: fieldErrors.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(fieldErrors[index]),
                );
              },
            );
          } else {
            return const SizedBox
                .shrink(); // Return an empty widget when there are no errors
          }
        }),
      ],
    );
  }
}
