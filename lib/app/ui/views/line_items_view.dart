import 'package:animation_list/animation_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MoreThanInvoice/app/core/controllers/lineItem_controller.dart';
import 'package:MoreThanInvoice/app/ui/shared/values/colors/app_colors.dart';

import '../../../backend/api_method.dart';

class LineItemsView extends StatefulWidget {
  const LineItemsView({super.key});

  @override
  _LineItemsControllerState createState() {
    return _LineItemsControllerState();
  }
}

class _LineItemsControllerState extends State<LineItemsView> {
  final ApiMethod apiMethod = ApiMethod();
  final LineItemController lineItemController = Get.put(LineItemController());

  List<Map<String, dynamic>> _lineItems = [];

  @override
  void initState() {
    getLineItems();
    super.initState();
  }

  Future<void> getLineItems() async {
    await lineItemController.getLineItems();
    setState(() {
      _lineItems = lineItemController.lineItems;
    });
  }

  Widget _buildTile(String? title, Color? backgroundColor) {
    return Container(
      height: 75,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: backgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            title!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Line item list with description',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            if (_lineItems.isEmpty) {
              return const Text("No line item retrieved");
            } else {
              return AnimationList(
                duration: 1000,
                reBounceDepth: 10.0,
                children: _lineItems.map((item) {
                  final itemNumber = item.values.first;
                  final itemDescription = item.values.last;
                  return _buildTile(
                    "$itemNumber\n$itemDescription",
                    AppColors.colorPrimary,
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
