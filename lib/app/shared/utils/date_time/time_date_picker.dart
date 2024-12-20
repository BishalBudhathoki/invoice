import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_with_variable_width_height_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/flushbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:intl/intl.dart';

class TimeAndDatePicker extends StatefulWidget {
  final String userEmail;
  final String clientEmail;

  const TimeAndDatePicker({
    super.key,
    required this.userEmail,
    required this.clientEmail,
  });

  @override
  State<StatefulWidget> createState() {
    return _TimeAndDatePickerState();
  }
}

class _TimeAndDatePickerState extends State<TimeAndDatePicker> {
  late String _focusedDay = DateFormat("yyyy-MM-dd").format(DateTime.now());
  TimeOfDay _focusedTime = TimeOfDay.now();
  TimeOfDay _focusedTime1 = TimeOfDay.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var _isVisibleDate = true;
  var _isVisibleTime = true;
  var _isVisibleTime1 = true;
  String _selectedBreak = "Yes";
  var breakOptionItems = ["Yes", "No"];

  @override
  void initState() {
    super.initState();
  }

  ApiMethod apiMethod = ApiMethod();
  List dateList = [];
  List startTimeList = [];
  List endTimeList = [];
  List breakList = [];
  final List<Widget> _cardList = [];
  List<String> data = [];

  void _addCardWidget() {
    for (var widget in _cardList) {
      data.add(_focusedDay.toString());
    }
    setState(() {
      _cardList.add(_card());
    });
  }

  int count = 0;
  Widget _card() {
    // dateList.add("${_focusedDay.year}-${_focusedDay.month}-${_focusedDay.day}");

    dateList.add(_focusedDay);
    startTimeList.add(_focusedTime.format(context));
    endTimeList.add(_focusedTime1.format(context));
    breakList.add(_selectedBreak);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:
          // card to display selected date
          Container(
              height: 150,
              width: 380,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.blueGrey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.13, // Adjust the height value as needed
                        width: MediaQuery.of(context).size.width *
                            0.13, // Adjust the width value as needed
                        child: Image.asset(
                          'assets/icons/fav-folder-dynamic-color.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.13, // Adjust the height value as needed
                        width: MediaQuery.of(context).size.width *
                            0.4, // Adjust the width value as needed
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Date: ",
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text(
                                  _focusedDay,
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Start Time: ",
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  _focusedTime.format(context),
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "End Time: ",
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text(
                                  _focusedTime1.format(context),
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              children: [
                                const Text(
                                  "Break: ",
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text(
                                  _selectedBreak,
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeNormal,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
              )),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2030),
      locale: const Locale('en', 'AU'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.colorPrimary, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd");
      String formattedDate = dateFormat.format(value ?? DateTime.now());
      DateTime tempDateTime = DateTime.parse(formattedDate);
      DateTime formattedDateTime =
          DateTime(tempDateTime.year, tempDateTime.month, tempDateTime.day);

      // Format the DateTime object to a string and print it
      String dateString = dateFormat.format(formattedDateTime);
      setState(() {
        _isVisibleDate = false;
        _focusedDay = dateString;
        print("Hello: $value $_focusedDay");
      });
    });
  }

  void _showTimePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.colorPrimary, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      setState(() {
        _isVisibleTime = false;
        _focusedTime = value ?? TimeOfDay.now();
        print(_focusedTime.format(context));
      });
      print("Time: $value $_focusedTime");
    });
  }

