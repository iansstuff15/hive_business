import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_business/components/AppLayout.dart';

class Transactions extends StatelessWidget {
  static String id = 'transactions';
  @override
  Widget build(BuildContext context) {
    return AppLayout(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Text("Transactions")],
    ));
  }
}
