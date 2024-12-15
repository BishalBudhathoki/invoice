import 'dart:io';
import 'package:MoreThanInvoice/app/di/service_locator.dart';
import 'package:MoreThanInvoice/app/features/invoice/services/invoice_email_service.dart';
import 'package:MoreThanInvoice/app/core/utils/Services/storagePermissionHandler.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/flushbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:MoreThanInvoice/app/features/invoice/viewmodels/line_items_viewmodel.dart';
import 'package:MoreThanInvoice/app/features/invoice/viewmodels/invoice_email_viewmodel.dart';
import 'package:MoreThanInvoice/app/shared/utils/pdf/pdf_viewer.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:MoreThanInvoice/app/features/invoice/services/download_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GenerateInvoiceForAllUser extends StatefulWidget {
  final String email;
  final String genKey;
  const GenerateInvoiceForAllUser(this.email, this.genKey, {super.key});

  @override
  _GenerateInvoiceForAllUserState createState() =>
      _GenerateInvoiceForAllUserState();
}

class _GenerateInvoiceForAllUserState extends State<GenerateInvoiceForAllUser> {
  bool _storagePermissionGranted = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mediaStorePlugin = MediaStore();
  ApiMethod apiMethod = ApiMethod();
  PageController _pageController = PageController();

  String? path;
  late String _pdfPath = '';

  String get pdfPath => _pdfPath;

  set pdfPaths(String newPath) {
    _pdfPath = newPath;
  }

  late File files;
  bool hasGeneratedPDFs = false;
  final List<String> invoiceName = [];
  final List<String> invoiceABN = [];
  final List<String> invoicePeriodStart = [];
  final List<String> invoicePeriodEnd = [];
  final List<String> invoiceTotalAmount = [];
  List<dynamic> startDateList = [];
  List<dynamic> endDateList = [];
  List<DateTime> dates = [];
  String startDate = '';
  String endDate = '';
  String invoiceNumber = '';
  List<String> results = [];
  Future<List<String>>? _generateInvoiceFuture;
  int _platformSDKVersion = 0;

  Map<String, String> itemMap = {
    'Default': 'Item Map',
  };

