import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:hive_business/screens/appPages.dart';
import 'package:hive_business/screens/forgotPassword.dart';
import 'package:hive_business/screens/home.dart';
import 'package:hive_business/screens/login.dart';
import 'package:hive_business/screens/profile.dart';
import 'package:hive_business/screens/register.dart';
import 'package:hive_business/screens/services.dart';
import 'package:hive_business/screens/setupBusiness.dart';
import 'package:hive_business/screens/transactions.dart';
import 'package:hive_business/screens/welcome.dart';
import 'package:hive_business/utilities/themeData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Hive Business',
      theme: AppCommonData.appTheme,
      routes: {
        Welcome.id: (context) => Welcome(),
        Login.id: (context) => Login(),
        ForgotPassword.id: (context) => ForgotPassword(),
        Register.id: (context) => Register(),
        Home.id: (context) => Home(),
        Profile.id: (context) => Profile(),
        AppPages.id: (context) => AppPages(),
        Services.id: (context) => Services(),
        SetupBusiness.id: (context) => SetupBusiness(),
        Transactions.id: (context) => Transactions(),
      },
      initialRoute: Login.id,
    );
  }
}
