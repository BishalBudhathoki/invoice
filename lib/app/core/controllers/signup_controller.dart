import 'package:get/get.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/ui/views/signup_view.dart';

class SignupController extends GetxController {
  //final LoginModel _loginModel = Get.put(LoginModel());
  late final SignUpView _signUpView = Get.put(SignUpView());
  final _user = ''.obs;
  late dynamic _email='';
  late dynamic _password='';
  String get email => _email;
  String get password => _password;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  String get user => _user.value;


  // set model(LoginModel model) {
  //   this.model = _loginModel;
  // }

  set view(SignUpView view) {
    this.view = _signUpView;
  }

  set user(String value) => _user.value = value;


  // LoginController( ) {
  //   _user.value = '';
  //   _password.value = '';
  // }


  SignupController() {
    _email =  email;
    _password =  password;
  }

  SignupControllers(String email, String password) async {
    _email = await email;
    _password = await password;
  }
  //get set methods for email and password


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