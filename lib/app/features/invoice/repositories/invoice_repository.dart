import 'package:MoreThanInvoice/backend/api_method.dart';

class InvoiceRepository {
  final ApiMethod _apiMethod;

  InvoiceRepository(this._apiMethod);

  // Future<Map<String, dynamic>?> getAssignedClients() async {
  //   return await _apiMethod.getAssignedClients();
  // }

  Future<List<Map<String, dynamic>>> getLineItems() async {
    return await _apiMethod.getLineItems();
  }

  Future<List<String>> checkHolidaysSingle(List<String> dates) async {
    return await _apiMethod.checkHolidaysSingle(dates);
  }
}
