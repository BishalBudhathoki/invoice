import 'package:flutter/cupertino.dart';

class InvoiceEmailViewModel extends ChangeNotifier {
  bool isResponseReceived = false;
  bool isLoading = false;

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setIsResponseReceived(bool value) {
    isResponseReceived = value;
    notifyListeners();
  }
}
