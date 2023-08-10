import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../services/constants/color.dart';
import '../../services/widgets/extension.dart';

class NewDetails extends StatelessWidget {
  final String title;
  final dynamic content;
  const NewDetails({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title.toLabel(color: light),
        elevation: 0,
        backgroundColor: primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:  Icon(
            Icons.arrow_back_ios,
            color:light,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            HtmlWidget(
              content,
            ).padding3,
          ],
        ),
      ),
    );
  }
}
