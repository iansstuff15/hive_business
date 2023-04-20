import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_business/components/AppButton.dart';
import 'package:hive_business/components/AppInput.dart';
import 'package:hive_business/components/AppLayout.dart';
import 'package:hive_business/components/chart/bar_charts.dart';
import 'package:hive_business/components/customerSection.dart';
import 'package:hive_business/components/location.dart';
import 'package:hive_business/components/servicesGrid.dart';
import 'package:hive_business/components/transactionsGrid.dart';
import 'package:hive_business/components/card.dart';
import 'package:hive_business/components/earningsSection.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';

import '../statemanagement/businessInfo/businessInfoController.dart';

class Home extends StatelessWidget {
  static String id = 'home';

  @override
  Widget build(BuildContext context) {
    final BusinessInfoController businessInfoController =
        BusinessInfoController();
    return AppLayout(Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSizes.small,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: AppSizes.tweenSmall,
            ),
            AppLocation(),
            SizedBox(
              height: AppSizes.tweenSmall,
            ),
            AppCard(),
            SizedBox(
              height: AppSizes.medium,
            ),
            EarningsSection(),
            SizedBox(
              height: AppSizes.medium,
            ),
            CustomerSection(),
            SizedBox(
              height: AppSizes.medium,
            ),
            TransactionGrid(),
            SizedBox(
              height: AppSizes.medium,
            ),
          ],
        ),
      ),
    ));
  }
}
