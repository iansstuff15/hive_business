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
import 'package:hive_business/data%20models/offers.dart';
import 'package:hive_business/data%20models/status.dart';
import 'package:hive_business/data%20models/storeInfo.dart';
import 'package:hive_business/screens/appPages.dart';
import 'package:hive_business/screens/home.dart';
import 'package:hive_business/screens/setupBusiness.dart';
import 'package:hive_business/statemanagement/businessInfo/businessInfoController.dart';
import 'package:hive_business/statemanagement/offersInfo/offerInfoController.dart';
import 'package:hive_business/statemanagement/offersInfo/offerInfoModel.dart';
import 'package:hive_business/statemanagement/statusInfo/statusInfoController.dart';
import 'package:hive_business/statemanagement/user/userController.dart';

class FirebaseManager {
  final UserStateController _userStateController =
      Get.put(UserStateController());
  final BusinessInfoController businessInfoController =
      Get.put(BusinessInfoController());
  final StatusInfoController _statusInfoController =
      Get.put(StatusInfoController());
  final OfferInfoController _offerInfoController =
      Get.put(OfferInfoController());

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
      db.collection("business").doc(userUID).collection("offers").add({
        "name": element.name,
        "description": element.description,
        "price": element.price,
      }).then((snapshot) => {
            db
                .collection("business")
                .doc(userUID)
                .collection("offers")
                .doc(snapshot.id)
                .update({"uid": snapshot.id})
          });
    });

    String downloadURL = await uploadImage(storeInfo!.profilePicFile!, userUID);

    db
        .collection('business')
        .doc(userUID)
        .update({"profilePicture": downloadURL});
  }

  void publishProduct(String userUID, Offers offer) {
    db.collection("business").doc(userUID).collection("offers").add({
      "name": offer.name,
      "description": offer.description,
      "price": offer.price
    }).then((value) => {
          db
              .collection("business")
              .doc(userUID)
              .collection("offers")
              .doc(value.id)
              .update({"uid": value.id})
        });
  }

  Future<void> getStoreInfo(String docUID) async {
    print(docUID.toString());
    final storeRef = db.collection('business').doc(docUID);

    storeRef.snapshots().listen((event) {
      print("event.data().toString()");
      print(event.data().toString());
      if (event.data() != null) {
        businessInfoController.setBussinessInfo(
            bussinessName:
                event.data()?['businessName'] ?? 'No business name found',
            description: event.data()?['description'] ?? 'No description found',
            phone: event.data()?['phone'] ?? 'No phone found',
            bussinessEmail:
                event.data()?['businessEmail'] ?? 'No business email found',
            bussinessType: event.data()?['type'] ?? 'No type found',
            bussinessLat: event.data()?["lat"] ?? 'No latitude found',
            bussinessLng: event.data()?["lng"] ?? 'No longitude found',
            profilePicture: event.data()?["profilePicture"] ??
                'https://firebasestorage.googleapis.com/v0/b/hive-5eb83.appspot.com/o/appImages%2Fuser.png?alt=media&token=58782874-3a2e-4546-be3e-e619e4ea95b1 ',
            mondayStart: event.data()?["mondayStart"] ?? 'No schedule found',
            mondayEnd: event.data()?["mondayEnd"] ?? 'No schedule found',
            tuesdayStart: event.data()?["tuesdayStart"] ?? 'No schedule found',
            tuesdayEnd: event.data()?["tuesdayEnd"] ?? 'No schedule found',
            wednesdayStart:
                event.data()?["wednesdayStart"] ?? 'No schedule found',
            wednesdayEnd: event.data()?["wednesdayEnd"] ?? 'No schedule found',
            thursdayStart:
                event.data()?["thursdayStart"] ?? 'No schedule found',
            thursdayEnd: event.data()?["thursdayEnd"] ?? 'No schedule found',
            fridayStart: event.data()?["fridayStart"] ?? 'No schedule found',
            fridayEnd: event.data()?["fridayEnd"] ?? 'No schedule found',
            saturdayStart:
                event.data()?["saturdayStart"] ?? 'No schedule found',
            saturdayEnd: event.data()?["saturdayEnd"] ?? 'No schedule found',
            sundayStart: event.data()?["sundayStart"] ?? 'No schedule found',
            sundayEnd: event.data()?["sundayEnd"] ?? 'No schedule found',
            address: event.data()?['address'] ?? 'No address found',
            coverPhoto: event.data()?['coverPhoto'] ??
                'https://firebasestorage.googleapis.com/v0/b/hive-5eb83.appspot.com/o/appImages%2F233-2332677_ega-png.png?alt=media&token=4da7ddf6-15c2-46ad-8982-c46af5aa54c9');
        getOffers(docUID);
        getStatus(docUID);
        Get.toNamed(Home.id);
      } else {
        Get.toNamed(SetupBusiness.id);
      }
    });
  }

  Future<String> setStatus(
      String uid, Status status, double lat, double lng) async {
    final statusRef = db.collection('businessStatus').doc(uid);
    final data = {"status": status.status, "uid": uid, "lat": lat, "lng": lng};
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
      // _offerInfoController.clearList();
      // for (var doc in event.docs) {
      //   log('doc');
      //   log(doc.data().toString());
      //   log(doc.data()['name']);
      //   log(doc.data()['description']);
      //   log(doc.data()['price'].toString());
      //   log(doc.data()['uid']);
      //   _offerInfoController.pushToList(
      //       offer: Offers(doc.data()['name'], doc.data()['description'],
      //           doc.data()['price'], doc.data()['uid']));
      // }

      for (var docChange in event.docChanges) {
        switch (docChange.type) {
          case DocumentChangeType.added:
            _offerInfoController.pushToList(
              offer: Offers(
                docChange.doc.data()!['name'],
                docChange.doc.data()!['description'],
                docChange.doc.data()!['price'],
                docChange.doc.data()!['uid'],
              ),
            );
            break;
          case DocumentChangeType.modified:
            _offerInfoController.updateItem(Offers(
              docChange.doc.data()!['name'],
              docChange.doc.data()!['description'],
              docChange.doc.data()!['price'],
              docChange.doc.data()!['uid'],
            ));
            _offerInfoController.update();
            break;
          case DocumentChangeType.removed:
            _offerInfoController.removeItem(docChange.doc.data()!['uid']);
            break;
        }
      }
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

Future<void> logActivity() async {}
