import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HolidayListView extends StatefulWidget {
  final List<dynamic> holidays;

  const HolidayListView({super.key, required this.holidays});

  @override
  _HolidayListViewState createState() => _HolidayListViewState();
}

class _HolidayListViewState extends State<HolidayListView> {
  @override
  void initState() {
    super.initState();
    // Sort the list of holidays by date
    widget.holidays.sort((a, b) => DateFormat("dd-MM-yyyy")
        .parse("${a['Date']}")
        .compareTo(DateFormat("dd-MM-yyyy").parse("${b['Date']}")));
  }

  void _addHoliday(Map<String, dynamic> holiday) {
    setState(() {
      // Add the new holiday to the list
      widget.holidays.add(holiday);
      widget.holidays.sort((a, b) => DateFormat("dd-MM-yyyy")
          .parse("${a['Date']}")
          .compareTo(DateFormat("dd-MM-yyyy").parse("${b['Date']}")));
    });
  }

  var holiday = {};
  void _deleteHoliday(int index) {
    setState(() {
      holiday = widget.holidays[index];
      print(holiday['_id']);
      _deleteHolidayItem(holiday['_id']);
      // Remove the holiday at the specified index from the list
      widget.holidays.removeAt(index);
    });
  }

  ApiMethod apiMethod = ApiMethod();

  Future<dynamic> _deleteHolidayItem(String id) async {
    // print("Username:  ${_userEmailController.text.trim()}");
    // print("Password:  ${_passwordController.text.trim()}");
    var ins = await apiMethod.deleteHolidayItem(
      id,
    );
    //print("Response: "+ ins['email'].toString() + ins['password'].toString());
    return ins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Holidays',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.holidays.length,
        itemBuilder: (context, index) {
          final holiday = widget.holidays[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              // Remove the holiday from the list when it is dismissed
              _deleteHoliday(index);
            },
            movementDuration: const Duration(milliseconds: 200),
            dismissThresholds: const {
              DismissDirection.endToStart: 0.8,
            },
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              color: Colors.red,
              child: const Center(
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: ListTile(
              title: Text(
                holiday['Holiday'],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                ),
              ),
              subtitle: Text("${holiday['Date']} ${holiday['Day']}"),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to add holiday screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddHolidayScreen(
                addHoliday: _addHoliday,
                holidays: widget
                    .holidays, // Pass the holidays list to AddHolidayScreen
              ),
            ),
          );
        },
      ),
    );
  }
}

class AddHolidayScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) addHoliday;
  final List<dynamic> holidays; // Add a parameter for the holidays list

  const AddHolidayScreen({
    super.key,
    required this.addHoliday,
    required this.holidays,
  });

  @override
  _AddHolidayScreenState createState() => _AddHolidayScreenState();
}

class _AddHolidayScreenState extends State<AddHolidayScreen> {
  // Declare variables to store new holiday data
  final TextEditingController _holidayController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();

  ApiMethod apiMethod = ApiMethod();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Holiday',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Holiday Name'),
            TextField(
              controller: _holidayController,
              decoration: const InputDecoration(
                hintText: 'Enter holiday name',
              ),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Holiday Date'),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(hintText: 'Enter holiday date'),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            const Text('Holiday Day'),
            TextField(
              controller: _dayController,
              decoration: const InputDecoration(hintText: 'Enter holiday day'),
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              child: const Text(
                'Add Holiday',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                // Create a new map object with the new holiday data
                final newHoliday = {
                  'Holiday': _holidayController.text,
                  'Date': _dateController.text,
                  'Day': _dayController.text,
                };

                // Add the new holiday to the list
                widget.addHoliday(newHoliday);
                _addHolidayItem(newHoliday);
                // Return to the previous screen
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _addHolidayItem(Map<String, String> holiday) async {
    // print("Username:  ${_userEmailController.text.trim()}");
    // print("Password:  ${_passwordController.text.trim()}");
    var ins = await apiMethod.addHolidayItem(
      holiday,
    );
    if (ins['status'] == 'success') {
      print("Holiday Added");
    } else {
      print("Holiday Not Added ${ins['message']}");
    }
    //print("Response: "+ ins['email'].toString() + ins['password'].toString());
    return ins;
  }
}

// /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphonesimulator.a
