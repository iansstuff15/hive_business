import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/AppButton.dart';
import 'package:hive_business/components/AppLayout.dart';
import 'package:hive_business/components/AppRating.dart';
import 'package:hive_business/components/AppTextButton.dart';
import 'package:hive_business/components/FeaturedImage.dart';
import 'package:hive_business/components/card.dart';
import 'package:hive_business/components/contactInfo.dart';
import 'package:hive_business/components/editUserInfo.dart';
import 'package:hive_business/components/logoutConfirm.dart';
import 'package:hive_business/components/storeHours.dart';
import 'package:hive_business/utilities/colors.dart';

import '../utilities/sizes.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});
  static String id = 'profile';
  @override
  Widget build(BuildContext context) {
    return AppLayout(SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: AppSizes.tweenSmall,
        ),
        AppCard(),
        SizedBox(
          height: AppSizes.tweenSmall,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: AppSizes.extraSmall,
            ),
            AppTextButton(
              "Logout",
              () {
                Get.bottomSheet(LogoutConfirm(),
                    backgroundColor: AppColors.scaffoldBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppSizes.mediumLarge),
                            topRight: Radius.circular(AppSizes.mediumLarge))));
              },
            ),
          ],
        ),
        SizedBox(
          height: AppSizes.tweenSmall,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ContactInfo(),
              StoreHours(),
              FeaturedImage(),
              AppRating(),
            ],
          ),
        )
      ],
    )));
  }
}
