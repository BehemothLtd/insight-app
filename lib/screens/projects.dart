import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:insight_app/controllers/project_controller.dart';
import 'package:insight_app/utils/custom_snackbar.dart';
import 'package:insight_app/widgets/projects/project_card.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  ProjectsScreenState createState() => ProjectsScreenState();
}

class ProjectsScreenState extends State<ProjectsScreen> {
  final projectController = Get.put(ProjectController());
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTopButton = false;
  Timer? _scrollTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    bool isBottom = _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;

    if (_scrollController.position.pixels > 0) {
      if (!_showScrollToTopButton) {
        setState(() => _showScrollToTopButton = true);
      }
      _resetScrollTimer();
    } else {
      if (_showScrollToTopButton) {
        setState(() => _showScrollToTopButton = false);
      }
    }

    if (isBottom) {
      _onScrollBottom();
    }
  }

  void _onScrollBottom() async {
    await projectController.increasePage();

    try {
      await projectController.fetchProjects();
    } catch (e) {
      showCustomSnackbar(
        message: e.toString(),
        title: 'Info',
        backgroundColor: Colors.blue,
        iconData: Icons.warning,
      );
    }
  }

  void _resetScrollTimer() {
    _scrollTimer?.cancel(); // Cancel any existing timer
    _scrollTimer = Timer(const Duration(seconds: 2), () {
      setState(() => _showScrollToTopButton = false);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (projectController.projects.value?.isEmpty ?? true) {
        projectController.fetchProjects();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await projectController.resetParams();
              await projectController.fetchProjects();
            },
            child: Obx(() {
              var projects = projectController.projects.value;
              if (projects == null || projects.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(project: projects[index]);
                },
              );
            }),
          ),
          if (_showScrollToTopButton) ...[
            Positioned(
              right: 20.0,
              bottom: 20.0,
              child: FloatingActionButton(
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
