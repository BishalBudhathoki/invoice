import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';
import 'package:invoice/app/ui/widgets/alertDialog_widget.dart';
import 'package:invoice/app/ui/widgets/button_widget.dart';
import 'package:invoice/app/ui/widgets/button_with_variable_width_height_widget.dart';
import 'package:invoice/app/ui/widgets/flushbar_widget.dart';
import 'package:invoice/backend/api_method.dart';
import 'package:table_calendar/table_calendar.dart';
// import 'package:iconify_flutter/iconify_flutter.dart';
// import 'package:colorful_iconify_flutter/icons/flat_color_icons.dart';

class TimeAndDatePicker extends StatefulWidget {
  final String userEmail;
  final String clientEmail;

  TimeAndDatePicker({
    Key? key,
    required this.userEmail,
    required this.clientEmail,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TimeAndDatePickerState();
  }
}

class _TimeAndDatePickerState extends State<TimeAndDatePicker> {
  DateTime _focusedDay = DateTime.now();
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
  List<Widget> _cardList = [];
  List<String> data = [];

  void _addCardWidget() {
    _cardList.forEach((widget) {
      data.add(_focusedDay.toString());
    });
    setState(() {
      _cardList.add(_card());
    });
  }

  int count = 0;
  Widget _card() {
    dateList.add("${_focusedDay.year}-${_focusedDay.month}-${_focusedDay.day}");
    startTimeList.add(_focusedTime.format(context));
    endTimeList.add(_focusedTime1.format(context));
    breakList.add(_selectedBreak);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child:
          // card to display selected date
          Container(
              height: 110,
              width: 380,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                color: Colors.blueGrey,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: Image.asset(
                          'assets/icons/fav-folder-dynamic-color.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        height: 110,
                        width: 211,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Date: ",
                                  style: TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text(
                                  "${_focusedDay.year}-${_focusedDay.month}-${_focusedDay.day}",
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
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
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  _focusedTime.format(context),
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
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
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text(
                                  _focusedTime1.format(context),
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
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
                                    fontSize: AppDimens.fontSizeMedium,
                                    fontWeight: FontWeight.w900,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                Text(
                                  _selectedBreak,
                                  style: const TextStyle(
                                    color: AppColors.colorFontSecondary,
                                    fontSize: AppDimens.fontSizeMedium,
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
                primary: Colors.red, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      setState(() {
        _isVisibleDate = false;
        _focusedDay = value ?? DateTime.now();
      });
      print("Hello: $value $_focusedDay");
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
                primary: Colors.red, // button text color
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
                primary: Colors.red, // button text color
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
                          "${_focusedDay.day}/${_focusedDay.month}/${_focusedDay.year}",
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
                showAlertDialog(_scaffoldKey.currentContext!);
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
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  } else {
                    print("Failed");
                    Navigator.pop(_scaffoldKey.currentContext!);
                    FlushBarWidget fbw = new FlushBarWidget();
                    fbw.flushBar(
                      context: _scaffoldKey.currentContext!,
                      title: "Error",
                      message: "Client not assigned",
                      backgroundColor: AppColors.error,
                    );
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pop(context);
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
      yield Text(
          "Selected Date: ${_focusedDay.year}-${_focusedDay.month}-${_focusedDay.day}");
    }
  }
}
