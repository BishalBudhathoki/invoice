import 'package:flutter/material.dart';
import 'package:invoice/app/ui/shared/values/colors/app_colors.dart';
import 'package:invoice/app/ui/shared/values/dimens/app_dimens.dart';

class ProfilePlaceholder extends StatelessWidget {
  final String firstName;
  final String lastName;
  final Image image;


  const ProfilePlaceholder({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:  [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Welcome back',
                   style: TextStyle(
                        color: AppColors.colorWhite,
                        fontSize: AppDimens.fontSizeMedium,
                        //fontWeight: AppDimens.fontSizeSmall,
                  )),
              SizedBox(
                height: 10,
              ),
              Text('Pratiksha Tiwari',
                  style: TextStyle(

                    color: AppColors.colorWhite,
                    fontSize: AppDimens.fontSizeLarge,
                    fontWeight: FontWeight.w900,
                  )),
            ],
          ),
          Container(
              width: 55.0,
              height: 55.0,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/pari-profile.png'),
                  )
              )),
        ],
      ),
    );
  }

}