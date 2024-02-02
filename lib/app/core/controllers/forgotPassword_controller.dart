import 'package:get/get.dart';
import 'package:MoreThanInvoice/app/ui/views/forgot_password_view.dart';

class ForgotPasswordController extends GetxController {
  late final ForgotPasswordView _loginView =
      Get.put(const ForgotPasswordView());
  final _user = ''.obs;
  late dynamic _email = '';
  String get email => _email;
  set email(String email) => _email = email;
  String get user => _user.value;

  set view(ForgotPasswordView view) {
    this.view = _loginView;
  }

  set user(String value) => _user.value = value;

  ForgotPasswordController() {
    _email = email;
  }

  // create the user object from json input
  ForgotPasswordController.fromJson(Map<String, dynamic> json) {
    _email = json['email'] as String;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email as String;
    return data;
  }
}
