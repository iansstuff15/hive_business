import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/AppTextButton.dart';
import 'package:hive_business/components/CustomerReviewItem.dart';
import 'package:hive_business/components/chart/bar_charts.dart';
import 'package:hive_business/components/chart/review_bars.dart';
import 'package:hive_business/statemanagement/businessInfo/businessInfoController.dart';
import 'package:hive_business/statemanagement/user/userController.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:intl/intl.dart';

import '../utilities/sizes.dart';

class AppRating extends StatelessWidget {
  BusinessInfoController businessInfoController =
      Get.find<BusinessInfoController>();
  UserStateController userStateController = Get.find<UserStateController>();
  @override
  Widget build(BuildContext context) {
    double calculateAverageStarRating(List starRatings) {
      print(starRatings.isEmpty);
      if (starRatings.isEmpty) {
        return 0.0;
      }

      double totalStarRating = 0.0;
      for (dynamic doc in starRatings) {
        print("doc.data().toString()");
        print(doc.data().toString());
        if (doc['starRating'] is double) {
          totalStarRating += doc['starRating'];
        }
      }
      return totalStarRating / starRatings.length;
    }

    Map<int, double> countRatings(List starRatings) {
      print(starRatings);
      print("starRatings");
      Map<int, double> ratingsCount = {
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
      };

      for (dynamic doc in starRatings) {
        print("doc.data()");
        print(doc.data());
        if (doc['starRating'] is double) {
          int rating = doc['starRating'].toInt();
          if (rating >= 1 && rating <= 5) {
            ratingsCount[rating] = ratingsCount[rating]! + 1;
          }
        }
      }
      print("ratingsCount");
      print(ratingsCount);
      print(ratingsCount.runtimeType);
      print(ratingsCount[1]);
      print(ratingsCount[2]);
      print(ratingsCount[3]);
      print(ratingsCount[4]);
      print(ratingsCount[5]);
      return ratingsCount;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppSizes.small),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('reviews')
            .where("businessID", isEqualTo: userStateController.user.uid.value)
            .snapshots(),
        builder: (context, snapshot) {
          try {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // If there's data available, display it in a ListView
            var documents = snapshot.data!.docs;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Business Reviews',
                            style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.mediumSmall),
                          ),
                          SizedBox(
                            height: AppSizes.extraSmall,
                          ),
                          Text(
                            'Overall Score',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.small),
                          ),
                          Text(
                            '${calculateAverageStarRating(documents).toStringAsFixed(2)}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.large),
                          )
                        ],
                      ),
                      width: AppSizes.getWitdth(context) * 0.5,
                    ),
                    SizedBox(
                      width: AppSizes.getWitdth(context) * 0.4,
                      height: 150,
                      child: ReviewBarChart(data: countRatings(documents)),
                    )
                  ],
                ),
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                AppTextButton("View All", () {}),
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: AppSizes.getHeight(context) * 0.8,
                        maxWidth: AppSizes.getWitdth(context) * 0.9),
                    child: ListView.separated(
                      itemCount: documents.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppSizes.small),
                      itemBuilder: (context, index) {
                        var docdata = documents[index].data();
                        return CustomerReviewItem(
                          businessID: docdata['businessID'],
                          customerID: docdata['customerID'],
                          starRating: docdata['starRating'],
                          content: docdata['content'],
                          date: DateFormat('MMMM-dd-yyyy')
                              .format(docdata['date'].toDate())
                              .toString(),
                        );
                      },
                    ))
              ],
            );
          } catch (e) {
            print('Error in StreamBuilder: $e');
          }
          return Text('Error');
        },
      ),
    );
  }
}
