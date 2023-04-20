import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_business/components/addService.dart';
import 'package:hive_business/components/bottomNavigation.dart';

class AppLayout extends StatefulWidget {
  Widget? body;
  AppLayout(this.body);

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showFlexibleBottomSheet(
              minHeight: 0,
              initHeight: 0.8,
              maxHeight: 1,
              isSafeArea: true,
              context: context,
              builder: _buildBottomSheet,
              isExpand: true,
              draggableScrollableController: DraggableScrollableController());
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: AppBottomNavigation(),
      body: SafeArea(child: widget.body!),
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