  Map<String, List<Map<String, dynamic>>> emailClientMap = {};
  Map<String, List<List<String>>> clientData = {};

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _generateInvoiceFuture = generateInvoiceForAllUser();
    _checkStoragePermission();
  }

  Future<void> _checkStoragePermission() async {
    final storagePermissionHandler = StoragePermissionHandler();
    _storagePermissionGranted =
        await storagePermissionHandler.checkAndRequestStoragePermission();
  }

  Future<void> initPlatformState() async {
    int platformSDKVersion;
    try {
      platformSDKVersion = await mediaStorePlugin.getPlatformSDKInt() ?? 0;
    } on PlatformException {
      platformSDKVersion = -1;
    }

    if (!mounted) return;

    setState(() {
      _platformSDKVersion = platformSDKVersion;
    });
  }

  @override
  void dispose() {
    _pageController.dispose(); // Dispose of the controller
    super.dispose();
  }

  Future<List<String>> generateInvoiceForAllUser() async {
    final LineItemViewModel lineItemController = Get.put(LineItemViewModel());
    await lineItemController.getLineItems();
    final List<Map<String, dynamic>> lineItems = lineItemController.lineItems;
    final assignedClients = await apiMethod.getAssignedClients();
    List<String> generatedPdfPaths = [];

    // Map line items
    for (var item in lineItems) {
      if (item['itemNumber'] == '01_012_0107_1_1') {
        itemMap['Public holiday'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_012_0107_1_1_T') {
        itemMap['Public holiday - TTP'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_010_0107_1_1') {
        itemMap['Night-Time Sleepover'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_011_0107_1_1') {
        itemMap['Weekday Daytime'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_011_0107_1_1_T') {
        itemMap['Weekday Daytime - TTP'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_013_0107_1_1') {
        itemMap['Saturday'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_013_0107_1_1_T') {
        itemMap['Saturday - TTP'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_014_0107_1_1') {
        itemMap['Sunday'] = '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_014_0107_1_1_T') {
        itemMap['Sunday - TTP'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_015_0107_1_1') {
        itemMap['Weekday Evening'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      } else if (item['itemNumber'] == '01_015_0107_1_1_T') {
        itemMap['Weekday Evening - TTP'] =
        '${item['itemNumber']}\n${item['itemDescription']}';
      }
    }

    // Clear previous data
    emailClientMap.clear();
    clientData.clear();

    // Debug prints
    debugPrint("\n\n=== Start of Debug Info ===");
    debugPrint("Users Length: ${assignedClients?['user']?.length}");
    for (var user in assignedClients?['user'] ?? []) {
      debugPrint("User: ${user['email']}");
    }

    debugPrint("\nUserDocs Length: ${assignedClients?['userDocs']?.length}");
    for (var doc in assignedClients?['userDocs'] ?? []) {
      debugPrint("UserDoc email: ${doc['email']}");
      debugPrint("Number of docs: ${doc['docs']?.length}");
    }

    debugPrint(
        "\nClientDetail Length: ${assignedClients?['clientDetail']?.length}");
    for (var client in assignedClients?['clientDetail'] ?? []) {
      debugPrint("Client: ${client['clientEmail']}");
    }
    debugPrint("=== End of Debug Info ===\n\n");

    // Process each user
    for (var user in assignedClients?['user']) {
      try {
        final userEmail = user['email'];
        debugPrint("\nProcessing user: $userEmail");

        var userDocs = assignedClients?['userDocs']
            .firstWhere((doc) => doc['email'] == userEmail, orElse: () => null);

        debugPrint("Found userDocs for $userEmail: ${userDocs != null}");

        if (userDocs != null && userDocs['docs'] != null) {
          final docs = userDocs['docs'] as List;
          debugPrint("Number of docs for $userEmail: ${docs.length}");

          for (var doc in docs) {
            final clientEmail = doc['clientEmail'];
            debugPrint("Processing doc for client: $clientEmail");

            // Find matching client details
            final clientDetail = assignedClients?['clientDetail'].firstWhere(
                (client) => client['clientEmail'] == clientEmail,
                orElse: () => null);

            if (clientDetail != null) {
              Map<String, dynamic> clientDetails = {
                'clientName':
                    "${clientDetail['clientFirstName']} ${clientDetail['clientLastName']}",
                'clientEmail': clientEmail,
                'clientPhone': clientDetail['clientPhone'],
                'clientAddress': [
                  clientDetail['clientAddress'],
                  clientDetail['clientCity'],
                  clientDetail['clientState'],
                  clientDetail['clientZip']
                ],
                'clientBusinessName': clientDetail['clientBusinessName'],
                'dateList': doc['dateList'],
                'startTimeList': doc['startTimeList'],
                'endTimeList': doc['endTimeList'],
                'breakList': doc['breakList'],
                'timeList': doc['Time'],
                'userDetails': {
                  'name': "${user['firstName']} ${user['lastName']}",
                  'abn': user['abn'],
                  'email': userEmail
                }
              };

              if (emailClientMap[userEmail] == null) {
                emailClientMap[userEmail] = [];
              }
              emailClientMap[userEmail]!.add(clientDetails);
            }
          }
        }
      } catch (e, stackTrace) {
        debugPrint("\nError processing user: $e");
        debugPrint("Stack trace: $stackTrace");
      }
    }

    // Generate PDFs for each client of each user
    for (var userEmail in emailClientMap.keys) {
      debugPrint("\nGenerating PDFs for user: $userEmail");
      var userClients = emailClientMap[userEmail]!;

      for (var clientDetails in userClients) {
        try {
          final clientName = clientDetails['clientName'];
          debugPrint("Generating PDF for client: $clientName");

          // Clear previous data
          invoiceName.clear();
          invoiceABN.clear();

          // Set current invoice data
          invoiceName.add(clientDetails['userDetails']['name']);
          invoiceABN.add(clientDetails['userDetails']['abn']);

          debugPrint("Invoice Name: $invoiceName");
          debugPrint("Invoice ABN: $invoiceABN");

          // Process client data for invoice components
          List<String> workedDateList =
              List<String>.from(clientDetails["dateList"]);
          List<String> startTimeList =
              List<String>.from(clientDetails["startTimeList"]);
          List<String> endTimeList =
              List<String>.from(clientDetails["endTimeList"]);
          List<String> holidays =
              await apiMethod.checkHolidaysSingle(workedDateList);
          // First, when processing client data:
          List<String> timeList = List<String>.from(clientDetails["timeList"]);
          List<String> dayOfWeek = findDayOfWeek(workedDateList);
          List<String> timePeriods = getTimePeriods(startTimeList, endTimeList);

          // Add this computation
          List<String> computeInvoiceComponent = await Future.delayed(
              const Duration(seconds: 3),
              () => computeInvoiceComp(dayOfWeek, timePeriods, holidays));
          debugPrint("Compute Invoice Component: $computeInvoiceComponent");

          // Calculate invoice components
          List<Map<String, dynamic>> invoiceComponents = getInvoiceComponent(
              workedDateList,
              startTimeList,
              endTimeList,
              holidays,
              timeList,
              clientName,
              computeInvoiceComponent);
          debugPrint("Iinvoice Compontnets: \n$invoiceComponents\n");
          List<double> rate = getRate(dayOfWeek, holidays);
          List<double> hoursWorked =
              calculateTotalHours(startTimeList, endTimeList, timeList);
          List<double> totalAmount =
              calculateTotalAmount(hoursWorked, rate, holidays);

          // Process client data for PDF
          processClientData(clientName, clientDetails['clientEmail'],
              invoiceComponents, rate, hoursWorked, totalAmount);

          // Generate PDF
          final pdf = await generatePdfForClient(clientName);
          final fileName =
              'Invoice_${userEmail}_${clientName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
          final output = await getTemporaryDirectory();
          final file = File('${output.path}/$fileName');
          await file.writeAsBytes(await pdf.save());
          generatedPdfPaths.add(file.path);

          debugPrint("Generated PDF: $fileName");
        } catch (e, stackTrace) {
          debugPrint("Error generating PDF for client: $e");
          debugPrint("Stack trace: $stackTrace");
        }
      }
    }

    return generatedPdfPaths;
  }

  void processClientData(
      String clientName,
      String clientEmail,
      List<Map<String, dynamic>> components,
      List<double> rates,
      List<double> hoursWorked,
      List<double> totalAmount) {
    List<List<String>> clientRows = [
      [
        'Invoice Components',
        'Time Worked',
        'Hours/Units',
        'Rate',
        'Total Amount'
      ],
    ];

    double clientGrandTotalHours = 0.0;
    double clientGrandTotalAmount = 0.0;

    // Process each component with its corresponding data
    for (int i = 0; i < components.length; i++) {
      var component = components[i];
      double workedHours =
          hoursBetweenPerListItem(component['startTime'], component['endTime']);

      clientRows.add([
        component['description'] ?? 'Unknown',
        '${component['date']} - ${component['startTime']} to ${component['endTime']} - ($workedHours hrs)',
        hoursWorked[i].toStringAsFixed(2),
        '\$${rates[i].toStringAsFixed(2)}',
        '\$${totalAmount[i].toStringAsFixed(2)}'
      ]);

      clientGrandTotalHours += hoursWorked[i];
      clientGrandTotalAmount += totalAmount[i];
    }

    // Add total row
    clientRows.add([
      'TOTAL',
      '',
      clientGrandTotalHours.toStringAsFixed(2),
      '',
      '\$${clientGrandTotalAmount.toStringAsFixed(2)}'
    ]);

    // Store the processed data
    clientData[clientName] = clientRows;
  }

  Future<pw.Document> generatePdfForClient(String clientName) async {
    debugPrint("Generate PDF for Client\n\n: $invoiceName");
    final pdf = pw.Document();

    if (invoiceName.isEmpty || invoiceABN.isEmpty) {
      throw Exception('Required invoice data is missing');
    }

    // Find the client data based on the clientName
    List<Map<String, dynamic>>? clientDetailsList;
    for (var email in emailClientMap.keys) {
      var foundClient = emailClientMap[email]?.firstWhere(
          (element) => element['clientName'] == clientName,
          orElse: () => {});
      if (foundClient != null && foundClient.isNotEmpty) {
        clientDetailsList = [foundClient];
        break;
      }
    }

    String clientAddress = '';
    String clientCity = '';
    String clientState = '';
    String clientZip = '';
    String clientBusinessName = '';
    String clientStartDate = '';
    String clientEndDate = '';
    double grandTotalHours = 0.0;

    if (clientDetailsList != null && clientDetailsList.isNotEmpty) {
      clientAddress = clientDetailsList[0]['clientAddress'][0] ?? '';
      clientCity = clientDetailsList[0]['clientAddress'][1] ?? '';
      clientState = clientDetailsList[0]['clientAddress'][2] ?? '';
      clientZip = clientDetailsList[0]['clientAddress'][3] ?? '';
      clientBusinessName = clientDetailsList[0]['clientBusinessName'] ?? '';

      // start date and end date
      final dateList = clientDetailsList[0]['dateList'];
      if (dateList != null && dateList.isNotEmpty) {
        List<DateTime> dates = getWeekDates(DateTime.parse(dateList[0]));
        clientStartDate = DateFormat('dd-MM-yyyy').format(dates[0]);
        clientEndDate = DateFormat('dd-MM-yyyy').format(dates[1]);
      }

      if (clientData[clientName] != null) {
        // Calculate grand total hours
        for (int i = 1; i < (clientData[clientName]!.length - 1); i++) {
          grandTotalHours +=
              double.tryParse(clientData[clientName]![i][2]) ?? 0.0;
        }
      }
    }

    // Define table data
    final tableData = [
      [
        invoiceName[0],
      ],
      [
        'ABN:',
        invoiceABN[0],
      ],
      ['Period Starting:', clientStartDate],
      ['Period Ending:', clientEndDate],
      ['Total Amount:', (clientData[clientName]?.last[4] ?? "0.00")],
      ['Hours Completed:', grandTotalHours.toStringAsFixed(2)],
    ];
    final bankDetail = [
      [
        'Bank Details:',
      ],
      [
        'Bank Name:',
        'Commonwealth Bank',
      ],
      ['Account Name:', 'Pratiksha Tiwari'],
      ['BSB:', '06263242'],
      ['Account Number:', '47022'],
    ];
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginLeft: 15, marginRight: 15, marginTop: 35, marginBottom: 25),
        build: (pw.Context context) => [
          pw.Stack(
            children: [
              // Invoice header
              pw.Container(
                width: PdfPageFormat.a4.width / 2.4,
                child: pw.Table.fromTextArray(
                  headerStyle: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  data: tableData,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment
                        .centerRight, // aligns the rightmost column to the right
                  },
                  cellStyle: const pw.TextStyle(fontSize: 12),
                  border: const pw.TableBorder(
                    left: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    right: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    top: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    bottom: pw.BorderSide(
                      color: PdfColors.black,
                      width: 1,
                    ),
                    verticalInside: pw.BorderSide(
                      color: PdfColors.white,
                      width: 1,
                    ),
                  ),
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.topRight,
                child: pw.Container(
                  //padding: const pw.EdgeInsets.symmetric(vertical: 20),
                  child: pw.Text(
                    'INVOICE',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 24),
          pw.SizedBox(height: 1, child: pw.Divider(color: PdfColors.black)),
          pw.SizedBox(height: 24),

          // Billing information
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('BILL TO: ',
                        style: pw.TextStyle(
                            fontSize: 12, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(width: 10),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(clientName,
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Text(clientAddress,
                            style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 4),
                        pw.Text('$clientCity, $clientState $clientZip',
                            style: const pw.TextStyle(fontSize: 12)),
                        pw.SizedBox(height: 4),
                        pw.Text('($clientBusinessName)',
                            style: const pw.TextStyle(fontSize: 12)),
                      ],
                    ),
                  ]),
              pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Invoice Number: $invoiceNumber',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 4),
                        pw.Text('Job Title: Home Care Assistance',
                            style: pw.TextStyle(
                                fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ]),
            ],
          ),

          pw.SizedBox(height: 20),

          // Invoice details
          pw.Table.fromTextArray(
            headerStyle:
                pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            headerAlignment: pw.Alignment.center,
            cellStyle: const pw.TextStyle(fontSize: 10),
            cellAlignment: pw.Alignment.center,
            columnWidths: {
              0: const pw.FixedColumnWidth(
                  160), //Invoice Components, give more space
              1: const pw.FixedColumnWidth(180), //Time Worked, give more space
              2: const pw.FixedColumnWidth(80), //Hours/Units,
              3: const pw.FixedColumnWidth(80), //Rate
              4: const pw.FixedColumnWidth(80), //Total amount
            },
            data: clientData[clientName] ?? [],
          ),
          pw.SizedBox(height: 20),

          // Invoice total
          pw.Align(
            alignment: pw.Alignment.centerRight,
            child: pw.Text(
              'TOTAL: ${clientData[clientName]?.last[4] ?? "0.00"}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          // Bank details
          pw.Container(
            width: PdfPageFormat.a4.width,
            //padding: const pw.EdgeInsets.symmetric(vertical: 20),
            child: pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
              data: bankDetail,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment
                    .centerRight, // aligns the rightmost column to the right
              },
              cellStyle: const pw.TextStyle(fontSize: 12),
              border: const pw.TableBorder(
                left: pw.BorderSide(
                  color: PdfColors.black,
                  width: 1,
                ),
                right: pw.BorderSide(
                  color: PdfColors.black,
                  width: 1,
                ),
                top: pw.BorderSide(
                  color: PdfColors.black,
                  width: 1,
                ),
                bottom: pw.BorderSide(
                  color: PdfColors.black,
                  width: 1,
                ),
                verticalInside: pw.BorderSide(
                  color: PdfColors.white,
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    debugPrint(
        "Table data: $tableData\n bank detail: $bankDetail\n Total amount: ${clientData[clientName]?.last[4]}\n Invoice table data: ${clientData[clientName]}");
    return pdf;
  }

  // Helper functions

  List<String> findDayOfWeek(List<String> dateList) {
    final daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return dateList.map((date) {
      final dayOfWeekIndex = DateTime.parse(date).weekday;
      return daysOfWeek[dayOfWeekIndex % 7];
    }).toList();
  }

  List<double> getRate(List<String> dayOfWeek, List<String> holidays) {
    List<double> rates = [];
    for (int i = 0; i < dayOfWeek.length; i++) {
      String currentDayOfWeek = dayOfWeek[i];
      String currentHoliday = i < holidays.length ? holidays[i] : 'No Holiday';
      bool isHoliday = currentHoliday == 'Holiday';

      switch (currentDayOfWeek) {
        case 'Saturday':
        case 'Sunday':
          rates.add(isHoliday ? 110.0 : 55.0);
          break;
        default:
          rates.add(isHoliday ? 100.0 : 50.0);
      }
    }
    return rates;
  }

  List<double> calculateTotalHours(List<String> startTimeList,
      List<String> endTimeList, List<String> timeList) {
    List<double> hoursWorkedList = [];
    for (int i = 0; i < startTimeList.length; i++) {
      if (i < timeList.length) {
        hoursWorkedList.add(hoursFromTimeString(timeList[i]));
      } else {
        DateTime startTime = DateFormat('h:mm a').parse(startTimeList[i]);
        DateTime endTime = DateFormat('h:mm a').parse(endTimeList[i]);
        if (endTime.isBefore(startTime)) {
          endTime = endTime.add(const Duration(days: 1));
        }
        Duration duration = endTime.difference(startTime);
        hoursWorkedList.add(duration.inMinutes / 60);
      }
    }
    return hoursWorkedList;
  }

  List<double> calculateTotalAmount(
      List<double> hours, List<double> rates, List<String> holidays) {
    List<double> totalAmount = [];
    for (int i = 0; i < hours.length; i++) {
      double amount = hours[i] * rates[i];
      if (i < holidays.length && holidays[i] != 'No Holiday') {
        amount *= 1.5; // Apply holiday rate
      }
      totalAmount.add(amount);
    }
    return totalAmount;
  }

  List<Map<String, dynamic>> getInvoiceComponent(
      List<String> workedDateList,
      List<String> startTimeList,
      List<String> endTimeList,
      List<String> holidays,
      List<String> timeList,
      String clientName,
      List<String> computeInvoiceComponent) {
    List<Map<String, dynamic>> invoiceComponents = [];
    List<String> dayOfWeek = findDayOfWeek(workedDateList);
    List<String> timePeriods = getTimePeriods(startTimeList, endTimeList);

    for (int i = 0; i < workedDateList.length; i++) {
      String description =
          getComponentDescription(dayOfWeek[i], timePeriods[i], holidays[i]);
      double hoursWorked = hoursFromTimeString(timeList[i]);
      double assignedHour =
          hoursBetweenPerListItem(startTimeList[i], endTimeList[i]);

      invoiceComponents.add({
        'clientName': clientName,
        'date': workedDateList[i],
        'dayOfWeek': dayOfWeek[i],
        'startTime': startTimeList[i],
        'endTime': endTimeList[i],
        'hoursWorked': hoursWorked,
        'assignedHour': assignedHour,
        'holiday': holidays[i] == 'Holiday',
        'description': description,
      });
    }

    return invoiceComponents;
  }

  String getComponentDescription(
      String dayOfWeek, String timePeriod, String holiday) {
    bool isHoliday = holiday == 'Holiday';
    String key;

    if (isHoliday) {
      key = 'Public holiday';
    } else {
      switch (dayOfWeek) {
        case 'Saturday':
          key = 'Saturday';
          break;
        case 'Sunday':
          key = 'Sunday';
          break;
        default:
          switch (timePeriod) {
            case 'Evening':
              key = 'Weekday Evening';
              break;
            case 'Night':
              key = 'Night-Time Sleepover';
              break;
            default:
              key = 'Weekday Daytime';
          }
      }
    }

    return itemMap[key] ?? 'Unknown';
  }

  List<String> getTimePeriods(
      List<String> startTimeList, List<String> endTimeList) {
    return startTimeList.map((time) => getTimePeriod(time)).toList();
  }

  String getTimePeriod(String timeStr) {
    DateTime time = DateFormat('h:mm a').parse(timeStr);
    int hour = time.hour;

    if (hour >= 6 && hour < 18) {
      return 'Daytime';
    } else if (hour >= 18 && hour < 22) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }

  double hoursFromTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2].split(' ')[0]);
    return hours + (minutes / 60) + (seconds / 3600);
  }

  double hoursBetweenPerListItem(String start, String end) {
    DateTime startTime = DateFormat('h:mm a').parse(start);
    DateTime endTime = DateFormat('h:mm a').parse(end);
    if (endTime.isBefore(startTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }
    return endTime.difference(startTime).inMinutes / 60;
  }

  List<DateTime> getWeekDates(DateTime date) {
    int weekday = date.weekday;
    DateTime startDate = date.subtract(Duration(days: weekday - 1));
    DateTime endDate = startDate.add(const Duration(days: 6));
    return [startDate, endDate];
  }

  List<String> computeInvoiceComp(
      List<String> dayOfWeek, List<String> timePeriods, List<String> holidays) {
    List<String> invoiceComponents = [];

    for (int i = 0; i < dayOfWeek.length; i++) {
      String day = dayOfWeek[i];
      String timePeriod = timePeriods[i];
      bool isHoliday = holidays[i] == 'true';

      if (isHoliday) {
        invoiceComponents.add(itemMap['Public holiday'] ?? 'Unknown');
      } else {
        switch (day) {
          case 'Saturday':
            invoiceComponents.add(itemMap['Saturday'] ?? 'Unknown');
            break;
          case 'Sunday':
            invoiceComponents.add(itemMap['Sunday'] ?? 'Unknown');
            break;
          default:
            if (timePeriod == 'Night') {
              invoiceComponents
                  .add(itemMap['Night-Time Sleepover'] ?? 'Unknown');
            } else if (timePeriod == 'Evening') {
              invoiceComponents.add(itemMap['Weekday Evening'] ?? 'Unknown');
            } else {
              invoiceComponents.add(itemMap['Weekday Daytime'] ?? 'Unknown');
            }
        }
      }
    }

    return invoiceComponents;
  }

  @override
  Widget build(BuildContext context) {
    String zipFilePath = "";
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "Generated Invoices",
          style: TextStyle(
            color: AppColors.colorFontSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<List<String>>(
        future: _generateInvoiceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 15,
                    child: ButtonWidget(
                      title: 'Try Again',
                      hasBorder: false,
                      onPressed: () {
                        setState(() {
                          _generateInvoiceFuture = generateInvoiceForAllUser();
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No invoices generated'));
          }
          List<String> pdfPaths = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pdfPaths.length,
                  itemBuilder: (context, index) {
                    return PdfViewPage(pdfPath: pdfPaths[index]);
                  },
                ),
              ),
              const SizedBox(height: 10),
              SmoothPageIndicator(
                controller: _pageController,
                count: pdfPaths.length,
                effect: WormEffect(
                  dotHeight: 8.0,
                  dotWidth: 8.0,
                  activeDotColor: AppColors.colorPrimary,
                  dotColor: AppColors.colorSecondary.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 15,
                child: ButtonWidget(
                  title: 'Download PDFs',
                  onPressed: () async {
                    debugPrint("Pdf paths: $pdfPaths");
                    final downloadService = locator<DownloadService>();
                    zipFilePath = await downloadService.downloadFiles(pdfPaths);
                  },
                  hasBorder: false,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 15,
                child: Consumer<InvoiceEmailViewModel>(
                  builder: (context, model, child) {
                    return ElevatedButton(
                      onPressed: model.isLoading
                          ? null
                          : () async {
                              model.setIsLoading(true);
                              final invoiceEmailService =
                                  locator<InvoiceEmailService>();
                              final downloadService =
                                  locator<DownloadService>();
                              zipFilePath =
                                  await downloadService.downloadFiles(pdfPaths);

                              var response =
                                  await invoiceEmailService.sendInvoiceEmail(
                                zipFilePath,
                                invoiceName,
                                endDate,
                                invoiceNumber,
                                widget.email,
                                widget.genKey,
                              );
                              if (response == "Success") {
                                model.setIsResponseReceived(true);
                                FlushBarWidget().flushBar(
                                  context: _scaffoldKey.currentContext!,
                                  title: "Success",
                                  message: "Email sent successfully",
                                  backgroundColor: AppColors.colorSecondary,
                                );
                                Future.delayed(const Duration(seconds: 3), () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                });
                              } else {
                                model.setIsResponseReceived(false);
                                FlushBarWidget().flushBar(
                                  context: _scaffoldKey.currentContext!,
                                  title: "Error",
                                  message: "Email not sent",
                                  backgroundColor: AppColors.colorWarning,
                                );
                              }
                              model.setIsLoading(false);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.colorPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: model.isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              'Send Email',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}
