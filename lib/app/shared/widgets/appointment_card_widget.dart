import 'package:MoreThanInvoice/app/shared/constants/values/colors/app_colors.dart';
import 'package:MoreThanInvoice/app/shared/constants/values/dimens/app_dimens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MoreThanInvoice/app/features/Appointment/views/client_appointment_details_view.dart';
import 'card_label_text_widget.dart';

class AppointmentCard extends StatelessWidget {
  final String title;
  final String currentUserEmail;
  final String currentClientEmail;

  final IconData iconData;
  final String label;
  final String text;

  final IconData iconData1;
  final String label1;
  final String text1;

  final IconData iconData2;
  final String label2;
  final String text2;

  final IconData iconData3;
  final String label3;
  final String text3;

  const AppointmentCard({
    super.key,
    required this.currentClientEmail,
    required this.currentUserEmail,
    required this.title,
    required this.iconData,
    required this.label,
    required this.text,
    required this.iconData1,
    required this.label1,
    required this.text1,
    required this.iconData2,
    required this.label2,
    required this.text2,
    required this.iconData3,
    required this.label3,
    required this.text3,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: Container(
            //height: context.height * 0.29,
            //height: MediaQuery.of(context).size.height * 0.2,
            //width: context.width * 0.85,
            //width: MediaQuery.of(context).size.width * 0.8,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: AppColors.colorTransparent,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(title,
                        style: const TextStyle(
                          color: AppColors.colorFontPrimary,
                          fontSize: AppDimens.fontSizeXXXMedium,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Lato',
                        )),
                  ),
                  SizedBox(height: context.height * 0.01),
                  CardLabelTextWidget(
                    iconData,
                    label,
                    text,
                  ),
                  //SizedBox(height: context.height * 0.01),
                  CardLabelTextWidget(
                    iconData1,
                    label1,
                    text1,
                  ),
                  //SizedBox(height: context.height * 0.01),
                  CardLabelTextWidget(
                    iconData2,
                    label2,
                    text2,
                  ),
                  //SizedBox(height: context.height * 0.01),
                  CardLabelTextWidget(
                    iconData3,
                    label3,
                    text3,
                  ),
                  SizedBox(
                    height: context.height * 0.01,
                  ),
                  GestureDetector(
                    onTap: () async => {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientAndAppointmentDetails(
                            userEmail: currentUserEmail,
                            clientEmail: currentClientEmail,
                          ),
                        ),
                      )
                    },
                    child: Container(
                      height: context.height * 0.06,
                      width: context.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: AppColors.colorPrimary,
                      ),
                      child: const Center(
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: AppDimens.fontSizeMedium,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
