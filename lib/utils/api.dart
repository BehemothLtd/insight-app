import "package:flutter/material.dart";
import "package:get/get.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';
import "package:flutter_dotenv/flutter_dotenv.dart";

import "package:insight_app/controllers/auth_controller.dart";
import "package:insight_app/controllers/global_controller.dart";
import "package:insight_app/utils/custom_snackbar.dart";
import "package:insight_app/utils/helpers.dart";

class ApiProvider extends GetxController {
  Future<dynamic> request({
    required String query,
    required dynamic variables,
    bool signInRequired = true,
  }) async {
    final AuthController authController = Get.put(AuthController());
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
        var decodedResponse = json.decode(utf8.decode(response.bodyBytes))
            as Map<String, dynamic>;

        var errors = decodedResponse['errors'];

        if (errors != null && errors.length > 0) {
          // Error handler
          var errorCode = errors[0]['extensions']['code'];
          Map<String, List<String>> errorDetails =
              convertToSafeMap(errors[0]['extensions']['errors']);

          if (errorCode == 422) {
            globalController.setErrors(errorDetails);

            showCustomSnackbar(
              message: "Error Happened",
              title: 'Warning',
              backgroundColor: Colors.blue,
              iconData: Icons.warning,
            );
          }
        } else {
          var data = decodedResponse['data'];

          return data;
        }
      } else if (response.statusCode == 500) {
        return null;
      }
    } catch (e) {
      print(e);

      return null;
    }
  }
}
