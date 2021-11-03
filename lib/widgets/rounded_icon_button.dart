// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:geo_app/config.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.backGroundColor,
  }) : super(key: key);

  final onPressed;
  final Icon? icon;
  final Color? backGroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: kWhite,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: icon!,
      ),
    );
  }
}
