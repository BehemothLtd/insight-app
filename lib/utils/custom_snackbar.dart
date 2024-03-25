import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackbar({
  String? title,
  String? message,
  Color? backgroundColor,
  IconData? iconData,
  Color? iconColor,
}) {
  Get.snackbar(
    title ?? "Info",
    message ?? "",
    backgroundColor: backgroundColor ?? Colors.green,
    icon: Icon(
      iconData ?? Icons.info,
      color: iconColor ?? Colors.white,
    ),
    colorText: Colors.white,
    duration: const Duration(seconds: 2),
  );
}
