import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:hive_business/utilities/colors.dart';
import 'package:hive_business/utilities/sizes.dart';

class AppInput extends StatefulWidget {
  String? placeholder;
  TextInputType? keyboard;
  bool? obsure;
  TextEditingController? controller;
  int? maxLines;
  AppInput(this.placeholder, this.keyboard, this.controller,
      {this.obsure = false, this.maxLines = 1});
  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.small),
      decoration: BoxDecoration(
          color: AppColors.textBox,
          borderRadius: BorderRadius.circular(AppSizes.small)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Text(widget.placeholder!),
          TextField(
            maxLines: widget.maxLines,
            controller: widget.controller,
            decoration: InputDecoration(
                labelText: widget.placeholder,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.textColor)),
            keyboardType: widget.keyboard,
            obscureText: widget.obsure!,
            style: TextStyle(color: AppColors.textColor),
          )
        ],
      ),
    );
  }
}
