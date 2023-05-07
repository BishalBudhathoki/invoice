import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// Function to send email with attached PDF
Future<dynamic> sendEmailWithAttachment(String pdfPath, List<String> invoiceName, String endDate, String invoiceNumber) async {

  String emailAddress = dotenv.env['EMAIL_ADDRESS']!;
  String recipientEmail = dotenv.env['RECIPIENT_EMAIL_ADDRESS']!;
  final accessToken = dotenv.env['ACCESS_TOKEN']!;

  final smtpServer = SmtpServer('smtp.gmail.com',
      username: emailAddress,
      password: accessToken,
      );

  final message = Message()
    ..from = Address(emailAddress)
    ..recipients.add(recipientEmail)
    ..subject = 'Invoice Number: $invoiceNumber'
    ..text = "Hello,\n\nI have attached the invoice for the pay period ending $endDate.\n\nThank you,\n\nRegards,\n${invoiceName[0]}"
    ..attachments.add(FileAttachment(File(pdfPath)));

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: $sendReport');
    return 'Success';
  } on MailerException catch (e) {
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
    return 'Error';
  }
}