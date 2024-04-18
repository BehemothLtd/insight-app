import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:insight_app/controllers/user_controller.dart';
// import 'package:insight_app/widgets/user/user_card.dart';
import 'package:insight_app/utils/custom_snackbar.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  UserScreenState createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  final userController = Get.put(UserController());
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

  void _resetScrollTimer() {
    _scrollTimer?.cancel(); // Cancel any existing timer
    _scrollTimer = Timer(const Duration(seconds: 2), () {
      setState(() => _showScrollToTopButton = false);
    });
  }

  // Load more projects when user scroll to bottom
  void _onScrollBottom() async {
    await userController.increasePage();

    try {
      await userController.fetchUsers(false);
      showCustomSnackbar(
        message: 'More Users Loaded',
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

  void _handleSearch() {
    setState(() {
      _isSearchPanelVisible = false;
    });

    // Trigger the search logic
    userController.resetPagy();
    userController.fetchUsers(true);
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
      if (userController.users.value?.isEmpty ?? true) {
        userController.fetchUsers(true);
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
    );
  }
}
