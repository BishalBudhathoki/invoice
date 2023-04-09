import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';
import 'package:mongo_dart/mongo_dart.dart';


Future<void> excel() async {
// Connect to remote Excel sheet and retrieve data
  final response = await http.get(
      Uri.parse(
          'https://rwyh-my.sharepoint.com/:x:/g/personal/bishal_rwyh_onmicrosoft_com/ERl6yl3h6RBLucg3vpRV1vMB7pWUG5a10LD7weo0xtYRuw?e=UEafAA&nav=MTVfezAwMDAwMDAwLTAwMDEtMDAwMC0wMDAwLTAwMDAwMDAwMDAwMH0'
      )
  );

  final bytes = response.bodyBytes;


  print(bytes);
  // Parse the data from the Excel sheet
  final excel = Excel.decodeBytes(bytes);
  final table = excel.tables['Sheet1'];
  print(table);
  // Make necessary edits to the data
  for (final row in table?.rows ?? []) {
    row[0]?.value = 'New Value'; // Replace first column with new value
  }
}
