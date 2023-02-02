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
  double? height;
  double? width;

  AppInput(this.placeholder, this.keyboard, this.controller,
      {this.obsure = false,
      this.maxLines = 1,
      this.height = 30,
      this.width = double.infinity});
  @override
  State<AppInput> createState() => _AppInputState();
}

class _AppInputState extends State<AppInput> {
  String errorText = "";
  @override
  Widget build(BuildContext context) {
    widget.controller!.addListener(() {
      if (widget.controller!.text.isEmpty) {
        setState(() {
          errorText = "field is required";
        });
      } else {
        setState(() {
          errorText = "";
        });
      }
      if (widget.obsure!) {
        if (widget.controller!.text.length < 8) {
          setState(() {
            errorText = "enter proper password";
          });
        } else {
          setState(() {
            errorText = "";
          });
        }
      }
      if (widget.keyboard == TextInputType.emailAddress) {
        if (!widget.controller!.text.contains("@") &&
            !widget.controller!.text.contains(".com")) {
          setState(() {
            errorText = "enter proper email";
          });
        } else {
          setState(() {
            errorText = "";
          });
        }
      }
      if (widget.keyboard == TextInputType.phone) {
        if (widget.controller!.text.length != 10 &&
            !widget.controller!.text.startsWith("09")) {
          setState(() {
            errorText = "enter proper phone number";
          });
        } else {
          setState(() {
            errorText = "";
          });
        }
      }
    });
    return Container(
      width: widget.width,
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
                errorText: errorText,
                errorStyle: TextStyle(height: 0.1),
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
