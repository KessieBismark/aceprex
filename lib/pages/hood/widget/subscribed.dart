import '../../../services/widgets/extension.dart';
import 'package:flutter/material.dart';

import '../../../services/constants/constant.dart';
import '../../../services/widgets/glass.dart';

class Subscribed extends StatelessWidget {
  final String title;
  final String author;
  final String image;
  final Function()? ontap;
  const Subscribed(
      {super.key,
      required this.title,
      required this.author,
      required this.image,
      this.ontap});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: ontap,
        child: GlassContainer(
          borderRadius: 5,
          widget: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Container(
                height: myHeight(context, 7),
                width: myWidth(context, 2.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(image),
                    onError: (exception, stackTrace) => const Icon(Icons.info),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    title.toAutoLabel(
                      bold: true,
                    ),
                    author.toAutoLabel(
                      color: Colors.blue[200],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
          width: myWidth(
            context,
            2,
          ),
          height: 200,
        ),
      ),
    );
  }
}
