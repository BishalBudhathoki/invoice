import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';

class BusinessNameDropdown extends StatefulWidget {
  final Function(String) onChanged;

  const BusinessNameDropdown({super.key, required this.onChanged});

  @override
  _BusinessNameDropdownState createState() => _BusinessNameDropdownState();
}

class _BusinessNameDropdownState extends State<BusinessNameDropdown> {
  late List<dynamic> _businessNameList = [];
  late String _selectedBusinessName = 'Select Business Name';

  set businessNameList(List<dynamic> businessNameList) {
    _businessNameList = businessNameList;
  }

  ApiMethod apiMethod = ApiMethod();
  @override
  void initState() {
    super.initState();
    _loadBusinessNames();
  }

  Future<void> _loadBusinessNames() async {
    // Call the API method to get the list of business names
    // and update the state with the response data
    final businessNameList = await apiMethod.getBusinessNameList();
    for (var item in businessNameList) {
      print(item);
    }
    if (businessNameList != null) {
      setState(() {
        _businessNameList = businessNameList;
        _businessNameList.insert(0, {'businessName': 'Select Business Name'});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      //padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.colorGrey,
          width: 1,
        ),
      ),
      child: Center(
        child: DropdownButton<String>(
          dropdownColor: AppColors.colorGrey,
          value: _selectedBusinessName,
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: const TextStyle(
            color: AppColors.colorFontPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          underline: Container(
            height: 2,
            color: Colors.transparent,
          ),
          onChanged: (String? selectedValue) {
            setState(() {
              _selectedBusinessName = selectedValue!;
            });
            widget.onChanged(selectedValue!);
          },
          items: _businessNameList
              .map<DropdownMenuItem<String>>(
                (dynamic businessName) => DropdownMenuItem<String>(
                  value: businessName['businessName'],
                  child: Text(
                    businessName['businessName'],
                    style: const TextStyle(
                      color: AppColors.colorFontPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
