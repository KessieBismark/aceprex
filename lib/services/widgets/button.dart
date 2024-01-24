import 'package:flutter/material.dart';

import '../constants/color.dart';
import 'extension.dart';
import 'waiting.dart';

enum ButtonType { save, add, delete, cancel, search, close }

class MButton extends StatelessWidget {
  final String? title;
  final VoidCallback onTap;
  final Icon? icon;
  final bool isLoading;
  final ButtonType? type;
  final Color? color;
  final EdgeInsets? padding;

  const MButton(
      {Key? key,
      this.title,
      required this.onTap,
      this.icon,
      this.isLoading = false,
      this.type,
      this.color,
      this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const MWaiting()
        : ElevatedButton(
            onPressed: onTap,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    // ignore: prefer_if_null_operators
                    color != null
                        ? color
                        : type == ButtonType.save
                            ? Colors.green
                            : type == ButtonType.add
                                ? Colors.blue
                                : type == ButtonType.cancel
                                    ? Colors.orangeAccent
                                    : type == ButtonType.close
                                        ? const Color.fromARGB(255, 248, 65, 33)
                                        : type == ButtonType.delete
                                            ? Colors.redAccent
                                            : type == ButtonType.search
                                                ? secondary
                                                : null),
                padding: MaterialStateProperty.all(
                    padding ?? const EdgeInsets.all(10))),
            child: type != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      icon ??
                          Icon(
                              type == ButtonType.save
                                  ? Icons.save
                                  : type == ButtonType.cancel
                                      ? Icons.cancel
                                      : type == ButtonType.close
                                          ? Icons.close
                                          : type == ButtonType.delete
                                              ? Icons.delete
                                              : type == ButtonType.add
                                                  ? Icons.add_box
                                                  : type == ButtonType.search
                                                      ? Icons.search
                                                      : Icons.help_center,
                              size: 15,
                              color: light),
                      const SizedBox(
                        width: 5,
                      ),
                      title != null
                          ? title!.toLabel(color: light)
                          : type == ButtonType.save
                              ? 'Save'.toLabel(color: light)
                              : type == ButtonType.cancel
                                  ? 'Cancel'.toLabel(color: light)
                                  : type == ButtonType.close
                                      ? 'Close'.toLabel(color: light)
                                      : type == ButtonType.delete
                                          ? 'Delete'.toLabel(color: light)
                                          : type == ButtonType.add
                                              ? 'New'.toLabel(color: light)
                                              : type == ButtonType.search
                                                  ? 'Search'
                                                      .toLabel(color: light)
                                                  : (title)!
                                                      .toLabel(color: light),
                    ],
                  )
                : icon != null
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          icon!,
                          const SizedBox(
                            width: 5,
                          ),
                          (title)!.toLabel(color: light)
                        ],
                      )
                    : (title)!.toLabel(color: light),
          );
  }
}

class MTextButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color? color;
  final bool? active;
  const MTextButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.color,
      this.active = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap,
        style: active == true
            ? ButtonStyle(
                elevation: MaterialStateProperty.all(0.5),
                // backgroundColor: MaterialStateProperty.all(
                //     Theme.of(context).colorScheme.secondary),
                // padding: MaterialStateProperty.all(
                //     const EdgeInsets.symmetric(horizontal: 20, vertical: 20)),
                // textStyle: MaterialStateProperty.all(const TextStyle(
                //   color: Colors.black,
                // )),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1.0),
                )))
            : const ButtonStyle(),
        child: title.toLabel(color: color));
  }
}
