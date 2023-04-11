import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class BaseScreen<BaseController>
    extends GetResponsiveView<BaseController> {
  Widget phoneView();

  Widget tabletView();

  Widget desktopView();

  @override
  Widget? phone() {
    return phoneView();
  }

  @override
  Widget? tablet() {
    return tabletView();
  }

  @override
  Widget? desktop() {
    return desktopView();
  }
}
