import 'package:MoreThanInvoice/app/features/auth/models/user_role.dart';
import 'package:MoreThanInvoice/app/features/photo/viewmodels/photoData_viewModel.dart';
import 'package:MoreThanInvoice/app/shared/widgets/bottom_navBar_widget.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/auth/models/login_model.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginModel model = LoginModel();
  final ApiMethod apiMethod = ApiMethod();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    void _handleLoginError(BuildContext context, String message) {
      String errorMessage;
      switch (message) {
        case 'User not found':
          errorMessage = "User not found. Please Sign up!";
          break;
        case 'Wrong password':
          errorMessage = "Wrong password. Please check your password!";
          break;
        case 'Invalid Email':
          errorMessage = "Email not found or invalid. Please check your email!";
          break;
        default:
          errorMessage = "Error at login!";
      }
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the warning dialog
                },
              ),
            ],
          );
        },
      );
    }

    debugPrint('Form valid: ${formKey.currentState!.validate()}');
    if (formKey.currentState!.validate()) {
      await Future.delayed(const Duration(seconds: 2));
// Show loading dialog
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return const Center(child: CircularProgressIndicator());
      //   },
      // );
      debugPrint(
          "email: ${model.emailController.text} ${model.passwordController.text}");
      final response = await apiMethod.login(
        model.emailController.text.toLowerCase().trim(),
        model.passwordController.text.trim(),
      );

      Navigator.of(context).pop(); // Close the loading dialog

      if (response != null && response.containsKey('message')) {
        if (response['message'] == 'user found') {
          String roleString = response['role']; // Get the role as a string
          UserRole enumRole;
// Get the PhotoData provider
          final photoDataProvider =
              Provider.of<PhotoData>(context, listen: false);

          // Load the photo data with the user's email
          await photoDataProvider
              .loadPhotoData(model.emailController.text.trim());
          // Convert the string to UserRole enum
          if (roleString == 'admin') {
            enumRole = UserRole.admin;
          } else {
            enumRole = UserRole.normal; // Default to normal if not admin
          }
          debugPrint("User is $enumRole, ${model.emailController.text}");

          // After login logic
          _isLoading = false;
          notifyListeners();

          // Navigate to the appropriate home view based on role
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBarWidget(
                email: model.emailController.text.toLowerCase().trim(),
                role: enumRole, // Pass the role to the BottomNavBarWidget
              ),
            ),
          );
        } else {
          debugPrint("User is ${model.emailController.text}");
          // Handle other messages (e.g., user not found, wrong password)
          _handleLoginError(context, response['message']);
        }
      }
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    model.dispose(); // Dispose of the model's controllers
    super.dispose();
  }
}
