// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:enhance_stepper/enhance_stepper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/AppButton.dart';
import 'package:hive_business/components/AppInput.dart';
import 'package:hive_business/components/AppTextButton.dart';
import 'package:hive_business/helper/firebase.dart';
import 'package:hive_business/screens/forgotPassword.dart';
import 'package:hive_business/screens/login.dart';
import 'package:hive_business/utilities/sizes.dart';

class Register extends StatefulWidget {
  static String id = "register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    BottomLoader bl = BottomLoader(context,
        isDismissible: false,
        showLogs: false,
        loader: CircularProgressIndicator(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.small),
                topRight: Radius.circular(AppSizes.small))));
    return Scaffold(
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: AppSizes.mediumSmall,
                  vertical: AppSizes.extraSmall),
              child: Flexible(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: AppSizes.small, sigmaY: AppSizes.small),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Sign up to continue!",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: AppSizes.mediumLarge),
                            ),
                            SizedBox(
                              height: AppSizes.small,
                            ),
                            SizedBox(
                              height: AppSizes.extraSmall,
                            ),

                            SizedBox(
                              height: AppSizes.small,
                            ),
                            AppInput("Email", TextInputType.emailAddress,
                                emailAddress),
                            SizedBox(
                              height: AppSizes.small,
                            ),
                            AppInput(
                              "Password",
                              TextInputType.text,
                              password,
                              obsure: true,
                            ),
                            SizedBox(
                              height: AppSizes.small,
                            ),

                            // AppButton(
                            //   "Previous",
                            //   () => {},
                            //   width: double.infinity,
                            //   height: AppSizes.mediumLarge,
                            //   textSize: AppSizes.small,
                            //   textWeight: FontWeight.bold,
                            //   background: Colors.white,
                            //   foreground: Colors.black,
                            // ),
                            AppButton(
                              "Sign up",
                              () async {
                                await bl.display();
                                bl.style(message: 'Trying to register user');
                                String response = await FirebaseManager()
                                    .registerUser(
                                        emailAddress.text, password.text);
                                ElegantNotification(
                                        icon: response == "success"
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.error_rounded,
                                                color: Colors.redAccent,
                                              ),
                                        showProgressIndicator: false,
                                        displayCloseButton: false,
                                        title: Text(response == "success"
                                            ? "Sucess"
                                            : "Error"),
                                        description: Text(response == 'success'
                                            ? "Verification link sent"
                                            : response))
                                    .show(context);
                                bl.close();
                                if (response == 'success') {
                                  Get.toNamed(Login.id);
                                }
                              },
                              width: double.infinity,
                              height: AppSizes.mediumLarge,
                              textSize: AppSizes.small,
                              textWeight: FontWeight.bold,
                            ),
                            SizedBox(
                              height: AppSizes.small,
                            ),
                            // AppButton(
                            //   "Sign in with Google",
                            //   () => {},
                            //   width: double.infinity,
                            //   height: AppSizes.mediumLarge,
                            //   textSize: AppSizes.small,
                            //   textWeight: FontWeight.bold,
                            //   background: Colors.white,
                            //   foreground: Colors.black,
                            //   icon: 'assets/google.svg',
                            // ),
                            // SizedBox(
                            //   height: AppSizes.small,
                            // ),
                            AppTextButton(
                              "Already have an account? Login",
                              () => {Get.toNamed(Login.id)},
                              width: double.infinity,
                            ),
                          ],
                        ),
                      ))))),
    );
  }
}
