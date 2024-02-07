import 'dart:io';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:MoreThanInvoice/backend/encrypt_decrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

// Function to send email with attached PDF
Future<dynamic> sendEmailWithAttachment(
    String pdfPath,
    List<String> invoiceName,
    String endDate,
    String invoiceNumber,
    String email,
    String genKey) async {
  ApiMethod apiMethod = ApiMethod();
  final emailDetails = await apiMethod.getEmailDetailToSendEmail(email);
  debugPrint('Email Details: ${emailDetails['accessToken']}');
  if (emailDetails.containsKey('Error')) {
    return 'error';
  } else {
    String accessToken = emailDetails['accessToken'];
    String emailAddress = emailDetails['emailAddress'];
    String recipientEmail = emailDetails['recipientEmail'];
    debugPrint('Access Token: $accessToken and genKey: $genKey');
    String appPassword = EncryptDecrypt.decryptPassword(accessToken, genKey);
    debugPrint(
        'App Password: $appPassword and Email Address: $emailAddress, $email');
    final smtpServer = SmtpServer(
      'smtp.gmail.com',
      username: emailAddress,
      password: appPassword,
    );
    debugPrint('From: $emailAddress and To: $recipientEmail');
    final message = Message()
      ..from = Address(emailAddress)
      ..recipients.add(email)
      ..subject = 'Invoice Number: $invoiceNumber'
      ..text =
          "Hello,\n\nI have attached the invoice for the pay period ending $endDate.\n\nThank you,\n\nRegards,\n${invoiceName[0]}"
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
}
