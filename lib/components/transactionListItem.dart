import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_business/utilities/sizes.dart';

class TransactionListItem extends StatefulWidget {
  @override
  State<TransactionListItem> createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.getWitdth(context) * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "March 24, 2023",
              ),
              Text("Sent via Instapay"),
            ],
          ),
          SizedBox(
            height: AppSizes.extraSmall,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "123 456 789 000",
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              Text(
                "₱ 100.00",
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
