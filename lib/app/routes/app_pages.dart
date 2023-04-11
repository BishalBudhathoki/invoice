import 'package:invoice/app/ui/views/home_view.dart';
import 'package:invoice/app/ui/views/login_view.dart';
import 'package:invoice/app/ui/views/signup_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    const LoginView(),
    HomeView(
      email: '',
    ),
    const SignUpView(),
    //SignupPage(),
  ];
}
