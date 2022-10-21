import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseController extends GetxController with StateMixin {
  void initData();

  void onViewReady();

  void disposeData();

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  @override
  void onReady() {
    super.onReady();
    change(null, status: RxStatus.success());
    onViewReady();
  }

  @override
  void onClose() {
    disposeData();
    super.onClose();
  }

  void hideKeyboard() {
    FocusScope.of(Get.context!).unfocus();
  }
}
