import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:hive_business/utilities/colors.dart';

import '../utilities/sizes.dart';

class NavigationButton extends StatefulWidget {
  String? label;
  Widget? icon;
  NavigationButton(this.label, this.icon, this.function);
  VoidCallback? function;
  @override
  State<NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<NavigationButton> {
  @override
  Widget build(BuildContext context) {
    String route = ModalRoute.of(context)!.settings.name!;
    return GestureDetector(
        onTap: widget.function,
        child: Container(
            margin: EdgeInsets.all(AppSizes.extraSmall),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: route == widget.label!.toLowerCase()
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppSizes.extraLarge)),
                  padding: EdgeInsets.all(route == widget.label!.toLowerCase()
                      ? AppSizes.extraSmall
                      : 0),
                  child: widget.icon!,
                ),
                SizedBox(
                  height: AppSizes.extraSmall,
                ),
                route == widget.label!.toLowerCase()
                    ? SizedBox()
                    : Text(
                        widget.label!,
                      ),
              ],
            )));
  }
}
