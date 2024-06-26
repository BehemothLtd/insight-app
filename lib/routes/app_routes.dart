part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const signIn = _Paths.signIn;
  static const home = _Paths.home;
  static const projects = _Paths.projects;
  static const profile = _Paths.profile;
  static const users = _Paths.users;
  static const leaveRequest = _Paths.leaveRequest;
}

class _Paths {
  static const signIn = "/sign_in";
  static const home = "/home";
  static const projects = "/projects";
  static const profile = "/profile";
  static const users = "/users";
  static const leaveRequest = "/leave_requests";
}
