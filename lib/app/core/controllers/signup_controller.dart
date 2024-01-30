import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:invoice/app/core/view-models/login_model.dart';
import 'package:invoice/app/ui/views/signup_view.dart';

class SignupController extends GetxController {
  final LoginModel _loginModel = Get.put(LoginModel());
  late final SignUpView _signUpView = Get.put(const SignUpView());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  set signUpUserFirstName(String value) =>
      _signUpUserFirstNameController.text = value;

  set signUpUserLastName(String value) =>
      _signUpUserLastNameController.text = value;

  set signUpEmail(String value) => _signUpEmailController.text = value;

  set signUpPassword(String value) => _signUpPasswordController.text = value;

  set signUpConfirmPassword(String value) =>
      _signUpConfirmPasswordController.text = value;

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

  set view(SignUpView view) {
    this.view = _signUpView;
  }

  SignupController() {
    _email = email;
    _password = password;
  }

  Future<bool> signupUser(String firstName, String lastName, String email,
      String password, String abn, String role) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Ensure "users" collection exists
      CollectionReference usersCollection = _firestore.collection('users');
      if (!(await usersCollection.doc(userCredential.user!.uid).get()).exists) {
        usersCollection.doc(userCredential.user!.uid);
      }

      // Store additional user data in Firestore
      String userId = userCredential.user!.uid;
      await usersCollection.doc(userId).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'abn': abn,
        'role': role,
      }); // Explicitly cast the map to the desired type

      return true;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  signupControllers(String email, String password) async {
    _email = email;
    _password = password;
  }

  // create the user object from json input
  SignupController.fromJson(Map<String, dynamic> json) {
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
