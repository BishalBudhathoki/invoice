import 'package:MoreThanInvoice/app/features/busineess/models/addBusiness_detail_model.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/widgets/button_widget.dart';
import 'package:MoreThanInvoice/app/shared/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:MoreThanInvoice/app/features/busineess/viewmodels/add_business_viewmodel.dart';
import 'package:provider/provider.dart';

class AddBusinessDetails extends StatelessWidget {
  const AddBusinessDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AddBusinessViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Business Details',
          style: TextStyle(
            color: AppColors.colorFontSecondary,
          ),
        ),
      ),
      body: Form(
        key: viewModel.formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFieldWidget<AddBusinessDetailModel>(
              hintText: 'Business Name',
              controller: viewModel.businessNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business name';
                }
                return null;
              },
              prefixIconData: Icons.business,
              onChanged: (value) {},
              onSaved: (value) {
                viewModel.businessNameController.text = value!;
              },
              obscureTextNotifier: ValueNotifier<bool>(false), // Add this line
              suffixIconClickable: false, // Add this line
            ),
            const SizedBox(height: 16),
            TextFieldWidget<AddBusinessDetailModel>(
              hintText: 'Business Email',
              controller: viewModel.businessEmailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business email';
                }
                return null;
              },
              prefixIconData: Icons.email,
              onChanged: (value) {},
              onSaved: (value) {
                viewModel.businessEmailController.text = value!;
              },
              obscureTextNotifier: ValueNotifier<bool>(false), // Add this line
              suffixIconClickable: false, // Add this line
            ),
            const SizedBox(height: 16),
            TextFieldWidget<AddBusinessDetailModel>(
              hintText: 'Business Phone',
              controller: viewModel.businessPhoneController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business phone';
                }
                return null;
              },
              prefixIconData: Icons.phone,
              onChanged: (value) {},
              onSaved: (value) {
                viewModel.businessPhoneController.text = value!;
              },
              obscureTextNotifier: ValueNotifier<bool>(false), // Add this line
              suffixIconClickable: false, // Add this line
            ),
            const SizedBox(height: 16),
            TextFieldWidget<AddBusinessDetailModel>(
              hintText: 'Business Address',
              controller: viewModel.businessAddressController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business address';
                }
                return null;
              },
              prefixIconData: Icons.location_on,
              onChanged: (value) {},
              onSaved: (value) {
                viewModel.businessAddressController.text = value!;
              },
              obscureTextNotifier: ValueNotifier<bool>(false), // Add this line
              suffixIconClickable: false, // Add this line
            ),
            const SizedBox(height: 16),
            TextFieldWidget<AddBusinessDetailModel>(
              hintText: 'Business City',
              controller: viewModel.businessCityController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business city';
                }
                return null;
              },
              prefixIconData: Icons.location_city,
              onChanged: (value) {},
              onSaved: (value) {
                viewModel.businessCityController.text = value!;
              },
              obscureTextNotifier: ValueNotifier<bool>(false), // Add this line
              suffixIconClickable: false, // Add this line
            ),
            const SizedBox(height: 16),
            TextFieldWidget<AddBusinessDetailModel>(
              hintText: 'Business State',
              controller: viewModel.businessStateController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business state';
                }
                return null;
              },
              prefixIconData: Icons.map,
              onChanged: (value) {},
              onSaved: (value) {
                viewModel.businessStateController.text = value!;
              },
              obscureTextNotifier: ValueNotifier<bool>(false), // Add this line
              suffixIconClickable: false, // Add this line
            ),
            const SizedBox(height: 16),
            TextFieldWidget<AddBusinessDetailModel>(
              hintText: 'Business Zip',
              controller: viewModel.businessZipController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter business zip';
                }
                return null;
              },
              prefixIconData: Icons.code,
              onChanged: (value) {},
              onSaved: (value) {
                viewModel.businessZipController.text = value!;
              },
              obscureTextNotifier: ValueNotifier<bool>(false), // Add this line
              suffixIconClickable: false, // Add this line
            ),
            const SizedBox(height: 16),
            ButtonWidget(
              title: 'Add Business',
              hasBorder: false,
              onPressed: () {
                if (viewModel.formKey.currentState!.validate()) {
                  viewModel.addBusiness(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}