import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

// Function to send email with attached PDF
Future<dynamic> sendEmailWithAttachment() async {

  String emailAddress = dotenv.env['EMAIL_ADDRESS']!;
  String emailPassword = dotenv.env['EMAIL_PASSWORD']!;
  String recipientEmail = dotenv.env['RECIPIENT_EMAIL_ADDRESS']!;
  final serviceId = dotenv.env['SERVICE_ID']!;
  final templateId = dotenv.env['TEMPLATE_ID']!;
  final userId = dotenv.env['USER_ID']!;
  final privateKey = dotenv.env['PRIVATE_KEY']!;
  print('$emailAddress $recipientEmail');

  final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'accessToken': privateKey,
      'service_id': serviceId,
      'template_id': templateId,
      'user_id': userId,
      'template_params': {
        'user_name': 'James',
        'user_subject': 'Invoice',
        'recipient_email': recipientEmail,
        'user_email': emailAddress,
        'message': 'Hello World!'
      },
    }),
  );
  print(response.body);


return response.body;
}