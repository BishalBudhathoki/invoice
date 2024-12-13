import 'package:MoreThanInvoice/app/features/invoice/services/download_service.dart';
import 'package:MoreThanInvoice/app/features/invoice/services/invoice_email_service.dart';
import 'package:MoreThanInvoice/app/features/invoice/services/invoice_pdf_generator_service.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:get_it/get_it.dart';
import 'package:MoreThanInvoice/app/features/invoice/viewmodels/invoice_email_viewmodel.dart';
import 'package:MoreThanInvoice/app/features/invoice/viewmodels/line_items_viewmodel.dart';
import 'package:MoreThanInvoice/app/features/invoice/viewmodels/update_invoice_email_viewmodel.dart';
import 'package:MoreThanInvoice/app/shared/utils/encryption/encrypt_decrypt.dart';
import 'package:MoreThanInvoice/app/shared/utils/encryption/encryption_utils.dart';
import 'package:MoreThanInvoice/app/shared/utils/shared_preferences_utils.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  // Register services
  locator.registerLazySingleton<ApiMethod>(() => ApiMethod());
  locator.registerLazySingleton<DownloadService>(() => DownloadService());
  locator
      .registerLazySingleton<InvoiceEmailService>(() => InvoiceEmailService());
  locator
      .registerLazySingleton<InvoicePdfGenerator>(() => InvoicePdfGenerator());

  // Register view models
  locator.registerFactory<InvoiceEmailViewModel>(() => InvoiceEmailViewModel());
  locator.registerFactory<LineItemViewModel>(() => LineItemViewModel());
  locator.registerFactory<UpdateInvoiceEmailViewModel>(
      () => UpdateInvoiceEmailViewModel());

  // Register utilities
  locator.registerLazySingleton<EncryptDecrypt>(() => EncryptDecrypt());
  locator.registerLazySingleton<EncryptionUtils>(() => EncryptionUtils());
  locator.registerLazySingleton<SharedPreferencesUtils>(
      () => SharedPreferencesUtils());
}
