import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../services/widgets/extension.dart';
import '../hood/widget/hero_widgt.dart';

class ChatProfile extends StatelessWidget {
  final String title;
  final String image;
  const ChatProfile({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: title.toLabel(color: Colors.white),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            // NotificationApi.showNotification(title: "dfdfd", body: "fgfgfg");
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: HeroWidget(
          tag: title,
          trans: true,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
