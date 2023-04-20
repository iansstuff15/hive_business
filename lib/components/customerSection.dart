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
        Statistics(),
        SizedBox(
          height: AppSizes.extraSmall,
        ),
        AppLineChart()
      ],
    );
  }
}
