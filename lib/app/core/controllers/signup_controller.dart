import 'package:get/get.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/ui/views/signup_view.dart';

class SignupController extends GetxController {
  final LoginModel _loginModel = Get.put(LoginModel());
  late final SignUpView _signUpView = Get.put(SignUpView());

  late final dynamic _signUpUserFirstNameController;
  late final dynamic _signUpUserLastNameController;
  late final dynamic _signUpEmailController;
  late final dynamic _signUpPasswordController;
  late final dynamic _signUpConfirmPasswordController;
  late final dynamic _signupABNController;

  String get signUpUserFirstName => _signUpUserFirstNameController.text;
  String get signUpUserLastName => _signUpUserLastNameController.text;
  String get signUpEmail => _signUpEmailController.text;
  String get signUpPassword => _signUpPasswordController.text;
  String get signUpConfirmPassword => _signUpConfirmPasswordController.text;
  String get signupABN => _signupABNController.text;

  set signUpUserFirstName(String value) => _signUpUserFirstNameController.text = value;
  set signUpUserLastName(String value) => _signUpUserLastNameController.text = value;
  set signUpEmail(String value) => _signUpEmailController.text = value;
  set signUpPassword(String value) => _signUpPasswordController.text = value;
  set signUpConfirmPassword(String value) => _signUpConfirmPasswordController.text = value;
  set signupABN(String value) => _signupABNController.text = value;

  final _user = ''.obs;
  late dynamic _email = '';
  late dynamic _password = '';

  String get email => _email;
  String get password => _password;

  set email(String email) => _email = email;
  set password(String password) => _password = password;

  String get user => _user.value;

  set user(String value) => _user.value = value;

  SignupController() {
    _email = email;
    _password = password;
  }

  SignupControllers(String email, String password) async {
    _email = await email;
    _password = await password;
  }

  // create the user object from json input
  SignupController.fromJson(Map<String, dynamic> json) {
    _email = json['email'] as String;
    _password = json['password'] as String;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this._email as String;
    data['password'] = this._password as String;
    return data;
  }
}
