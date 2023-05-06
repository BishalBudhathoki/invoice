import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// Function to send email with attached PDF
Future<dynamic> sendEmailWithAttachment(String pdfPath) async {

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
    ..subject = 'Invoice'
    ..text = "Hello this is body"
    ..attachments.add(FileAttachment(File(pdfPath)));

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: $sendReport');
    return 'Success';
  } on MailerException catch (e) {
    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }
    return 'Error';
  }
}