  void _showTimePicker1() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.colorPrimary, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      setState(() {
        _isVisibleTime1 = false;
        _focusedTime1 = value ?? TimeOfDay.now();
      });
      print("Time: $value $_focusedTime1");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Time and Date Picker',
            style: TextStyle(
              color: Colors.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Visibility(
                      visible: !_isVisibleDate,
                      replacement: const Text("Please Select a Date",
                          style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold)),
                      child: Text(
                          "Selected Date: "
                          // "${_focusedDay.day}/${_focusedDay.month}/${_focusedDay.year}",
                          "${_focusedDay}",
                          style: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8.0),
                    ButtonWithVariableWH(
                      title: 'Select Date',
                      onPressed: _showDatePicker,
                      hasBorder: true,
                      height: context.height * 0.076,
                      width: context.width * 0.35,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
                Column(
                  children: [
                    Visibility(
                      visible: !_isVisibleTime,
                      replacement: const Text("Please Select Start Time",
                          style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold)),
                      child: Text(
                          "Selected Time: ${_focusedTime.format(context)}",
                          style: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8.0),
                    ButtonWithVariableWH(
                      title: 'Select Start Time',
                      onPressed: _showTimePicker,
                      hasBorder: true,
                      height: context.height * 0.076,
                      width: context.width * 0.35,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 13.0),
                    SizedBox(
                      height: context.height * 0.076,
                      width: context.width * 0.35,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                          hintText: "Break Allowed?",
                          labelText: 'Break Allowed?',
                          labelStyle: TextStyle(
                              color: AppColors.colorFontPrimary,
                              fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedBreak = value!;
                          });
                        },
                        items: breakOptionItems.map((String? item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item!,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        }).toList(),
                        value: _selectedBreak,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Visibility(
                      visible: !_isVisibleTime1,
                      replacement: const Text("Please Select End Time",
                          style: TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold)),
                      child: Text(
                          "Selected Time: ${_focusedTime1.format(context)}",
                          style: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8.0),
                    ButtonWithVariableWH(
                      title: 'Select End Time',
                      onPressed: _showTimePicker1,
                      hasBorder: true,
                      height: context.height * 0.076,
                      width: context.width * 0.35,
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _cardList.length,
                  itemBuilder: (context, index) {
                    return _cardList[index];
                  }),
            ),
            ButtonWidget(
              title: 'Add more?',
              onPressed: _addCardWidget,
              hasBorder: true,
            ),
            const SizedBox(height: 8.0),
            ButtonWidget(
              title: 'Submit',
              onPressed: () async {
                print("$dateList $startTimeList $endTimeList $breakList");
                // showDialog(
                //   context: _scaffoldKey.currentContext!,
                //   builder: (context) {
                //     // Store the reference to the displayed dialog
                //     AlertDialog alertDialog = const AlertDialog(
                //       title: Text("Alert Dialog"),
                //       content: Text("This is an alert dialog."),
                //     );
                //     return alertDialog;
                //   },
                // );

                Future.delayed(const Duration(seconds: 3), () async {
                  var response = await _submitAssignedAppointment();
                  if (response['message'].toString() == "Success") {
                    print("Success");
                    Navigator.pop(_scaffoldKey.currentContext!);
                    FlushBarWidget fbw = FlushBarWidget();
                    fbw.flushBar(
                      context: _scaffoldKey.currentContext!,
                      title: "Success",
                      message: "Client assigned successfully",
                      backgroundColor: AppColors.colorSecondary,
                    );
                    // Future.delayed(const Duration(seconds: 3), () {
                    //   // Close the displayed dialog before navigating back
                    //   //Navigator.pop(context); // Close the dialog
                    //   // Navigator.pop(context);
                    //   // Navigator.pop(context);
                    //   Navigator.pop(context);
                    //   Navigator.pop(context);
                    // });
                  } else {
                    print("Failed");
                    Navigator.pop(_scaffoldKey.currentContext!);
                    FlushBarWidget fbw = FlushBarWidget();
                    fbw.flushBar(
                      context: _scaffoldKey.currentContext!,
                      title: "Error",
                      message: "Client not assigned",
                      backgroundColor: AppColors.error,
                    );
                    Future.delayed(const Duration(seconds: 3), () {
                      // Close the displayed dialog before navigating back
                      Navigator.pop(context); // Close the dialog
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  }
                });
              },
              hasBorder: true,
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _submitAssignedAppointment() async {
    // print("Username:  ${_userEmailController.text.trim()}");
    // print("Password:  ${_passwordController.text.trim()}");
    var ins = await apiMethod.assignClientToUser(
      widget.userEmail,
      widget.clientEmail,
      dateList,
      startTimeList,
      endTimeList,
      breakList,
    );
    //print("Response: "+ ins['email'].toString() + ins['password'].toString());
    return ins;
  }

  Stream<Text> getDate(Duration refreshTime) async* {
    while (true) {
      await Future.delayed(refreshTime);
      yield Text("Selected Date: $_focusedDay");
    }
  }
}
