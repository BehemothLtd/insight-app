import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter_dotenv/flutter_dotenv.dart";

import "package:insight_app/controllers/auth_controller.dart";
import "package:insight_app/controllers/global_controller.dart";
import "package:insight_app/routes/app_pages.dart";
import "package:insight_app/utils/custom_snackbar.dart";
import "package:insight_app/utils/helpers.dart";

class ApiProvider extends GetxController {
  Future<dynamic> request({
    required String query,
    required dynamic variables,
    bool signInRequired = true,
  }) async {
    final AuthController authController = Get.find<AuthController>();
    final GlobalController globalController = Get.put(GlobalController());

    Uri url = Uri.parse('${dotenv.env["API_BASE_URL"]}/insightGql');

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      if (signInRequired) {
        var token = authController.token;
        headers['BhmAIO-Authorization'] =
            token.value != null ? 'Bearer ${token.value}' : "";
      }

      var response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'query': query,
          'variables': variables,
        }),
      );

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes));
        if (decodedResponse is! Map<String, dynamic>) {
          return;
        }

        List<dynamic>? errors = decodedResponse['errors'];

        if (errors != null && errors.isNotEmpty) {
          var mainErr = errors[0];
          if (mainErr is! Map<String, dynamic>) {
            return;
          }

          var extensions = mainErr['extensions'];

          if (extensions is! Map<String, dynamic>) {
            return;
          }

          // Error handler
          var errorCode = extensions['code'];

          if (errorCode is! int) {
            return;
          }

          Map<String, List<String>> errorDetails =
              convertToSafeMap(mainErr['extensions']['errors']);

          if (errorCode == 422) {
            globalController.setErrors(errorDetails);

            showCustomSnackbar(
              message: "Error Happened",
              title: 'Warning',
              backgroundColor: Colors.redAccent,
              iconData: Icons.warning,
            );
          } else if (errorCode == 401) {
            showCustomSnackbar(
              message: "You need to sign in",
              title: 'Warning',
              backgroundColor: Colors.redAccent,
              iconData: Icons.warning,
            );

            Get.close(1);
            Get.toNamed(Routes.signIn);
          } else {
            if (mainErr['message'] != "") {
              showCustomSnackbar(
                message: mainErr['message'],
                title: "Error Happened",
                backgroundColor: Colors.redAccent,
                iconData: Icons.warning,
              );
            }
          }
        } else {
          var data = decodedResponse['data'];

          return data;
        }
      } else if (response.statusCode == 500) {
        showCustomSnackbar(
          message: "SERVER ERROR",
          title: "Error Happened",
          backgroundColor: Colors.redAccent,
          iconData: Icons.warning,
          duration: 5,
        );
        return null;
      }
    } catch (e) {
      showCustomSnackbar(
        message: e.toString(),
        title: "Error Happened",
        backgroundColor: Colors.redAccent,
        iconData: Icons.warning,
        duration: 5,
      );

      return null;
    }
  }
}
