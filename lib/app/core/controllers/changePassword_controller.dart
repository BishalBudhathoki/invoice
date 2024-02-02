import 'package:get/get.dart';
import 'package:MoreThanInvoice/app/ui/views/changePassword_view.dart';

class ChangePasswordController extends GetxController {
  late final ChangePasswordView _changePasswordView =
      Get.put(const ChangePasswordView());
  final _user = ''.obs;
  //late dynamic _email = '';
  late dynamic _password = '';
  late dynamic _confirmPassword = '';
  //String get email => _email;
  String get password => _password;
  String get confirmPassword => _confirmPassword;
  //set email(String email) => _email = email;
  set password(String password) => _password = password;
  set confirmPassword(String confirmPassword) =>
      _confirmPassword = confirmPassword;
  String get user => _user.value;

  set view(ChangePasswordView view) {
    this.view = _changePasswordView;
  }

  set user(String value) => _user.value = value;

  ChangePasswordController() {
    //  _email = email;
    _password = password;
    _confirmPassword = confirmPassword;
  }

  //get set methods for email and password

  // create the user object from json input
  ChangePasswordController.fromJson(Map<String, dynamic> json) {
    // _email = json['email'] as String;
    _password = json['password'] as String;
    _confirmPassword = json['confirmPassword'] as String;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['email'] = _email as String;
    data['password'] = _password as String;
    data['confirmPassword'] = _confirmPassword as String;
    return data;
  }
}
