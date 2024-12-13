import 'dart:convert';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/backend/api_method.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'add_update_invoice_email_view.dart';

class InvoicingEmailView extends StatefulWidget {
  final String email;
  final String genKey;
  const InvoicingEmailView(this.email, this.genKey, {super.key});

  @override
  _InvoicingEmailViewState createState() => _InvoicingEmailViewState();
}

class _InvoicingEmailViewState extends State<InvoicingEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var initialData = {};
  bool _isLoading = true;
  final _passwordController = TextEditingController();
  ApiMethod apiMethod = ApiMethod();
  final passwordVisibleNotifier = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
  }

  Future<Object> getInvoicingEmailDetails(String email) async {
    try {
      var response =
          await apiMethod.getInvoicingEmailDetails(email, widget.genKey);
      debugPrint('getInvoicingEmailDetails Response: $response');
      if (response is String) {
        initialData = jsonDecode(response as String);
      } else {
        initialData = response;
      }
      print("initialData $initialData");
      return initialData;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('InvoicingEmailView key: ${widget.genKey}');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Invoicing Email Details',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: Container(
        height: context.height * 0.34,
        width: context.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: AppColors.colorTransparent,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FutureBuilder(
            future: getInvoicingEmailDetails(widget.email),
            builder: (BuildContext context, AsyncSnapshot<Object> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasError) {
                return Column(
                  children: [
                    Text('Error fetching data: ${snapshot.error}',
                        style: const TextStyle(
                            fontSize: AppDimens.fontSizeXXMedium)),
                    SizedBox(height: context.height * 0.02),
                    _buildAddInvoicingEmailButton(),
                  ],
                );
              }
              if (snapshot.hasData) {
                Map<String, dynamic> data =
                    snapshot.data as Map<String, dynamic>;
                if (data['message'] == 'Encryption key not found') {
                  //debugPrint("Before one: $key");

                  debugPrint('One ${{widget.genKey}}');
                  if (widget.genKey == "update" || widget.genKey == "error") {
                    debugPrint('Two');
                    return Column(
                      children: [
                        const Text('Error fetching encryption key',
                            style: TextStyle(
                                fontSize: AppDimens.fontSizeXXMedium)),
                        SizedBox(height: context.height * 0.02),
                        _buildAddInvoicingEmailButton(),
                      ],
                    );
                  } else {
                    debugPrint('Three');
                    return _buildIfKeyFound(data);
                  }
                } else if (data['message'] ==
                    'No invoicing email details found') {
                  debugPrint('4');
                  return Center(
                    child: Row(
                      children: [
                        Text(data['message']),
                        _buildAddInvoicingEmailButton(),
                      ],
                    ),
                  );
                } else if (data['message'] == 'Invoicing email details found') {
                  debugPrint('5');
                  return _buildIfKeyFound(data);
                } else {
                  debugPrint('6');
                  return Column(
                    children: [
                      const Text("No data found",
                          style:
                              TextStyle(fontSize: AppDimens.fontSizeXXMedium)),
                      SizedBox(height: context.height * 0.02),
                      _buildAddInvoicingEmailButton(),
                    ],
                  );
                }
              }
              debugPrint('7');
              return Column(
                children: [
                  const Text("No data found",
                      style: TextStyle(fontSize: AppDimens.fontSizeXXMedium)),
                  SizedBox(height: context.height * 0.02),
                  _buildAddInvoicingEmailButton(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAddInvoicingEmailButton() {
    return ButtonWidget(
      title: 'Add Invoicing Email Detail',
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddUpdateInvoicingEmailView(widget.email, widget.genKey)));
      },
      hasBorder: false,
    );
  }

  Widget _buildIfKeyFound(Map<String, dynamic> data) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'Invoicing Email',
                      style: TextStyle(
                        color: AppColors.colorPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Business Name: ',
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            data['businessName'] ?? 'No name found',
                            style: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Email: ',
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            data['email'] ?? 'No email found',
                            style: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Text(
                          'Password: ',
                          style: TextStyle(
                            color: AppColors.colorPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            initialData['password'] ?? 'No password found',
                            style: const TextStyle(
                              color: AppColors.colorPrimary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    _buildAddInvoicingEmailButton(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
