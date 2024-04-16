import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:insight_app/controllers/project_controller.dart';
import 'package:insight_app/theme/colors/light_colors.dart';
import 'package:insight_app/utils/custom_snackbar.dart';
import 'package:insight_app/widgets/projects/project_card.dart';
import 'package:insight_app/widgets/projects/projects_filter.dart';

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

  bool _isSearchPanelVisible = false;

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

  // Load more projects when user scroll to bottom
  void _onScrollBottom() async {
    await projectController.increasePage();

    try {
      await projectController.fetchProjects(false);
      showCustomSnackbar(
        message: 'More Projects Loaded',
        title: 'Notice',
        backgroundColor: Colors.blue,
        iconData: Icons.info,
        duration: 1,
      );
    } catch (e) {
      showCustomSnackbar(
        message: e.toString(),
        title: 'Info',
        backgroundColor: Colors.blue,
        iconData: Icons.warning,
        duration: 1,
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
        projectController.fetchProjects(true);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => RotationTransition(
                turns: child.key == const ValueKey('icon1')
                    ? Tween<double>(begin: 1, end: 0.75).animate(anim)
                    : Tween<double>(begin: 0.75, end: 1).animate(anim),
                child: FadeTransition(opacity: anim, child: child),
              ),
              child: _isSearchPanelVisible
                  ? const Icon(Icons.search_off, key: ValueKey('icon1'))
                  : const Icon(
                      Icons.search,
                      key: ValueKey('icon2'),
                    ),
            ),
            onPressed: () {
              setState(() {
                _isSearchPanelVisible = !_isSearchPanelVisible;
              });
            },
          )
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await projectController.resetPagy();
              await projectController.resetParams();

              await projectController.fetchProjects(true);
              showCustomSnackbar(
                message: 'Projects Refreshed',
                title: 'Notice',
                backgroundColor: Colors.blue,
                iconData: Icons.info,
                duration: 1,
              );
            },
            child: Obx(() {
              var projects = projectController.projects.value;

              if (projects == null || projects.isEmpty) {
                return const Center(
                  child: Text("No Projects"),
                );
              } else {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    return ProjectCard(project: projects[index]);
                  },
                );
              }
            }),
          ),
          if (_showScrollToTopButton) ...[
            Positioned(
              right: 20.0,
              bottom: 20.0,
              child: FloatingActionButton(
                backgroundColor: LightColors.kDarkYellow,
                onPressed: _scrollToTop,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
          ],
          _buildSearchPanel(),
        ],
      ),
    );
  }

  void _handleSearch() {
    setState(() {
      _isSearchPanelVisible = false;
    });

    // Trigger the search logic
    projectController.resetPagy();
    projectController.fetchProjects(true);
  }

  Widget _buildSearchPanel() {
    if (_isSearchPanelVisible) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Align(
          alignment: Alignment.center,
          child: ProjectsFilter(
            onSearch: _handleSearch,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
