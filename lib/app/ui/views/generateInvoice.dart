import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:invoice/app/core/controllers/generateInvoice_controller.dart';
import 'package:invoice/app/core/controllers/lineItem_controller.dart';
import 'package:invoice/app/core/view-models/sendEmail_model.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/views/pdfViewPage_view.dart';
import 'package:invoice/app/ui/widgets/flushbar_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class GenerateInvoice extends StatefulWidget {
  const GenerateInvoice({super.key});

  @override
  _GenerateInvoiceState createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends State<GenerateInvoice> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ApiMethod apiMethod = ApiMethod();

  String? path;
  final List<String> invoiceName = [];
  final List<String> invoiceABN = [];
  final List<String> invoicePeriodStart = [];
  final List<String> invoicePeriodEnd = [];
  final List<String> invoiceTotalAmount = [];
  final List<String> clientName = [];
  final List<String> clientStreetSubAddress = [];
  final List<String> clientStateZipAddress = [];
  final List<String> clientBusinessName = [];
  final List<String> workedDateList = [];
  final List<String> workedStartTimeList = [];
  final List<String> workedEndTimeList = [];
  final List<String> workedTimePeriodList = [];
  List<DateTime> dates = [];
  String startDate = '';
  String endDate = '';
  String invoiceNumber = '';

  List<String> findDayOfWeek(List<String> dateList) {
  final daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  final dayOfWeekList = dateList.map((date) {
    final dayOfWeekIndex = DateTime.parse(date).weekday;
    return daysOfWeek[dayOfWeekIndex - 1];
  }).toList();
  return dayOfWeekList;
}

  Map<String, String> itemMap = {
    'Default': 'Item Map',
  };

  String checkInvoiceComponents(String key) {
    if (itemMap[key] != null) {
      print("Item map key ${itemMap[key]}");
      return itemMap[key]!;
    } else {
      // handle the case where key is not found in itemMap
      return 'Key not found';
    }
  }

  String getTimePeriod(String dateStr) {
    if (dateStr.isEmpty) {
      return "Unknown";
    }

    DateTime date = DateFormat.jm().parse(dateStr);
    int currentHour = date.hour;

    if (currentHour >= 6 && currentHour < 12) {
      return "Morning";
    } else if (currentHour >= 12 && currentHour < 18) {
      return "Daytime";
    } else if (currentHour >= 18 && currentHour < 21) {
      return "Evening";
    } else {
      return "Night";
    }
  }

  List<String> getTimePeriods(dynamic dateStrInput) {
    if (dateStrInput is List<String>) {
      List<String> timePeriodList = [];

      for (String dateStr in dateStrInput) {
        String timePeriod = getTimePeriod(dateStr);
        timePeriodList.add(timePeriod);
      }
      return timePeriodList;
    } else if (dateStrInput is String) {
      return [getTimePeriod(dateStrInput)];
    } else {
      return ["Invalid input"];
    }
  }


  double hoursFromTimeString(String timeString) {
    List<String> timeComponents = timeString.split(':');
    int hours = int.parse(timeComponents[0]);
    int minutes = int.parse(timeComponents[1]);
    int seconds = int.parse(timeComponents[2]);
    double totalHours = hours + (minutes / 60) + (seconds / 3600);
    return double.parse(totalHours.toStringAsFixed(2));
  }

  List<DateTime> getWeekDates(DateTime date) {
    int weekday = date.weekday; // 1 (Monday) to 7 (Sunday)
    DateTime startDate = date.subtract(Duration(days: weekday - 1));
    DateTime endDate = startDate.add(const Duration(days: 6));
    return [startDate, endDate];
  }

  double hoursBetween(String start, String end) {
    DateTime startTime = DateFormat('h:mm a').parse(start);
    DateTime endTime = DateFormat('h:mm a').parse(end);
    Duration difference = endTime.difference(startTime);
    double hours = difference.inMinutes / 60.0;
    return hours;
  }

  List<String> results = []; // create empty list for results

  Future<String> generateInvoice() async {
    final LineItemController lineItemController = Get.put(LineItemController());
    await lineItemController.getLineItems();
    final List<Map<String, dynamic>> lineItems = lineItemController.lineItems;

    try{
      final userDoc = await apiMethod.getUserDocs();
      //print("Hello: $userDoc ${(userDoc['userDocs'][0]['docs'][0]['Time'])} ${userDoc.length}");
      print("This is line items: \n$lineItems\n this is userDoc: \n$userDoc");
      for (var item in lineItems) {
        print("Supperr    ..........Item: $item");
        if (item['itemNumber'] == '01_012_0107_1_1') {
          itemMap['Public holiday'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_012_0107_1_1_T') {
          itemMap['Public holiday - TTP'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_010_0107_1_1') {
          itemMap['Night-Time Sleepover'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_011_0107_1_1') {
          itemMap['Weekday Daytime'] = item['itemNumber'] + ' \n' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_011_0107_1_1_T') {
          itemMap['Weekday Daytime - TTP'] = item['itemNumber'] + ' \n' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_013_0107_1_1') {
          itemMap['Saturday'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_013_0107_1_1_T') {
          itemMap['Saturday - TTP'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_014_0107_1_1') {
          itemMap['Sunday'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_014_0107_1_1_T') {
          itemMap['Sunday - TTP'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_015_0107_1_1') {
          itemMap['Weekday Evening'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        } else if (item['itemNumber'] == '01_015_0107_1_1_T') {
          itemMap['Weekday Evening - TTP'] = item['itemNumber'] + '\n ' + item['itemDescription'];
          print("Updated item map: $itemMap");
        }
      }
      print("Item Map Startttttt: $itemMap");

      if(userDoc != null ) {
        invoiceName.add("${userDoc['user'][0]['firstName']} ${userDoc['user'][0]['lastName']}");
        invoiceABN.add("${userDoc['user'][0]['abn']}");
        clientName.add("${userDoc['clientDetail'][0]['clientFirstName']} ${userDoc['clientDetail'][0]['clientLastName']}");
        clientStreetSubAddress.add("${userDoc['clientDetail'][0]['clientAddress']}, ${userDoc['clientDetail'][0]['clientCity']}");
        clientStateZipAddress.add("${userDoc['clientDetail'][0]['clientState']}, ${userDoc['clientDetail'][0]['clientZip']}");
        String timeString = userDoc['userDocs']?.first['docs']?.first['Time']?.toString() ?? '';
        String formattedTime = timeString.replaceAll('[', '').replaceAll(']', '');
        workedTimePeriodList.add(formattedTime);
        print(workedTimePeriodList);
        clientBusinessName.add("${userDoc['clientDetail'][0]['clientBusinessName']}");
        for(final date in userDoc['userDocs']?.first['docs']?.first['dateList'] ?? []) {
          workedDateList.add("$date");
        }
        for(final date in userDoc['userDocs']?.first['docs']?.first['startTimeList'] ?? []) {
          workedStartTimeList.add("$date");
        }
        for(final date in userDoc['userDocs']?.first['docs']?.first['endTimeList'] ?? []) {
          workedEndTimeList.add("$date");
        }
        print(" $workedDateList ${(userDoc['userDocs']?.first['docs']?.first['dateList'] ?? []).length}");
      } else {
        print("User has less than 2 documents");
      }
    } on RangeError catch (e) {
      print('Caught range error, may b be connection or not data: $e');
    } on NoSuchMethodError catch (e) {
      print('No such method error: $e');
    } on TypeError catch (ne) {
      print('Type error: $ne');
    } catch (e) {
      print('Other error: $e');
    }

    final pdf = pw.Document();
    //List<String> names = invoiceName.map((name) => name.replaceAll('[', '').replaceAll(']', '')).toList();


    print("Start Date: $startDate End Date: $endDate");

    final dayOfWeek = findDayOfWeek(workedDateList);
    print("Day of week: $dayOfWeek");
    final timePeriods = getTimePeriods(workedStartTimeList);
    print("Time Periods: $timePeriods");
    final holidays = await apiMethod.checkHolidays(workedDateList);
    print("Holidays: $holidays");

    List<String> computeInvoiceComponent = await Future.delayed(const Duration(seconds: 3), () {
      return computeInvoiceComp( dayOfWeek, timePeriods, holidays);
    });
    print("Compute Invoice Component: $computeInvoiceComponent");

    double getRate(int index, List<String> dayOfWeek, List<String> holidays) {
      String currentDayOfWeek = dayOfWeek[index];
      String currentHoliday = holidays[index];
      bool isHoliday = currentHoliday == 'Holiday';
      switch (currentDayOfWeek) {
        case 'Saturday':
          return isHoliday ? 80.0 : 40.0;
        case 'Sunday':
          return isHoliday ? 100.0 : 50.0;
        default:
          return isHoliday ? 80.0 : 40.0;
      }
    }

    String timeString = '';
    String computeInvoiceCompString = '';
    double totalHours = 0.00;
    double grandTotalHours = 0.00;
    double grandTotalAmount = 0.00;
    double workedHours = hoursBetween(workedStartTimeList[0], workedEndTimeList[0]);
    timeString = (workedTimePeriodList[0].split(', ')[0]).split(' ')[0];
    double totalAmount = (hoursFromTimeString(timeString) * getRate(0, dayOfWeek, holidays));
    grandTotalAmount += totalAmount; // add first row total to grandTotalAmount
    grandTotalHours += double.parse(hoursFromTimeString(timeString).toString()); // add first row hours to grandTotalHours
    computeInvoiceCompString = computeInvoiceComponent[0];
    List<List<String>> data = [
      [
        'Invoice Components',
        'Time Worked',
        'Hours/Units',
        'Rate',
        'Total Amount',
      ],
      [
        computeInvoiceCompString,
        '${workedDateList[0]} - ${workedStartTimeList[0]} to ${workedEndTimeList[0]} - ($workedHours hrs)',
        '${hoursFromTimeString(timeString)}',
        '\$${getRate(0, dayOfWeek, holidays).toStringAsFixed(2)}',
        '\$${totalAmount.toStringAsFixed(2)}',
      ],
    ];

    Map<String, double> hoursPerComponent = {};

    dates = (getWeekDates(DateTime.parse(workedDateList[0])));
    startDate = dates[0].toString().split(' ')[0].replaceAll('[', '');
    endDate = dates[1].toString().split(' ')[0].replaceAll('[', '');
    invoiceNumber = dates[1].toString().split(' ')[0].replaceAll('[', '').replaceAll('-', '');

    try {
      print("Worked Time Period List: ${workedTimePeriodList.length}");
      for (int i = 0; i <= workedTimePeriodList.length; i++) {
        String component = computeInvoiceComponent[i+1];
        String timeWorked = '${workedDateList[i+1]} - ${workedStartTimeList[i+1]} '
            'to ${workedEndTimeList[0]} - ($workedHours hrs)';
        timeString = (workedTimePeriodList[0].split(', ')[i+1]).split(' ')[0];
        print("Time string $timeString ${workedDateList.length} $workedTimePeriodList");
        totalHours = double.parse(hoursFromTimeString(timeString).toString());
        double ratesPerHour = getRate(i, dayOfWeek, holidays);
        double totalAmount = totalHours * ratesPerHour;
        grandTotalAmount += totalAmount;
        grandTotalHours += totalHours;

        data.add([
          component,
          timeWorked,
          totalHours.toStringAsFixed(2),
          '\$${ratesPerHour.toStringAsFixed(2)}',
          '\$${totalAmount.toStringAsFixed(2)}',
        ]);

      }

    }
    on RangeError catch (e) {
      print('Compute inv comp: $e');
    } catch (e) {
      print('Comp error: $e');
    }

    // Define table data
    final tableData = [
      [
        invoiceName[0],
      ],
      [
        'ABN:',invoiceABN[0],
      ],
      ['Period Starting:', startDate],
      ['Period Ending:', endDate],
      ['Total Amount:', '\$${grandTotalAmount.toStringAsFixed(2)}'],
      ['Hours Completed:', grandTotalHours.toStringAsFixed(2)],
    ];
    final bankDetail = [
      [
        'Bank Details:',
      ],
      [
        'Bank Name:', 'Commonwealth Bank',
      ],
      ['Account Name:', 'Pratiksha Tiwari'],
      ['BSB:', '06263242'],
      ['Account Number:', '47022'],
    ];


    pdf.addPage(
      pw.MultiPage(
        // Page settings
        pageFormat: PdfPageFormat.a4.copyWith(
            marginLeft: 15, marginRight: 15, marginTop: 35, marginBottom: 25),
        // Page content
        build: (pw.Context context) => [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Invoice header
              pw.Stack(
                children: [
                  pw.Container(
                    width: PdfPageFormat.a4.width / 2.4,
                    //padding: const pw.EdgeInsets.symmetric(vertical: 20),
                    child: pw.Table.fromTextArray(
                      headerStyle: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                      data: tableData,
                      cellAlignments: {
                        0: pw.Alignment.centerLeft,
                        1: pw.Alignment.centerRight, // aligns the rightmost column to the right
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

              // Billing and shipping information
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('BILL TO: ',
                            style: pw.TextStyle(
                                fontSize: 12,
                                fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(width: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(clientName[0],
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.SizedBox(height: 4),
                            pw.Text(clientStreetSubAddress[0],
                                style: const pw.TextStyle(fontSize: 12)),
                            pw.SizedBox(height: 4),
                            pw.Text(clientStateZipAddress[0],
                                style: const pw.TextStyle(fontSize: 12)),
                            pw.SizedBox(height: 4),
                            pw.Text('(${clientBusinessName[0]})',
                                style: const pw.TextStyle(fontSize: 12)),
                          ],
                        ),
                      ]
                  ),
                  pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                              pw.Text('Invoice Number: $invoiceNumber',
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 4),
                              pw.Text('Job Title: Home Care Assistance',
                                  style: pw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: pw.FontWeight.bold)),
                            ],
                        ),
                      ]
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // Invoice details
              pw.Table.fromTextArray(
                headerStyle:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                headerAlignment: pw.Alignment.center,
                columnWidths: const {
                  0: pw.FixedColumnWidth(90),
                  1: pw.FixedColumnWidth(60),
                  2: pw.FixedColumnWidth(40),
                  3: pw.FixedColumnWidth(25),
                  4: pw.FixedColumnWidth(45),
                },
                cellStyle: const pw.TextStyle(fontSize: 12),
                cellAlignments: {
                  0: pw.Alignment.topLeft,
                  1: pw.Alignment.topLeft,
                  2: pw.Alignment.topRight,
                  3: pw.Alignment.topRight,
                  4: pw.Alignment.topRight,
                },
                headerDecoration: const pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
                  color: PdfColors.grey300,
                ),
                headerHeight: 25,
                border: const pw.TableBorder(
                  horizontalInside: pw.BorderSide(
                    color: PdfColors.white,
                  ),
                ),
                data: data,
              ),
              pw.SizedBox(height: 24),

              // Invoice total
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.DecoratedBox(
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.black,
                          width: 1,
                        ),
                      ),
                    ),
                    child: pw.Text(
                      'TOTAL: \$${grandTotalAmount.toStringAsFixed(2)}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 24),
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
            ],
          ),
        ],
      ),
    );

    const fileName = 'example.pdf';
    late Directory? directory;

    if (Platform.isAndroid) {
      print("Android1");

      final storagePermissionStatus = await Permission.storage.status;
      print(storagePermissionStatus);
      if (storagePermissionStatus.isDenied) {
        print("Permission Denied");
        await Permission.storage.request();
      } else {
        await Permission.storage.request();
      }
      //print(getApplicationDocumentsDirectory().toString());
      directory = await getExternalStorageDirectory();
      //print("DP: ${directory?.path}");
      if (!await directory!.exists()) {
        print("Directory does not exist");
        await directory.create(recursive: true);
      }
    } else if (Platform.isIOS) {
      print("iOS1");
      directory = await getApplicationDocumentsDirectory();
    } else if (kIsWeb) {
      print("Web1");
      directory = await getDownloadsDirectory();
    }

    final fileDirectory = Directory(directory!.path);

    final file = File('${fileDirectory.path}/$fileName');
    print("File: $file \n");
    await file.writeAsBytes(await pdf.save());

    const storage = FlutterSecureStorage();
    await storage.write(key: "pdfPath", value: file.path);
    print("PDF path: ${file.path}");
    return file.path;
  }

  List<String> computeInvoiceComp(List<String> dayOfWeek, List<String> timePeriods, List<String> holidays) {
    print("computeInvoiceComp executed here........");
    //try {
    for (int i = 0; i < workedDateList.length; i++) {
      String currentDayOfWeek = dayOfWeek[i];
      String currentTimePeriod = (timePeriods)[i];
      String currentHoliday = holidays[i];
      String holidayTag = (currentHoliday == 'Holiday') ? 'true' : 'false';
      print("Holiday Tag: $holidayTag - $currentHoliday - $currentDayOfWeek - $currentTimePeriod");
      switch (currentDayOfWeek) {
        case 'Saturday':
          switch (currentTimePeriod) {
            case 'Evening':
              results.add(itemMap['Saturday']!);
              break;
            case 'Daytime':
              results.add(itemMap['Saturday']!);
              break;
            case 'Morning':
              results.add(itemMap['Saturday']!);
              break;
            case 'Night':
              results.add(itemMap['Saturday']!);
              break;
          }
          break;
        case 'Sunday':
          switch (currentTimePeriod) {
            case 'Evening':
              results.add(itemMap['Sunday']!);
              break;
            case 'Daytime':
              results.add(itemMap['Sunday']!);
              break;
            case 'Morning':
              results.add(itemMap['Sunday']!);
              break;
            case 'Night':
              results.add(itemMap['Sunday']!);
              break;
          }
          break;
        default:
          switch (currentTimePeriod) {
            case 'Evening':
              results.add(itemMap['Weekday Evening']!);
              break;
            case 'Daytime':
              results.add(itemMap['Weekday Daytime']!);
              break;
            case 'Morning':
              results.add(itemMap['Weekday Daytime']!);
              break;
            case 'Night':
              results.add(itemMap['Night-Time Sleepover']!);
              break;
          }
          break;
      }
    }
    // } on RangeError catch (e) {
    //   print("Compute Invoice Comp Range error: $e");
    // }
    // catch (e) {
    //   print("Compute Invoice Comp Error: $e");
    // }
    return results; // return list of results
  }

  Future<void> downloadFile() async {
    if (await requestStoragePermission()) {
      const storage = FlutterSecureStorage();
      final String? pdfPath = await storage.read(key: "pdfPath");
      print("PDF path: $pdfPath");
      if (pdfPath != null) {
        final file = File(pdfPath);
        final fileName = file.path.split('/').last;
        print("fileName: $fileName");
        final downloadsDirectory = await getDownloadPathForPlatform();
        final downloadPath = '$downloadsDirectory/$fileName';
        print("downloadPath: $downloadPath");
        //await file.copy(downloadPath);

        try {
          // final box = context.findRenderObject() as RenderBox?;
          // final data = await rootBundle.load('$downloadPath');
          final data = await File(downloadPath).readAsBytes();
          final buffer = data.buffer;
          final savedFile = File('$downloadsDirectory/$fileName');
          await savedFile.writeAsBytes(
              buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
          // Share only the PDF file and not the text file
          await Share.shareXFiles(
            [
              XFile(savedFile.path, mimeType: 'application/pdf'),
            ],
            subject: fileName,
          );

        // try {
        //   // Read file contents as bytes
        //   final data = await file.readAsBytes();
        //
        //   // Write file contents to a new file in the download path
        //   final savedFile = File(downloadPath);
        //   await savedFile.writeAsBytes(data);
        //
        //   // Share only the PDF file and not the text file
        //   await Share.shareXFiles(
        //     [
        //       XFile(savedFile.path, mimeType: 'application/pdf'),
        //     ],
        //     subject: fileName,
        //   );

        } on PlatformException catch (e) {
          print("Error while saving file: $e");
        } catch (e) {
          print("Error while saving file: $e");
        }
      }
    }
  }

  Future<bool> requestStoragePermission() async {
    PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.storage.request();
      if (permission != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<String> getDownloadPathForPlatform() async {
    Directory? directory;
    print("Platform: ${Platform.operatingSystem}");
    try {
      if (Platform.isIOS) {
        print("iOS2");
        String? appDocPath;
        try {
          directory = await getApplicationDocumentsDirectory();
        } catch (err) {
          print('Error while getting app directory path: $err');
        }
      } else if (Platform.isAndroid) {
        print("Android2");
        directory = Directory('/data/user/0/Download');
        await directory.exists() ? "Exists" : "Doesn't Exist";
        // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
        // ignore: avoid_slow_async_io
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (kIsWeb) {
        print("Web2");
        directory = await getDownloadsDirectory();
      }
    } catch (err) {
      print("Cannot get download folder path");
    }
    //print(directory?.path);
    return directory!.path;
  }

  Future<String>? _generateInvoiceFuture;
  //String? _pdfPath;
  late String _pdfPath = '';
  String get pdfPath => _pdfPath;

  set pdfPaths(String newPath) {
    _pdfPath = newPath;
  }

  @override
  void initState() {
    super.initState();
    _generateInvoiceFuture = generateInvoice();
    print("Generate invoice future: $_generateInvoiceFuture.toString()");
  }


  @override
  Widget build(BuildContext context) {
    print("$invoiceName $endDate $invoiceNumber");
    return Container(
      key: _scaffoldKey,
      color: Colors.white,
      child:
      // Text('Hello'),
      FutureBuilder<String>(
        future: _generateInvoiceFuture,
            // .then((value) => value)
            // .catchError((error) => error),
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _generateInvoiceFuture = generateInvoice();
                      });
                    },
                    child: Text('Try Again',
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                ],
              ),
            );
          }
          if (snapshot.data == null) {
            return const Center(child: Text('Generating invoice...'));
          }
          pdfPaths = snapshot.data!;
          path = snapshot.data!;
          print("Build PDF path: $pdfPath");
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 1.5,
                child: PdfViewPage(pdfPath: pdfPath),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: downloadFile,
                child: Text(
                  'Download PDF',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 15,
                child: Consumer<SendEmailModel>(
                  builder: (context, model, child) {
                    return ElevatedButton(
                      onPressed: model.isLoading ? null : () async {
                        model.setIsLoading(true);
                        var response = await sendEmailWithAttachment(pdfPath, invoiceName, endDate, invoiceNumber);
                        print(response.toString());
                        if (response == "Success") {
                          print("Success");
                          model.setIsResponseReceived(true);
                          FlushBarWidget fbw = FlushBarWidget();
                          fbw.flushBar(
                            context: _scaffoldKey.currentContext!,
                            title: "Success",
                            message: "Email send successfully",
                            backgroundColor: AppColors.colorSecondary,
                          );
                          Future.delayed(const Duration(seconds: 3), () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          });
                        }
                        else {
                          print("Error");
                          model.setIsResponseReceived(false);
                          FlushBarWidget fbw = FlushBarWidget();
                          fbw.flushBar(
                            context: _scaffoldKey.currentContext!,
                            title: "Error",
                            message: "Email not send",
                            backgroundColor: AppColors.colorWarning,
                          );
                        }
                        model.setIsLoading(false);
                      },
                      child: model.isLoading ? const CircularProgressIndicator() : Text(
                        'Send Email',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  },
                ),
              ),

              // ElevatedButton(
              //   onPressed: () async {
              //     var response = await sendEmailWithAttachment(pdfPath);
              //     print(response.toString());
              //     if (response == "Success") {
              //       print("Success");
              //       FlushBarWidget fbw = FlushBarWidget();
              //       fbw.flushBar(
              //         context: _scaffoldKey.currentContext!,
              //         title: "Success",
              //         message: "Email send successfully",
              //         backgroundColor: AppColors.colorSecondary,
              //       );
              //       Future.delayed(const Duration(seconds: 3), () {
              //         Navigator.pop(context);
              //         Navigator.pop(context);
              //       });
              //     }
              //     else {
              //       print("Error");
              //       FlushBarWidget fbw = FlushBarWidget();
              //       fbw.flushBar(
              //         context: _scaffoldKey.currentContext!,
              //         title: "Error",
              //         message: "Email not send",
              //         backgroundColor: AppColors.colorWarning,
              //       );
              //     }
              //   },
              //   child: Text(
              //     'Send Email',
              //     style: Theme.of(context).textTheme.titleMedium,
              //   ),
              // ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

}
