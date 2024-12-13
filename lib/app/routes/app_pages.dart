import 'package:MoreThanInvoice/app/features/home/views/home_view.dart';
import 'package:MoreThanInvoice/app/features/auth/views/login_view.dart';
import 'package:MoreThanInvoice/app/features/auth/views/signup_view.dart';
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
