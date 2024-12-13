class InvoiceModel {
  final String clientName;
  final String clientEmail;
  final String clientPhone;
  final List<String> clientAddress;
  final String clientBusinessName;
  final List<String> dateList;
  final List<String> startTimeList;
  final List<String> endTimeList;
  final List<String> breakList;
  final List<String> timeList;
  final double totalAmount;
  final String invoiceNumber;

  InvoiceModel({
    required this.clientName,
    required this.clientEmail,
    required this.clientPhone,
    required this.clientAddress,
    required this.clientBusinessName,
    required this.dateList,
    required this.startTimeList,
    required this.endTimeList,
    required this.breakList,
    required this.timeList,
    required this.totalAmount,
    required this.invoiceNumber,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      clientName: "${json['clientFirstName']} ${json['clientLastName']}",
      clientEmail: json['clientEmail'] ?? '',
      clientPhone: json['clientPhone'] ?? '',
      clientAddress: [
        json['clientAddress'] ?? '',
        json['clientCity'] ?? '',
        json['clientState'] ?? '',
        json['clientZip'] ?? ''
      ],
      clientBusinessName: json['clientBusinessName'] ?? '',
      dateList: List<String>.from(json['dateList'] ?? []),
      startTimeList: List<String>.from(json['startTimeList'] ?? []),
      endTimeList: List<String>.from(json['endTimeList'] ?? []),
      breakList: List<String>.from(json['breakList'] ?? []),
      timeList: List<String>.from(json['Time'] ?? []),
      totalAmount: 0.0, // Calculate this based on your business logic
      invoiceNumber: 'INV-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientName': clientName,
      'clientEmail': clientEmail,
      'clientPhone': clientPhone,
      'clientAddress': clientAddress,
      'clientBusinessName': clientBusinessName,
      'dateList': dateList,
      'startTimeList': startTimeList,
      'endTimeList': endTimeList,
      'breakList': breakList,
      'timeList': timeList,
      'totalAmount': totalAmount,
      'invoiceNumber': invoiceNumber,
    };
  }
}
