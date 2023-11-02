import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'extension.dart';

class MWaiting extends StatelessWidget {
  const MWaiting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? const CupertinoActivityIndicator().center
        : const CircularProgressIndicator().center;
  }
}

// class MWaiting extends StatelessWidget {
//   const MWaiting({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LoadingAnimationWidget.inkDrop(
//       color: voilet,
//           // leftDotColor: const Color(0xFF1A1A3F),
//           // rightDotColor: const Color(0xFFEA3799),
//           size: 30,
//         )
//         .center;
//   }
// }
