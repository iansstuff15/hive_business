import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_business/data%20models/status.dart';
import 'package:hive_business/helper/firebase.dart';
import 'package:hive_business/statemanagement/statusInfo/statusInfoController.dart';
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
  BusinessInfoController _businessInfoController =
      Get.find<BusinessInfoController>();
  StatusInfoController _statusInfoController = Get.find<StatusInfoController>();
  @override
  Widget build(BuildContext context) {
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
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSizes.small),
                ),
                child: Obx(() => Image(
                      image: NetworkImage(_businessInfoController
                          .businessInfo.coverPhoto
                          .toString()),
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                  left: 10,
                  bottom: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.extraLarge),
                    child: Obx(() => Image(
                          image: NetworkImage(_businessInfoController
                              .businessInfo.coverPhoto
                              .toString()),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )),
                  )),
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
                              FirebaseManager().setStatus(user.uid, status);
                            }
                          });
                        } else {
                          FirebaseAuth.instance
                              .authStateChanges()
                              .listen((User? user) {
                            if (user != null) {
                              Status status =
                                  Status(status: true, uid: user.uid);
                              FirebaseManager().setStatus(user.uid, status);
                            }
                          });
                        }
                      },
                      width: double.infinity,
                      background:
                          _statusInfoController.statusInfo.isOnline.value
                              ? Color.fromARGB(255, 214, 101, 93)
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
