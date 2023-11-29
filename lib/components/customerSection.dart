import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_business/components/chart/line_chart.dart';
import 'package:hive_business/components/chart/pie_chart.dart';
import 'package:hive_business/components/statistics.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';

import 'chart/bar_charts.dart';

class CustomerSection extends StatelessWidget {
  const CustomerSection({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Customers Growth',
          style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.mediumSmall),
        ),
        SizedBox(
          height: AppSizes.extraSmall,
        ),
        Statistics(
          columnMonthly: currentMonth.toString(),
          columnYTD: '0',
          columnYearly: '0',
        ),
        SizedBox(
          height: AppSizes.extraSmall,
        ),
      ],
    );
  }
}
