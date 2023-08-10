import '../services/constants/color.dart';
import '../services/widgets/extension.dart';
import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final dynamic controller;
  final String text;
  final bool active;
  final int index;
  final Function()? ontap;
  const TabButton(
      {super.key,
      required this.controller,
      this.ontap,
      required this.index,
      required this.text,
      this.active = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            // boxShadow: [
            //   const BoxShadow(
            //     color: Colors.grey,
            //     offset: Offset(0, 1), // Specifies the position of the shadow
            //     blurRadius: 6, // Specifies the blur radius of the shadow
            //     spreadRadius: 0, // Specifies the spread radius of the shadow
            //   ),
            //   BoxShadow(
            //     color: lightGrey,
            //     offset:
            //         const Offset(0, 1), // Specifies the position of the shadow
            //     blurRadius: 6, // Specifies the blur radius of the shadow
            //     spreadRadius: 0, // Specifies the spread radius of the shadow
            //   ),
            // ],
            color: active ? secondaryColor :primaryLight,
            borderRadius: BorderRadius.circular(30)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color:  light),
          ).hPadding9,
        ),
      ),
    ).padding9;
  }
}
