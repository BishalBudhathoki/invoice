part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const login = '/login';
  static const signup = '/signup';
  static const home = "/home";
  static const addClientDetails = "/home/addClientDetails";
  static const addBusinessDetails = "/home/addBusinessDetails";
  static const displayClientDetails = "/popUpClientDetails";
  static const profileView = "/profile/view";
  static const profileEdit = "/profile/edit";
  static const changePassword = "/profile/change_password";
}
