import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/statistics.dart';
import 'package:hive_business/components/transactionListItem.dart';
import 'package:hive_business/statemanagement/user/userController.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';
import 'package:intl/intl.dart';

import 'chart/bar_charts.dart';

class EarningsSection extends StatelessWidget {
  UserStateController userInfo = Get.find<UserStateController>();

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int currentMonth = now.month;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Earnings',
          style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: AppSizes.mediumSmall),
        ),
        SizedBox(
          height: AppSizes.extraSmall,
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where("businessID", isEqualTo: userInfo.user.uid.value)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Text('No data available');
            }

            // Process and display your data here
            final documents = snapshot.data!.docs;
            final now = DateTime.now();
            final lastWeek = now.subtract(Duration(days: 7));
            final lastMonth = DateTime(now.year, now.month - 1, now.day);
            final lastYear = DateTime(now.year - 1, now.month, now.day);

            double totalPriceSumLastWeek = 0.0;
            double totalPriceSumLastMonth = 0.0;
            double totalPriceSumLastYear = 0.0;

            for (final document in documents) {
              final docData = document.data() as Map<String, dynamic>;
              final totalPrice = docData['totalPrice']
                  as double; // Adjust the data type if necessary
              final dateBooked = docData['dateBooked'] as String;

              final bookingDate = DateFormat('MM-dd-yyyy').parse(dateBooked);

              if (docData['status'] != 'Completed') {
                continue;
              }
              if (bookingDate.isAfter(lastWeek)) {
                totalPriceSumLastWeek += totalPrice;
              }

              if (bookingDate.isAfter(lastMonth)) {
                totalPriceSumLastMonth += totalPrice;
              }

              if (bookingDate.isAfter(lastYear)) {
                totalPriceSumLastYear += totalPrice;
              }
            }
// Initialize the sum to zero

            return Statistics(
              columnMonthly: totalPriceSumLastMonth.toString(),
              columnYTD: totalPriceSumLastWeek.toString(),
              columnYearly: totalPriceSumLastYear.toString(),
            );
          },
        ),
        SizedBox(
          height: AppSizes.extraSmall,
        ),
        Text(
          "Historic Top Transactions",
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: AppSizes.small),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('orders')
              .where("businessID", isEqualTo: userInfo.user.uid.value)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (!snapshot.hasData) {
              return Text('No data available');
            }

            final documents = snapshot.data!.docs;

            List<Map<String, dynamic>> top5DocData = [];

            for (final document in documents) {
              final docData = document.data() as Map<String, dynamic>;
              final totalPrice = docData['totalPrice'] as double;
              final dateBooked = docData['dateBooked'] as String;

              final date = DateFormat('MM-dd-yyyy').parse(dateBooked);
              final uid = docData['uid'] as String;

              if (docData['status'] != 'Completed') {
                continue;
              }
              if (top5DocData.any((item) => item['uid'] == uid)) {
                continue; // Skip duplicates
              }
              top5DocData.add(docData);
              top5DocData.sort((a, b) => (b['totalPrice'] as double).compareTo(
                  a['totalPrice'] as double)); // Sort in descending order
              if (top5DocData.length > 3) {
                top5DocData.removeLast(); // Keep only the top 5 items
              }
            }

            return ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 200, maxWidth: AppSizes.getWitdth(context) * 0.9),
              child: ListView.builder(
                itemCount: top5DocData.length,
                itemBuilder: (context, index) {
                  final docData = top5DocData[index];
                  return docData['totalPrice'] != 0.0
                      ? TransactionListItem(
                          date: docData['dateBooked'],
                          price: docData['totalPrice'],
                          status: docData['status'],
                          transactionID: docData['uid'],
                          orders: docData['order'] as List<dynamic>,
                          time: docData['timeBooked'],
                          customerID: docData['customerID'],
                          businessID: docData['businessID'],
                          totalPrice: docData['totalPrice'],
                        )
                      : Container();
                },
              ),
            );
          },
        )
      ],
    );
  }
}
