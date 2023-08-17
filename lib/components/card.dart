import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_business/data%20models/status.dart';
import 'package:hive_business/helper/firebase.dart';
import 'package:hive_business/statemanagement/statusInfo/statusInfoController.dart';
import 'package:hive_business/statemanagement/user/userController.dart';
import 'package:hive_business/utilities/biometrics.dart';

import '../statemanagement/businessInfo/businessInfoController.dart';
import 'AppButton.dart';
import '../utilities/colors.dart';
import '../utilities/sizes.dart';

class AppCard extends StatefulWidget {
  bool hideInformation = false;
  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  UserStateController userInfo = Get.find<UserStateController>();
  BusinessInfoController _businessInfoController =
      Get.find<BusinessInfoController>();
  StatusInfoController _statusInfoController = Get.find<StatusInfoController>();
  @override
  Widget build(BuildContext context) {
    double calculateTotalPriceSum(List documents) {
      double sum = 0.0; // Use double for the sum

      for (QueryDocumentSnapshot<Map<String, dynamic>> document in documents) {
        Map<String, dynamic>? data = document.data();
        if (data['status'] == 'Completed') {
          if (data != null) {
            sum += data['totalPrice'] ??
                0.toDouble(); // Convert to double if it's a num (int or double)
          }
        }
      }
      print("sum.toString()");
      print(sum.toString());
      return sum;
    }

    return Container(
      decoration: BoxDecoration(
          color: AppColors.scaffoldBackground,
          borderRadius: BorderRadius.circular(AppSizes.small)),
      width: AppSizes.getWitdth(context) * .92,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.extraLarge),
                child: Obx(() => Image(
                      image: NetworkImage(_businessInfoController
                          .businessInfo.profilePicFile
                          .toString()),
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )),
              )
            ],
          ),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                Obx(() => Text(
                      _businessInfoController.businessInfo.businessName
                          .toString(),
                      style: TextStyle(
                          fontSize: AppSizes.small,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary),
                    )),
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                Obx(() => Text(
                      _businessInfoController.businessInfo.businessType
                          .toString(),
                      style: TextStyle(
                        fontSize: AppSizes.small,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                Obx(() => Text(
                      _businessInfoController.businessInfo.description
                          .toString(),
                      style: TextStyle(fontSize: AppSizes.tweenSmall),
                    )),
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(AppSizes.small),
                    decoration: BoxDecoration(
                        color: AppColors.container,
                        borderRadius:
                            BorderRadius.circular(AppSizes.extraSmall)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Earning',
                          style: TextStyle(
                              fontSize: AppSizes.small,
                              fontWeight: FontWeight.bold),
                        ),
                        Obx(() => StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('orders')
                                  .where(
                                    "businessID",
                                    isEqualTo: userInfo.user.uid.value,
                                  )
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                var documents = snapshot.data!.docs;
                                print(documents.runtimeType);
                                print(documents.toString());
                                print(documents.isEmpty);
                                return Text(
                                  '₱ ${calculateTotalPriceSum(documents)}',
                                  style: TextStyle(fontSize: AppSizes.small),
                                );
                              },
                            )),
                      ],
                    )),
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                Obx(() => AppButton(
                      _statusInfoController.statusInfo.isOnline.value
                          ? "Go Offline"
                          : "Go Online",
                      () {
                        if (_statusInfoController.statusInfo.isOnline.value) {
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user != null) {
                              Status status =
                                  Status(status: false, uid: user.uid);
                              FirebaseManager().setStatus(
                                  user.uid,
                                  status,
                                  _businessInfoController
                                      .businessInfo.businessLat.value,
                                  _businessInfoController
                                      .businessInfo.businessLng.value);
                            }
                          });
                        } else {
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user != null) {
                              Status status =
                                  Status(status: true, uid: user.uid);
                              FirebaseManager().setStatus(
                                  user.uid,
                                  status,
                                  _businessInfoController
                                      .businessInfo.businessLat.value,
                                  _businessInfoController
                                      .businessInfo.businessLng.value);
                            }
                          });
                        }
                      },
                      width: double.infinity,
                      background:
                          _statusInfoController.statusInfo.isOnline.value
                              ? AppColors.textBox
                              : AppColors.primary,
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
