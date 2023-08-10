import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/widgets/extension.dart';
import '../../../services/widgets/glass.dart';
import '../../../services/widgets/waiting.dart';
import '../component/controller.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String author;
  final String rate;
  final String image;
  final Function()? onTap;
  final Function()? subscribe;
  const CategoryItem(
      {super.key,
      required this.title,
      required this.author,
      required this.rate,
      this.onTap,
      required this.image,
      this.subscribe});

  @override
  Widget build(BuildContext context) {
    final con = Get.find<HoodController>();
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: onTap,
        child: UnSubscribed(
            image: image,
            title: title,
            author: author,
            rate: rate,
            con: con,
            subscribe: subscribe),
      ),
    );
  }
}

class UnSubscribed extends StatelessWidget {
  const UnSubscribed({
    super.key,
    required this.image,
    required this.title,
    required this.author,
    required this.rate,
    required this.con,
    required this.subscribe,
  });

  final String image;
  final String title;
  final String author;
  final String rate;
  final HoodController con;
  final Function()? subscribe;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 5,
      widget: Row(
        children: [
          Container(
            // height: myHeight(context, 10),
            width: 140,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(5),
              shape: BoxShape.rectangle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(image),
                onError: (exception, stackTrace) => const Icon(Icons.info),
              ),
            ),
          ).hMargin3,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  author.toAutoLabel(
                    color: Colors.blue[200],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          rate.toLabel(),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 15,
                          )
                        ],
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Obx(() => con.subBool.value
                          ? const MWaiting()
                          : IconButton(
                              onPressed: subscribe,
                              icon: const Icon(Icons.add)))
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
      width: 300,
      height: 60,
    );
  }
}


