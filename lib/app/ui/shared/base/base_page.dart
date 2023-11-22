import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/base/base_screen.dart';

abstract class BasePage extends GetPage {
  BasePage(
      {required super.name,
      required BaseScreen screen,
      required Bindings super.binding})
      : super(page: () => screen);
}
