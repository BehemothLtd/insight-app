// Outer Libs
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Inner packages
import 'package:insight_app/constanst.dart';
import 'package:insight_app/controllers/auth_controller.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/widgets/home/attendance_box.dart';
import 'package:insight_app/widgets/home/leave_request_create.dart';
import 'package:insight_app/widgets/home/top_container.dart';
import 'package:insight_app/widgets/home/user_general_metrics.dart';
import 'package:insight_app/widgets/uis/side_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> onRefresh() async {
    // Refresh data on attendance
    attendanceBoxKey.currentState?.refreshData();

    // Refresh data on user
    _fetchSelfGeneralInfo();
  }

  // Key to reference the child component
  final GlobalKey<AttendanceBoxState> attendanceBoxKey = GlobalKey();

  // AuthController
  final AuthController authController = Get.find<AuthController>();

  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: LightColors.kDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  void _showBottomDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const LeaveRequestCreate();
      },
    );
  }

  void _fetchSelfGeneralInfo() {
    authController.fetchSelfGeneralInfo();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SYSTEM_UI_STYLE,
        toolbarHeight: 0,
      ),
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Obx(
                    () => HomeScreenTopContainer(
                      width: width,
                      currentUser: authController.currentUser.value,
                    ),
                  ),
                  Obx(
                    () => UserGeneralMetrics(
                      currentUser: authController.currentUser.value,
                    ),
                  ),
                  AttendanceBox(key: attendanceBoxKey),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Obx(
        () => SideDrawer(
          currentUser: authController.currentUser.value,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBottomDialog(context),
        backgroundColor: LightColors.kDarkYellow,
        // FAB is rounded by default
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
