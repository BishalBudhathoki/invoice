import 'dart:io';
import 'package:MoreThanInvoice/app/core/controllers/generateInvoice_controller.dart';
import 'package:MoreThanInvoice/backend/invoiceDataProcessor.dart';
import 'package:MoreThanInvoice/backend/invoicePDFGenerator.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:MoreThanInvoice/app/core/view-models/sendEmail_model.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/ui/views/pdfViewPage_view.dart';
import 'package:MoreThanInvoice/app/ui/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/ui/widgets/flushbar_widget.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:MoreThanInvoice/backend/downloadInvoice.dart';

class GenerateInvoiceForAllUser extends StatefulWidget {
  final String email;
  final String genKey;
  const GenerateInvoiceForAllUser(this.email, this.genKey, {super.key});

  @override
  _GenerateInvoiceForAllUserState createState() => _GenerateInvoiceForAllUserState();
}

class _GenerateInvoiceForAllUserState extends State<GenerateInvoiceForAllUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ApiMethod apiMethod = ApiMethod();
  Future<List<String>>? _generateInvoiceFuture;
  InvoicePdfGenerator pdfGenerator = InvoicePdfGenerator();
  InvoiceDataProcessor dataProcessor = InvoiceDataProcessor();

  @override
  void initState() {
    super.initState();
    _generateInvoiceFuture = generateInvoiceForAllUser();
  }

  Future<List<String>> generateInvoiceForAllUser() async {
    final assignedClients = await apiMethod.getAssignedClients();
    final processedData = await dataProcessor.processInvoiceData(assignedClients);
    return pdfGenerator.generatePdfs(processedData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _scaffoldKey,
      color: Colors.white,
      child: FutureBuilder<List<String>>(
        future: _generateInvoiceFuture,
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.5,
                    height: MediaQuery.of(context).size.height / 15,
                    child: ButtonWidget(
                      title: 'Try Again',
                      hasBorder: false,
                      onPressed: () {
                        setState(() {
                          _generateInvoiceFuture = generateInvoiceForAllUser();
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No invoices generated'));
          }
          List<String> pdfPaths = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...pdfPaths.map((path) => SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  child: PdfViewPage(pdfPath: path),
                )).toList(),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 15,
                  child: ButtonWidget(
                    title: 'Download PDFs',
                    onPressed: () => downloadFiles(pdfPaths),
                    hasBorder: false,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.5,
                  height: MediaQuery.of(context).size.height / 15,
                  child: Consumer<SendEmailModel>(
                    builder: (context, model, child) {
                      return ElevatedButton(
                        onPressed: model.isLoading
                            ? null
                            : () async {
                          model.setIsLoading(true);
                          var response = await sendEmailWithAttachment(
                              pdfPaths.first,
                              dataProcessor.invoiceName,
                              dataProcessor.endDate,
                              dataProcessor.invoiceNumber,
                              widget.email,
                              widget.genKey);
                          if (response == "Success") {
                            model.setIsResponseReceived(true);
                            FlushBarWidget().flushBar(
                              context: _scaffoldKey.currentContext!,
                              title: "Success",
                              message: "Email sent successfully",
                              backgroundColor: AppColors.colorSecondary,
                            );
                            Future.delayed(const Duration(seconds: 3), () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                          } else {
                            model.setIsResponseReceived(false);
                            FlushBarWidget().flushBar(
                              context: _scaffoldKey.currentContext!,
                              title: "Error",
                              message: "Email not sent",
                              backgroundColor: AppColors.colorWarning,
                            );
                          }
                          model.setIsLoading(false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: model.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                          'Send Email',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}