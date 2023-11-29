import 'dart:developer';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/AppInput.dart';
import 'package:hive_business/components/AppLayout.dart';
import 'package:hive_business/components/deleteConfirm.dart';
import 'package:hive_business/components/transactionListItem.dart';
import 'package:hive_business/screens/updateItemPage.dart';
import 'package:hive_business/statemanagement/user/userController.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';

class Services extends StatefulWidget {
  static String id = 'services';

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<String> tags = [];
  UserStateController userInfo = Get.find<UserStateController>();
  TextEditingController searchText = TextEditingController();

  List<String> options = [
    'Completed',
    'Pending',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: AppSizes.mediumSmall, vertical: AppSizes.small),
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Services',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: AppSizes.extraSmall),
              SizedBox(
                width: AppSizes.getWitdth(context),
                child:
                    AppInput("Search service", TextInputType.text, searchText),
              ),

              Obx(() => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('business')
                        .doc(userInfo.user.uid.value)
                        .collection("offers")
                        .snapshots(),
                    builder: (context, snapshot) {
                      try {
                        if (!snapshot.hasData) {
                          return Text("No data");
                        }

                        // If there's data available, display it in a ListView
                        var documents = snapshot.data!.docs;
                        return ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: AppSizes.getHeight(context) * 0.9,
                                maxWidth: AppSizes.getWitdth(context)),
                            child: ListView.separated(
                              itemCount: documents.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: AppSizes.small),
                              itemBuilder: (context, index) {
                                var docdata = documents[index].data();
                                return docdata['name']
                                        .toString()
                                        .contains(searchText.text)
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.container,
                                          borderRadius: BorderRadius.circular(
                                              AppSizes.small),
                                        ),
                                        margin: EdgeInsets.symmetric(
                                          vertical: AppSizes.extraSmall,
                                          horizontal: AppSizes.mediumSmall,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: AppSizes.small),
                                        child: ListTile(
                                          leading: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                  onTap: () {
                                                    print(
                                                        "${docdata["name"]} ${docdata["description"]} ${docdata["price"]} ${docdata["uid"]}");
                                                    Get.toNamed(UpdatePage.id,
                                                        arguments: {
                                                          'name': docdata[
                                                                  "name"] ??
                                                              "No data found",
                                                          'description': docdata[
                                                                  "description"] ??
                                                              "No data found",
                                                          'price':
                                                              "${docdata["price"]}" ??
                                                                  "0",
                                                          'uid': docdata[
                                                                  "uid"] ??
                                                              "No data found"
                                                        });
                                                  },
                                                  child: const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                  )),
                                              GestureDetector(
                                                child: const Icon(
                                                  Icons.delete,
                                                  size: 20,
                                                ),
                                                onTap: () {
                                                  Get.bottomSheet(
                                                      DeleteConfirm(
                                                          docdata["uid"] ??
                                                              "No data found"),
                                                      backgroundColor: AppColors
                                                          .scaffoldBackground,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(AppSizes
                                                                      .mediumLarge),
                                                              topRight:
                                                                  Radius.circular(
                                                                      AppSizes
                                                                          .mediumLarge))));
                                                },
                                              )
                                            ],
                                          ),
                                          title: Text(docdata["name"] ??
                                              "No data found"),
                                          subtitle: Text(
                                              docdata["description"] ??
                                                  "No data found"),
                                          trailing: Text(
                                              '₱ ${docdata["price"] ?? "No data found"}'),
                                        ))
                                    : Container();
                              },
                            ));
                      } catch (e) {
                        print('Error in StreamBuilder: $e');
                      }
                      return Text('Error');
                    },
                  )),

              // Add other sliver widgets here, such as SliverList or SliverGrid
            ],
          ))),
    );
  }
}
