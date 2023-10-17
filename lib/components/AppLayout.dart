import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/AppButton.dart';
import 'package:hive_business/components/AppInput.dart';
import 'package:hive_business/components/addService.dart';
import 'package:hive_business/components/bottomNavigation.dart';
import 'package:hive_business/data%20models/offers.dart';
import 'package:hive_business/helper/firebase.dart';
import 'package:hive_business/statemanagement/user/userController.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';

class AppLayout extends StatefulWidget {
  Widget? body;
  bool? safeTop;
  AppLayout(this.body, {this.safeTop = true});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  UserStateController _userStateController = Get.find<UserStateController>();
  List<Offers> offersList = [];
  TextEditingController productName = TextEditingController();
  TextEditingController productDescription = TextEditingController();
  TextEditingController productPrice = TextEditingController();
  bool disableCTA = true;
  @override
  Widget build(BuildContext context) {
    checkValues() {
      print(
          "prodcuts bool ${productName.text.isEmpty && productDescription.text.isEmpty && productPrice.text.isEmpty}");
      if (productName.text.isEmpty &&
          productDescription.text.isEmpty &&
          productPrice.text.isEmpty) {
        setState(() {
          disableCTA = true;
        });
      } else {
        setState(() {
          disableCTA = false;
        });
      }
    }

    productName.addListener(() {
      checkValues();
    });
    productDescription.addListener(() {
      checkValues();
    });
    productPrice.addListener(() {
      checkValues();
    });

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.bottomSheet(StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
                child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: AppSizes.getHeight(context) * 0.02,
                  horizontal: AppSizes.small),
              child: Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   height: AppSizes.e,
                  // ),

                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: AppSizes.getWitdth(context) * 0.25),
                    decoration: BoxDecoration(
                        color: AppColors.textColor,
                        borderRadius:
                            BorderRadius.circular(AppSizes.mediumSmall)),
                    height: AppSizes.extraSmall,
                    width: AppSizes.getWitdth(context) * 0.5,
                  ),
                  SizedBox(
                    height: AppSizes.mediumSmall,
                  ),
                  Text(
                    "Add your product",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.small,
                    ),
                  ),
                  Text(
                    "Information",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppSizes.mediumSmall,
                        color: AppColors.primary),
                  ),
                  SizedBox(
                    height: AppSizes.mediumSmall,
                  ),
                  AppInput("Name", TextInputType.text, productName),
                  SizedBox(
                    height: AppSizes.small,
                  ),
                  AppInput(
                    "Description",
                    TextInputType.multiline,
                    productDescription,
                    maxLines: 3,
                  ),
                  SizedBox(
                    height: AppSizes.small,
                  ),
                  AppInput("Price (Php)", TextInputType.number, productPrice),
                  SizedBox(
                    height: AppSizes.tweenSmall,
                  ),
                  AppButton(
                    "Add Item",
                    () {
                      setState(() {
                        offersList!.add(Offers(
                            productName.text,
                            productDescription.text,
                            double.parse(productPrice.text)));
                      });
                      FirebaseManager().publishProduct(
                          _userStateController.user.uid.value,
                          Offers(productName.text, productDescription.text,
                              double.parse(productPrice.text)));
                      Get.back();
                    },
                    width: double.infinity,
                    disabled: disableCTA,
                  )
                ],
              )),
            ));
          }),
              backgroundColor: AppColors.scaffoldBackground,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppSizes.mediumLarge),
                      topRight: Radius.circular(AppSizes.mediumLarge))));
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNavigation(),
      body: SafeArea(top: widget.safeTop!, child: widget.body!),
    );
  }
}

Widget _buildBottomSheet(
  BuildContext context,
  ScrollController scrollController,
  double bottomSheetOffset,
) {
  return Material(
    child: AddService(),
  );
}
