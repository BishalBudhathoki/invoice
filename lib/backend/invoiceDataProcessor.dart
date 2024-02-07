import 'package:MoreThanInvoice/app/core/controllers/lineItem_controller.dart';
import 'package:MoreThanInvoice/backend/invoiceHelpers.dart';
import 'package:get/get.dart';

class InvoiceDataProcessor {
  final LineItemController lineItemController = Get.put(LineItemController());
  final InvoiceHelpers helpers = InvoiceHelpers();

  List<String> invoiceName = [];
  String endDate = '';
  String invoiceNumber = '';

  Future<Map<String, dynamic>> processInvoiceData(Map<String, dynamic>? assignedClients, {bool applyTax = true}) async {
    if (assignedClients == null) {
      throw Exception('No assigned clients data');
    }

    print('Processing assigned clients data');

    await lineItemController.getLineItems();
    final List<Map<String, dynamic>> lineItems = lineItemController.lineItems;

    Map<String, String> itemMap = _createItemMap(lineItems);
    List<Map<String, dynamic>> processedClients = [];

    final userDocs = assignedClients['userDocs'] as List<dynamic>? ?? [];
    for (var userDocItem in userDocs) {
      final docs = userDocItem['docs'] as List<dynamic>? ?? [];
      for (var doc in docs) {
        if (doc is Map<String, dynamic>) {
          Map<String, dynamic> clientData = _processClientData(doc, assignedClients['clientDetail'] as List<dynamic>? ?? [], itemMap, applyTax);
          processedClients.add(clientData);
        }
      }
    }

    _setInvoiceDetails(assignedClients);

    print('Finished processing invoice data');

    return {
      'clients': processedClients,
      'invoiceName': invoiceName,
      'endDate': endDate,
      'invoiceNumber': invoiceNumber,
    };
  }

  Map<String, String> _createItemMap(List<Map<String, dynamic>> lineItems) {
    Map<String, String> itemMap = {};
    for (var item in lineItems) {
      itemMap[item['itemDescription'] ?? ''] = item['itemNumber'] ?? '';
    }
    return itemMap;
  }

  Map<String, dynamic> _processClientData(Map<String, dynamic> doc, List<dynamic> clientDetails, Map<String, String> itemMap, bool applyTax) {
    Map<String, dynamic> clientData = {};

    clientData['clientEmail'] = doc['clientEmail'] ?? '';
    clientData['invoiceNumber'] = 'INV-${DateTime.now().millisecondsSinceEpoch}';

    var clientDetail = clientDetails.firstWhere(
          (detail) => detail['clientEmail'] == clientData['clientEmail'],
      orElse: () => <String, dynamic>{},
    );

    clientData['clientName'] = '${clientDetail['clientFirstName'] ?? ''} ${clientDetail['clientLastName'] ?? ''}';
    clientData['billingAddress'] = '${clientDetail['clientAddress'] ?? ''}, ${clientDetail['clientCity'] ?? ''}, ${clientDetail['clientState'] ?? ''} ${clientDetail['clientZip'] ?? ''}';
    clientData['shippingAddress'] = clientData['billingAddress'];

    List<String> dateList = List<String>.from(doc['dateList'] ?? []);
    List<String> startTimeList = List<String>.from(doc['startTimeList'] ?? []);
    List<String> endTimeList = List<String>.from(doc['endTimeList'] ?? []);
    List<String> timeList = List<String>.from(doc['Time'] ?? []);

    List<String> dayOfWeek = helpers.findDayOfWeek(dateList);
    List<double> totalHours = helpers.calculateTotalHours(startTimeList, endTimeList, timeList);
    List<double> rate = helpers.getRate(dayOfWeek, []);

    List<Map<String, dynamic>> items = [];
    for (int i = 0; i < dateList.length; i++) {
      String timePeriod = helpers.getTimePeriod(startTimeList[i]);
      String itemName = '${dayOfWeek[i]} $timePeriod';
      String itemCode = itemMap[itemName] ?? '';

      items.add({
        'date': dateList[i],
        'day': dayOfWeek[i],
        'startTime': startTimeList[i],
        'endTime': endTimeList[i],
        'hours': totalHours[i],
        'rate': rate[i],
        'amount': totalHours[i] * rate[i],
        'itemName': itemName,
        'itemCode': itemCode,
      });
    }

    clientData['items'] = items;

    double subtotal = items.fold(0, (sum, item) => sum + (item['amount'] as double));
    clientData['subtotal'] = subtotal;

    if (applyTax) {
      clientData['tax'] = subtotal * 0.05; // Assuming 5% tax
      clientData['total'] = subtotal + clientData['tax'];
    } else {
      clientData['tax'] = 0.0;
      clientData['total'] = subtotal;
    }

    return clientData;
  }

  void _setInvoiceDetails(Map<String, dynamic> assignedClients) {
    final userDocs = assignedClients['userDocs'] as List<dynamic>? ?? [];
    if (userDocs.isNotEmpty) {
      final docs = userDocs[0]['docs'] as List<dynamic>? ?? [];
      if (docs.isNotEmpty) {
        final firstDoc = docs[0] as Map<String, dynamic>? ?? {};
        invoiceName = [firstDoc['clientEmail'] ?? ''];
        endDate = firstDoc['dateList']?.isNotEmpty == true ? firstDoc['dateList'][0] : '';
        invoiceNumber = 'INV-${DateTime.now().millisecondsSinceEpoch}';
      }
    }
  }
}