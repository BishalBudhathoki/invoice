// import 'package:MoreThanInvoice/app/features/invoice/services/invoice_email_service.dart';
// import 'package:MoreThanInvoice/app/features/invoice/utils/invoice_helpers.dart';
// import 'package:MoreThanInvoice/app/features/invoice/utils/invoice_data_processor.dart';
// import 'package:MoreThanInvoice/app/features/invoice/services/invoice_pdf_generator_service.dart';
// import 'package:MoreThanInvoice/backend/api_method.dart';
// import 'package:get/get.dart';
// import 'package:MoreThanInvoice/app/features/invoice/models/invoice_model.dart';
// import 'package:MoreThanInvoice/app/features/invoice/repositories/invoice_repository.dart';
//
// class InvoiceGeneratorViewModel extends GetxController {
//   final InvoiceRepository _repository;
//   final InvoiceHelpers _helpers;
//   final InvoiceEmailService _emailService;
//   final InvoiceDataProcessor _dataProcessor;
//   final InvoicePdfGenerator _pdfGenerator;
//
//   final RxList<InvoiceModel> invoices = <InvoiceModel>[].obs;
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   InvoiceGeneratorViewModel({
//     required InvoiceRepository repository,
//     required InvoiceHelpers helpers,
//     required InvoiceEmailService emailService,
//     required InvoiceDataProcessor dataProcessor,
//     required InvoicePdfGenerator pdfGenerator,
//   })  : _repository = repository,
//         _helpers = helpers,
//         _emailService = emailService,
//         _dataProcessor = dataProcessor,
//         _pdfGenerator = pdfGenerator;
//
//   Future<List<String>> generateInvoicesForAllUsers() async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final assignedClients = await _repository.getAssignedClients();
//       final lineItems = await _repository.getLineItems();
//
//       // Process data and create invoice models
//       final processedData = await _dataProcessor.processInvoiceData(
//         assignedClients: assignedClients,
//         lineItems: lineItems,
//       );
//
//       invoices.value = (processedData['clients'] as List)
//           .map((data) => InvoiceModel.fromJson(data))
//           .toList();
//
//       // Generate PDFs for each invoice
//       final pdfPaths = await _pdfGenerator.generatePdfs(invoices);
//       return pdfPaths;
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return [];
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<bool> sendInvoiceEmails(
//       String zipFilePath, String email, String genKey) async {
//     try {
//       isLoading.value = true;
//       errorMessage.value = '';
//
//       final result = await _emailService.sendInvoiceEmail(
//         zipFilePath: zipFilePath,
//         invoices: invoices,
//         email: email,
//         genKey: genKey,
//       );
//
//       return result == "Success";
//     } catch (e) {
//       errorMessage.value = e.toString();
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
