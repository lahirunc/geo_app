// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:geo_app/config.dart';

class IconTextFormField extends StatelessWidget {
  const IconTextFormField({
    Key? key,
    this.validator,
    this.hintText,
    this.prefixIcon,
    this.color = kGrey,
    required this.controller,
    this.onTap,
  }) : super(key: key);

  final onTap, validator;
  final TextEditingController controller;
  final String? hintText;
  final Icon? prefixIcon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kWhite,
      ),
      height: Config.screenHeight! * 0.08,
      width: Config.screenWidth! * 0.9,
      child: Padding(
        padding: EdgeInsets.all(Config.screenHeight! * 0.01),
        child: TextFormField(
          controller: controller,
          validator: validator,
          onTap: onTap,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: Config.screenWidth! < 710
                  ? Config.screenWidth! * 0.05
                  : Config.screenWidth! * 0.02,
              color: color,
            ),
            prefixIcon: prefixIcon,
          ),
        ),
      ),
    );
  }
}
