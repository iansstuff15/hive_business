// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:elegant_notification/elegant_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/AppButton.dart';
import 'package:hive_business/components/AppInput.dart';
import 'package:hive_business/components/AppTextButton.dart';
import 'package:hive_business/screens/login.dart';
import 'package:hive_business/utilities/sizes.dart';

class ForgotPassword extends StatelessWidget {
  static String id = "forgotpassword";
  TextEditingController emailAddress = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.mediumSmall, vertical: AppSizes.small),
              child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: AppSizes.small, sigmaY: AppSizes.small),
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: AppSizes.mediumLarge),
                        ),
                        SizedBox(
                          height: AppSizes.medium,
                        ),
                        AppInput(
                            "Email", TextInputType.emailAddress, emailAddress),
                        SizedBox(
                          height: AppSizes.small,
                        ),
                        AppButton(
                          "Send email verification",
                          () async => {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(
                                    email: emailAddress.text)
                                .then((value) => {
                                      ElegantNotification(
                                          description: Text("Success"),
                                          icon: Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )).show(context)
                                    })
                                .catchError((error) => {
                                      ElegantNotification(
                                          description: Text("Error: ${error}"),
                                          icon: Icon(
                                            Icons.error_rounded,
                                            color: Colors.redAccent,
                                          )).show(context)
                                    })
                          },
                          width: double.infinity,
                          height: AppSizes.large,
                          textSize: AppSizes.small,
                          textWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: AppSizes.small,
                        ),
                        AppTextButton(
                          "Remembered Password? Login",
                          () => {Get.toNamed(Login.id)},
                          width: double.infinity,
                        ),
                      ],
                    ),
                  )))),
    );
  }
}
