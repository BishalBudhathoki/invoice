import 'package:get/get.dart';
import 'package:invoice/app/ui/views/login_view.dart';

class LoginController extends GetxController {
  //final LoginModel _loginModel = Get.put(LoginModel());
  late final LoginView _loginView = Get.put(const LoginView());
  final _user = ''.obs;
  late dynamic _email = '';
  late dynamic _password = '';
  String get email => _email;
  String get password => _password;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  String get user => _user.value;

  // set model(LoginModel model) {
  //   this.model = _loginModel;
  // }

  set view(LoginView view) {
    this.view = _loginView;
  }

  set user(String value) => _user.value = value;

  // LoginController( ) {
  //   _user.value = '';
  //   _password.value = '';
  // }

  LoginController() {
    _email = email;
    _password = password;
  }

  LoginControllers(String email, String password) async {
    _email = email;
    _password = password;
  }
  //get set methods for email and password

  // create the user object from json input
  LoginController.fromJson(Map<String, dynamic> json) {
    _email = json['email'] as String;
    _password = json['password'] as String;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email as String;
    data['password'] = _password as String;
    return data;
  }
}
