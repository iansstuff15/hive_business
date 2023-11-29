import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:hive_business/components/AppButton.dart';
import 'package:hive_business/components/AppInput.dart';
import 'package:hive_business/components/AppLayout.dart';
import 'package:hive_business/components/transactionListItem.dart';
import 'package:hive_business/statemanagement/user/userController.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class Transactions extends StatefulWidget {
  static String id = 'transactions';

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
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
              Text('Transactions',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: AppSizes.extraSmall),
              SizedBox(
                width: AppSizes.getWitdth(context) * 0.9,
                child: AppInput("Search price, transaction ID, or date booked",
                    TextInputType.text, searchText),
              ),
              SizedBox(
                height: AppSizes.extraSmall,
              ),
              AppButton(
                "Download Transactions",
                () {
                  downloadTransactions();
                },
                width: AppSizes.getWitdth(context),
              ),

              // ChipsChoice<String>.multiple(
              //   value: tags,
              //   onChanged: (val) {
              //     print(val.toString());
              //     setState(() => tags = val);
              //   },
              //   choiceStyle: C2ChipStyle.filled(
              //     selectedStyle: C2ChipStyle(
              //       backgroundColor: AppColors.textBox,
              //     ),
              //   ),
              //   choiceItems: C2Choice.listFrom<String, String>(
              //     source: options,
              //     value: (i, v) => v,
              //     label: (i, v) => v,
              //   ),
              // ),

              Obx(() => StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where(
                          "businessID",
                          isEqualTo: userInfo.user.uid.value,
                        )
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
                        return ConstrainedBox(
                            constraints: BoxConstraints(
                                maxHeight: AppSizes.getHeight(context) * 0.8,
                                maxWidth: AppSizes.getWitdth(context) * 0.9),
                            child: ListView.separated(
                              itemCount: documents.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: AppSizes.small),
                              itemBuilder: (context, index) {
                                var docdata = documents[index].data();
                                return (tags.contains(docdata['status']) ||
                                                tags.isEmpty) &&
                                            (docdata['totalPrice']
                                                    .toString()
                                                    .contains(
                                                        searchText.text) ||
                                                docdata['uid']
                                                    .toString()
                                                    .contains(
                                                        searchText.text)) ||
                                        docdata['dateBooked']
                                            .toString()
                                            .contains(searchText.text)
                                    ? TransactionListItem(
                                        date: docdata['dateBooked'],
                                        price: docdata['totalPrice'],
                                        status: docdata['status'],
                                        transactionID: docdata['uid'],
                                        orders:
                                            docdata['order'] as List<dynamic>,
                                        time: docdata['timeBooked'],
                                        customerID: docdata['customerID'],
                                        businessID: docdata['businessID'],
                                        totalPrice: docdata['totalPrice'],
                                      )
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

  void downloadTransactions() async {
    // Fetch the documents from Firebase Firestore
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('orders')
        .where("businessID", isEqualTo: userInfo.user.uid.value)
        .get();

    // Convert the QuerySnapshot to a List<QueryDocumentSnapshot<Map<String, dynamic>>
    // Call the function to download as a CSV
    saveDataAsCSV("transactions.csv", snapshot.docs);
  }

  Future<void> saveDataAsCSV(String fileName,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data) async {
    // Convert the data to a List<List<dynamic>> where each inner list represents a row in the CSV
    final List<List<dynamic>> rows = [];

    // Add headers to the CSV (assuming your documents have consistent structure)
    final headers = [
      'dateBooked',
      'timeBooked',
      'customerID',
      'order',
      'status',
      'totalPrice',
    ]; // Replace with your actual field names
    rows.add(headers);

    // Iterate through the documents and add data to rows
    for (final doc in data) {
      final Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
      final List<dynamic> row = [
        docData['dateBooked'],
        docData['timeBooked'],
        docData['customerID'],
        docData['order'],
        docData['status'],
        docData['totalPrice'],
      ];
      rows.add(row);
    }

    // Convert the rows to a CSV string
    final csvData = const ListToCsvConverter().convert(rows);

    // Get the app's external storage directory and save the CSV file
    final directory = await getExternalStorageDirectory();
    final filePath = '/storage/emulated/0/Documents/$fileName';
    final file = File(filePath);

    await file.writeAsString(csvData);

    // The CSV file is now saved in the external storage directory.
    print('CSV file saved to: $filePath');
  }
}
