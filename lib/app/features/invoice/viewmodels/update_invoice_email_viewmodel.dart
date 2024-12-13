import 'package:MoreThanInvoice/app/features/invoice/views/add_update_invoice_email_view.dart';
import 'package:get/get.dart';

class UpdateInvoiceEmailViewModel extends GetxController {
  //final LoginModel _loginModel = Get.put(LoginModel());
  late final AddUpdateInvoicingEmailView _addUpdateInvoicingEmailView =
      Get.put(const AddUpdateInvoicingEmailView('', ''));
  final _user = ''.obs;
  late dynamic _admin_business_name = '';
  late dynamic _email = '';
  late dynamic _password = '';

  String get adminBusinessName => _admin_business_name;
  String get email => _email;
  String get password => _password;

  set adminBusinessName(String adminBusinessName) =>
      _admin_business_name = adminBusinessName;
  set email(String email) => _email = email;
  set password(String password) => _password = password;
  String get user => _user.value;

  set view(AddUpdateInvoicingEmailView view) {
    this.view = _addUpdateInvoicingEmailView;
  }

  set user(String value) => _user.value = value;

  UpdateInvoiceEmailViewModel() {
    _admin_business_name = adminBusinessName;
    _email = email;
    _password = password;
  }

  AddUpdateInvoicingEmailViewControllers(String email, String password) async {
    _admin_business_name = adminBusinessName;
    _email = email;
    _password = password;
  }

  // create the user object from json input
  UpdateInvoiceEmailViewModel.fromJson(Map<String, dynamic> json) {
    _admin_business_name = json['admin_business_name'] as String;
    _email = json['email'] as String;
    _password = json['password'] as String;
  }

  // exports to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['admin_business_name'] = _admin_business_name as String;
    data['email'] = _email as String;
    data['password'] = _password as String;
    return data;
  }
}
