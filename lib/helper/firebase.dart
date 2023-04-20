import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_business/data%20models/location.dart';
import 'package:hive_business/data%20models/status.dart';
import 'package:hive_business/data%20models/storeInfo.dart';
import 'package:hive_business/screens/appPages.dart';
import 'package:hive_business/screens/home.dart';
import 'package:hive_business/screens/setupBusiness.dart';
import 'package:hive_business/statemanagement/businessInfo/businessInfoController.dart';
import 'package:hive_business/statemanagement/statusInfo/statusInfoController.dart';
import 'package:hive_business/statemanagement/user/userController.dart';

class FirebaseManager {
  final UserStateController _userStateController =
      Get.put(UserStateController());
  final BusinessInfoController businessInfoController =
      Get.put(BusinessInfoController());
  final StatusInfoController _statusInfoController =
      Get.put(StatusInfoController());
  final storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  Future<String> registerUser(String? email, String? password) async {
    if (EmailValidator.validate(email!)) {
      if (password != null) {
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email!,
            password: password!,
          );
          await credential.user!.sendEmailVerification();
          return 'success';
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            return (e.code);
          } else if (e.code == 'email-already-in-use') {
            return (e.code);
          }
        } catch (e) {
          return (e.toString());
        }
      }
      return 'Enter a password';
    }

    return 'Enter a proper email';
  }

  Future<void> registerStore(String userUID, StoreInfo storeInfo) async {
    final storeInfoBody = {
      "businessName": storeInfo.businessName,
      "description": storeInfo.description,
      "lat": storeInfo.businessLat,
      "lng": storeInfo.businessLng,
      "type": storeInfo.businessType,
      "mondayStart": storeInfo.mondayStart,
      "mondayEnd": storeInfo.mondayEnd,
      "tuesdayStart": storeInfo.tuesdayStart,
      "tuesdayEnd": storeInfo.tuesdayEnd,
      "wednesdayStart": storeInfo.wednesdayStart,
      "wednesdayEnd": storeInfo.wednesdayEnd,
      "thursdayStart": storeInfo.thursdayStart,
      "thursdayEnd": storeInfo.thursdayEnd,
      "fridayStart": storeInfo.fridayStart,
      "fridayEnd": storeInfo.fridayEnd,
      "saturdayStart": storeInfo.saturdayStart,
      "saturdayEnd": storeInfo.saturdayEnd,
      "sundayStart": storeInfo.sundayStart,
      "sundayEnd": storeInfo.sundayEnd,
      "address": storeInfo.address,
    };
    db
        .collection("business")
        .doc(userUID)
        .set(storeInfoBody)
        .onError((e, stackTrace) => {log(("Error writing document: $e"))});
    storeInfo.offersList!.forEach((element) {
      db.collection("business").doc(userUID).collection("offers").doc().set({
        "name": element.name,
        "description": element.description,
        "price": element.price,
      });
    });

    String downloadURL = await uploadImage(storeInfo!.profilePicFile!, userUID);

    db
        .collection('business')
        .doc(userUID)
        .update({"profilePicture": downloadURL});
  }

  Future<void> getStoreInfo(String docUID) async {
    final storeRef = db.collection('business').doc(docUID);

    storeRef.snapshots().listen((event) {
      log(event.data().toString());

      businessInfoController.setBussinessInfo(
          bussinessName: event.data()!['businessName'],
          description: event.data()!['description'],
          phone: event.data()!['phone'],
          bussinessEmail: event.data()!['businessEmail'],
          bussinessType: event.data()!['type'],
          bussinessLat: event.data()!["lat"],
          bussinessLng: event.data()!["lng"],
          profilePicture: event.data()?["profilePicture"] ??
              'https://firebasestorage.googleapis.com/v0/b/hive-5eb83.appspot.com/o/appImages%2Fuser.png?alt=media&token=58782874-3a2e-4546-be3e-e619e4ea95b1 ',
          mondayStart: event.data()!["mondayStart"],
          mondayEnd: event.data()!["mondayEnd"],
          tuesdayStart: event.data()!["tuesdayStart"],
          tuesdayEnd: event.data()!["tuesdayEnd"],
          wednesdayStart: event.data()!["wednesdayStart"],
          wednesdayEnd: event.data()!["wednesdayEnd"],
          thursdayStart: event.data()!["thursdayStart"],
          thursdayEnd: event.data()!["thursdayEnd"],
          fridayStart: event.data()!["fridayStart"],
          fridayEnd: event.data()!["fridayEnd"],
          saturdayStart: event.data()!["saturdayStart"],
          saturdayEnd: event.data()!["saturdayEnd"],
          sundayStart: event.data()!["sundayStart"],
          sundayEnd: event.data()!["sundayEnd"],
          address: event.data()!['address'],
          coverPhoto: event.data()?['coverPhoto'] ??
              'https://firebasestorage.googleapis.com/v0/b/hive-5eb83.appspot.com/o/appImages%2F233-2332677_ega-png.png?alt=media&token=4da7ddf6-15c2-46ad-8982-c46af5aa54c9');

      log("businessInfoController");
      log(businessInfoController.businessInfo.businessName.toString());
      getStatus(docUID);
      getOffers(docUID);
      if (businessInfoController.businessInfo.businessName != '') {
        Get.toNamed(Home.id);
      } else {
        Get.toNamed(SetupBusiness.id);
      }
    });
  }

  Future<String> setStatus(String uid, Status status) async {
    final statusRef = db.collection('businessStatus').doc(uid);
    final data = {"status": status.status, "uid": uid};
    statusRef
        .set(
          data,
        )
        .onError((e, stackTrace) => {log(("Error writing document: $e"))});
    return 'Success';
  }

  Future<void> getStatus(String uid) async {
    final statusRef = db.collection('businessStatus').doc(uid);
    statusRef.snapshots().listen((event) {
      if (event.data() != null) {
        _statusInfoController.setStatus(status: event.data()!['status']);
      }
    });
  }

  Future<void> getOffers(String uid) async {
    final offerRef = db.collection('business').doc(uid).collection('offers');
    offerRef.snapshots().listen((event) {
      event.docChanges.forEach((element) {
        log(element.doc.data().toString());
      });
    });
  }

  Future<String> updateLocation(String uid, UserLocation location) async {
    final businessRef = db.collection('business').doc(uid);
    final data = {
      "address": location.address,
      "lat": location.lat,
      "lng": location.lng
    };
    businessRef
        .update(data)
        .onError((e, stackTrace) => {log(("Error writing document: $e"))});
    return 'Success';
  }

  Future<String> uploadImage(File image, String userUID) async {
    final Reference storageRef =
        storage.ref().child('images/${userUID}/profile');
    final TaskSnapshot taskSnapshot = await storageRef.putFile(image);
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<String> login(String? email, String? password) async {
    log(password!);
    if (EmailValidator.validate(email!)) {
      if (password != null) {
        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          if (credential.user!.emailVerified) {
            _userStateController.setUserData(
                credential.user!.email!, credential.user!.uid);
            return 'success';
          } else {
            log(credential.user!.emailVerified.toString());
            await credential.user!.sendEmailVerification();
            return 'Email not yet verfied please check your email';
          }
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            return ('No user found for that email.');
          } else if (e.code == 'wrong-password') {
            return ('Wrong password provided for that user.');
          }
        }
      }
      return 'Enter a password';
    }

    return 'Enter a proper email';
  }
}
