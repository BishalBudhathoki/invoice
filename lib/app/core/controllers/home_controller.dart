import 'package:get/get.dart';

class HomeController extends GetxController {
  late dynamic _email = '';
  String get email => _email;
  set email(String email) => _email = email;

  HomeController() {
    _email = email;
  }

  // create the user object from json input
  HomeController.fromJson(Map<String, dynamic> json) {
    _email = json['email'] as String;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = _email as String;
    return data;
  }
}
