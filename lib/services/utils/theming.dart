

import 'package:flutter/cupertino.dart';

class Theming extends StatelessWidget {
  final bool isdark;
  final Widget widget;
  const Theming({super.key, required this.isdark, required this.widget});

  @override
  Widget build(BuildContext context) {
    return widget;
  }
}