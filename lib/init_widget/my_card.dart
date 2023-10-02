import 'package:aceprex/services/widgets/waiting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/constants/color.dart';
import '../services/constants/constant.dart';
import '../services/widgets/extension.dart';
import '../services/widgets/glass.dart';

class MyCard extends StatelessWidget {
  final String title;
  final String author;
  final String description;
  final String imageLink;

  final String views;
  final Function()? ontap;
  final String? tag;
  final String date;
  const MyCard(
      {super.key,
      required this.title,
      required this.author,
      required this.description,
      required this.imageLink,
      this.tag,
      this.ontap,
      required this.views,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 203,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: ontap,
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(5),
                child: GlassContainer(
                  widget: Column(children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120,
                          width: myWidth(context, 2.5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            shape: BoxShape.rectangle,
                          ),
                          child: CachedNetworkImage(
                            imageUrl: fileUrl + imageLink,
                            placeholder: (context, url) => const MWaiting(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.fill,
                          ),
                        ).hPadding3,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              author
                                  .toAutoLabel(
                                    color: primaryLight,
                                  )
                                  .vPadding6,
                              SizedBox(
                                height: 65,
                                width: myWidth(context, 1.8),
                                child: Text(
                                  description,
                                  style: const TextStyle(
                                      overflow: TextOverflow.clip),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flexible(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Tag: ${tag!}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.eye,
                              color: Colors.green,
                              size: 16,
                            ),
                            const SizedBox(
                                width:
                                    8), // Adjust the spacing between the icon and text
                            Text(views),
                          ],
                        ).hPadding9
                      ],
                    ).hPadding3)
                  ]),
                  width: myWidth(
                    context,
                    1.02,
                  ),
                  height: 190,
                ),
              ),
            ),
          ),
          Positioned(
            left: 30,
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: dark,
                  offset: const Offset(
                      0, 3), // Specifies the position of the shadow
                  blurRadius: 3, // Specifies the blur radius of the shadow
                  spreadRadius: 0, // Specifies the spread radius of the shadow
                ),
              ], color: primaryLight, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.clock,
                    size: 15,
                    color: light,
                  ).hMargin3,
                  Text(
                    date,
                    style: TextStyle(color: light),
                  ),
                ],
              ).hPadding6.vPadding3,
            ),
          ),
        ],
      ),
    );
  }
}
