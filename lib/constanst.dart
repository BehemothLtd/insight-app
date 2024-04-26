// import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insight_app/theme/colors/light_colors.dart';

const SystemUiOverlayStyle SYSTEM_UI_STYLE = SystemUiOverlayStyle(
  systemNavigationBarColor: LightColors.kLightYellow,
  statusBarColor: LightColors.kLightYellow,
);

const companyLevels = [
  {
    "id": "1",
    "title": "Fresher",
    "color": LightColors.lGreen,
    // "color": 0xFF02FF00,
    // "icon": Icons.person_outline,
  },
  {
    "id": "2",
    "title": "Junior",
    "color": LightColors.lPurple,
    // "color": 0xFFD5A6BD,
    // "icon": Icons.verified_user,
  },
  {
    "id": "3",
    "title": "Middle",
    "color": LightColors.lCyan,
    // "color": 0xFF02FFFF,
    // "icon": Icons.supervisor_account,
  },
  {
    "id": "4",
    "title": "Senior",
    "color": LightColors.lOrange,
    // "color": 0xFFFF9900,
    // "icon": Icons.assignment_ind,
  }
];
