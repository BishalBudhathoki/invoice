import 'package:get/get.dart';
import 'package:invoice/backend/api_method.dart';


class LineItemController extends GetxController {
  List<Map<String, dynamic>> _lineItems = [];

  List<Map<String, dynamic>> get lineItems => _lineItems;

  @override
  void onInit() {
    super.onInit();
    getLineItems();
  }

  Future<void> getLineItems() async {
    try {
      final List<Map<String, dynamic>> lineItems =
      await ApiMethod().getLineItems();
      print("Line items from controller:::::: \n $lineItems");
      _lineItems = lineItems;
      update();
    } catch (e) {
      print('Failed to get line items: $e');
    }
  }
}
