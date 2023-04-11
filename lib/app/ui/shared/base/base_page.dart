import 'package:get/get.dart';
import 'package:invoice/app/ui/shared/base/base_screen.dart';

abstract class BasePage extends GetPage {
  BasePage(
      {required String name,
      required BaseScreen screen,
      required Bindings binding})
      : super(name: name, page: () => screen, binding: binding);
}
