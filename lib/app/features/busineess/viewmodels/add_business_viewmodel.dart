import 'package:MoreThanInvoice/app/shared/widgets/popupClientDetails.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';

class AddBusinessViewModel extends ChangeNotifier {
  final ApiMethod apiMethod = ApiMethod();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessEmailController = TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController businessAddressController =
      TextEditingController();
  final TextEditingController businessCityController = TextEditingController();
  final TextEditingController businessStateController = TextEditingController();
  final TextEditingController businessZipController = TextEditingController();

  Future<void> addBusiness(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // Show alert dialog
      showAlertDialog(context);
      final response = await _addBusiness();
      if (response == "success") {
        Navigator.of(context, rootNavigator: true).pop();
        popUpClientDetails(context, "success", "Business");
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        popUpClientDetails(context, "error", "Business");
      }
    }
  }

  Future<dynamic> _addBusiness() async {
    var ins = await apiMethod.addBusiness(
      businessNameController.text,
      businessEmailController.text,
      businessPhoneController.text,
      businessAddressController.text,
      businessCityController.text,
      businessStateController.text,
      businessZipController.text,
    );
    return ins['message'];
  }

  @override
  void dispose() {
    businessNameController.dispose();
    businessEmailController.dispose();
    businessPhoneController.dispose();
    businessAddressController.dispose();
    businessCityController.dispose();
    businessStateController.dispose();
    businessZipController.dispose();
    super.dispose();
  }

  // Add this method to show an alert dialog
  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Processing"),
          content: CircularProgressIndicator(),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
