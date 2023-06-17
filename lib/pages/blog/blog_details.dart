import '../../services/constants/color.dart';
import '../../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class BlogDetails extends StatelessWidget {
  final String title;
  final dynamic content;
  const BlogDetails({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title.toLabel(color: dark),
        elevation: 0,
        backgroundColor: Colors.blue[200],
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
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
