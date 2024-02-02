import 'package:MoreThanInvoice/app/ui/views/home_view.dart';
import 'package:MoreThanInvoice/app/ui/views/login_view.dart';
import 'package:MoreThanInvoice/app/ui/views/signup_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    const LoginView(),
    const HomeView(
      email: '',
    ),
    const SignUpView(),
    //SignupPage(),
  ];
}
