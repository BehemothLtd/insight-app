import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:insight_app/controllers/project_controller.dart';
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
