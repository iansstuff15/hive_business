import 'dart:ffi';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';

class Statistics extends StatefulWidget {
  String? columnMonthly;
  String? columnYTD;
  String? columnYearly;
  Statistics(
      {required this.columnMonthly,
      required this.columnYTD,
      required this.columnYearly});
  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(AppSizes.small)),
        padding: EdgeInsets.all(AppSizes.small),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Monthly ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.columnMonthly!),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Year to Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.columnYTD!),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yearly',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(widget.columnYearly!),
              ],
            )
          ],
        ));
  }
}
