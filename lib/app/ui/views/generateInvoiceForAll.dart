import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:MoreThanInvoice/app/core/controllers/generateInvoice_controller.dart';
import 'package:MoreThanInvoice/app/core/controllers/lineItem_controller.dart';
import 'package:MoreThanInvoice/app/core/view-models/sendEmail_model.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/ui/views/pdfViewPage_view.dart';
import 'package:MoreThanInvoice/app/ui/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/flushbar_widget.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:MoreThanInvoice/backend/downloadInvoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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
    requestStoragePermission().then((value) {
      _storagePermissionGranted = value;
    });
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

  Future<List<String>> generateInvoiceForAllUser() async {
    final LineItemController lineItemController = Get.put(LineItemController());
    await lineItemController.getLineItems();
    final List<Map<String, dynamic>> lineItems = lineItemController.lineItems;
    final assignedClients = await apiMethod.getAssignedClients();
    debugPrint("Assigned Clients: $assignedClients"); // Debug print
    // Mapping line items
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

    if (assignedClients != null) {
      final user = assignedClients['user'][0];
      final client = assignedClients['clientDetail'];

      invoiceName.add("${user['firstName']} ${user['lastName']}");
      invoiceABN.add("${user['abn']}");

      final userDocsFromAssignedClients = assignedClients['userDocs'][0];
      final docsFromAbove = userDocsFromAssignedClients['docs'];

      for (var doc in docsFromAbove) {
        final dateList = doc['dateList'];
        dates = getWeekDates(DateTime.parse(dateList[0]));
        startDateList.add(dates[0]);
        endDateList.add(dates[1]);
      }

      for (final userDocItem in assignedClients['userDocs']) {
        List<Map<String, dynamic>> clientDetailsList = [];

        for (int i = 0; i < client.length; i++) {
          Map<String, dynamic> clientDetails = {
            'clientName':
            "${client[i]['clientFirstName']} ${client[i]['clientLastName']}",
            'clientEmail': userDocItem['docs'][i]['clientEmail'],
            'clientPhone': client[i]['clientPhone'],
            'clientAddress': [
              client[i]['clientAddress'],
              client[i]['clientCity'],
              client[i]['clientState'],
              client[i]['clientZip']
            ],
            'clientBusinessName': client[i]['clientBusinessName'],
            'dateList': userDocItem['docs'][i]['dateList'],
            'startTimeList': userDocItem['docs'][i]['startTimeList'],
            'endTimeList': userDocItem['docs'][i]['endTimeList'],
            'breakList': userDocItem['docs'][i]['breakList'],
            'timeList': userDocItem['docs'][i]['Time'],
          };

          clientDetailsList.add(clientDetails);
        }

        emailClientMap[user['email']] = clientDetailsList;
      }
    }

    List<String> generatedPdfPaths = [];

    for (var email in emailClientMap.keys) {
      var clientDataList = emailClientMap[email];

      for (var clientData in clientDataList!) {
        String clientName = clientData["clientName"];
        String clientEmail = clientData["clientEmail"];

        List<String> workedDateList = List<String>.from(clientData["dateList"]);
        List<String> startTimeList =
        List<String>.from(clientData["startTimeList"]);
        List<String> endTimeList = List<String>.from(clientData["endTimeList"]);
        List<String> holidays =
        await apiMethod.checkHolidaysSingle(workedDateList);
        List<String> timeList = List<String>.from(clientData["timeList"]);
        List<String> dayOfWeek = findDayOfWeek(workedDateList);

        List<Map<String, dynamic>> invoiceComponents = getInvoiceComponent(
            workedDateList,
            startTimeList,
            endTimeList,
            holidays,
            timeList,
            clientName);

        List<double> rate = getRate(dayOfWeek, holidays);
        List<double> hoursWorked =
        calculateTotalHours(startTimeList, endTimeList, timeList);
        List<double> totalAmount =
        calculateTotalAmount(hoursWorked, rate, holidays);

        processClientData(clientName, clientEmail, invoiceComponents, rate,
            hoursWorked, totalAmount);
      }
    }

    for (var clientName in clientData.keys) {
      final pdf = await generatePdfForClient(clientName);
      final fileName =
          'Invoice_${invoiceNumber}_${clientName.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(await pdf.save());
      generatedPdfPaths.add(file.path);
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

    for (int i = 0; i < components.length; i++) {
      var component = components[i];
      clientRows.add([
        component['description'],
        '${component['date']} - ${component['startTime']} to ${component['endTime']} - (${component['assignedHour']} hrs)',
        '${hoursWorked[i].toStringAsFixed(2)}',
        '\$${rates[i].toStringAsFixed(2)}',
        '\$${totalAmount[i].toStringAsFixed(2)}',
      ]);

      clientGrandTotalHours += hoursWorked[i];
      clientGrandTotalAmount += totalAmount[i];
    }

    clientRows.add([
      'TOTAL',
      '',
      clientGrandTotalHours.toStringAsFixed(2),
      '',
      '\$${clientGrandTotalAmount.toStringAsFixed(2)}',
    ]);

    clientData[clientName] = clientRows;
  }

  Future<pw.Document> generatePdfForClient(String clientName) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginLeft: 15, marginRight: 15, marginTop: 35, marginBottom: 25),
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Invoice header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(invoiceName[0],
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold)),
                      pw.Text('ABN: ${invoiceABN[0]}'),
                      pw.Text('Period Starting: $startDate'),
                      pw.Text('Period Ending: $endDate'),
                    ],
                  ),
                  pw.Text('INVOICE',
                      style: pw.TextStyle(
                          fontSize: 40, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 20),

              // Billing information
              pw.Text('BILL TO:',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Text(clientName),
              // Add more client details here

              pw.SizedBox(height: 20),

              // Invoice details
              pw.Table.fromTextArray(
                headerStyle:
                pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                headerAlignment: pw.Alignment.center,
                cellStyle: const pw.TextStyle(fontSize: 10),
                cellAlignment: pw.Alignment.center,
                data: clientData[clientName] ?? [],
              ),
              pw.SizedBox(height: 20),

              // Invoice total
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'TOTAL: ${clientData[clientName]?.last[4] ?? "0.00"}',
                  style: pw.TextStyle(
                      fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );

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
      String clientName) {
    List<Map<String, dynamic>> invoiceComponents = [];
    List<String> dayOfWeek = findDayOfWeek(workedDateList);
    List<String> timePeriods = getTimePeriods(startTimeList);

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

  List<String> getTimePeriods(List<String> startTimeList) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _scaffoldKey,
      color: Colors.white,
      child: FutureBuilder<List<String>>(
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
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...pdfPaths.map((path) => SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: PdfViewPage(pdfPath: path),
                )),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 15,
                  child: ButtonWidget(
                    title: 'Download PDFs',
                    onPressed: () => downloadFiles(pdfPaths),
                    hasBorder: false,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Consumer<SendEmailModel>(
                    builder: (context, model, child) {
                      return ElevatedButton(
                        onPressed: model.isLoading
                            ? null
                            : () async {
                          model.setIsLoading(true);
                          var response = await sendEmailWithAttachment(
                              pdfPath,
                              invoiceName,
                              endDate,
                              invoiceNumber,
                              widget.email,
                              widget.genKey);
                          if (response == "Success") {
                            model.setIsResponseReceived(true);
                            FlushBarWidget().flushBar(
                              context: _scaffoldKey.currentContext!,
                              title: "Success",
                              message: "Email sent successfully",
                              backgroundColor: AppColors.colorSecondary,
                            );
                            Future.delayed(const Duration(seconds: 3),
                                    () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
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
            ),
          );
        },
      ),
    );
  }
}

