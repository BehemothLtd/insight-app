// Outer libs
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Inner packages
import 'package:insight_app/controllers/global_controller.dart';

class FormValidator extends StatelessWidget {
  final Widget child;
  final String errorKey;

  const FormValidator({
    super.key,
    required this.child,
    required this.errorKey,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalController globalController = Get.put(GlobalController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child, // Directly include the child without padding
        Obx(() {
          var fieldErrors = globalController.errors[errorKey];
          if (fieldErrors != null && fieldErrors.isNotEmpty) {
            // Use a Column to display all error messages
            return Padding(
              padding: const EdgeInsets.only(top: 5), // Set padding to 5px
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: fieldErrors
                    .map((error) => Text(
                          error,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ))
                    .toList(),
              ),
            );
          } else {
            return const SizedBox.shrink(); // No errors, don't display anything
          }
        }),
      ],
    );
  }
}
