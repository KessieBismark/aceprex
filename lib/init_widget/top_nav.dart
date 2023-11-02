import '../pages/notification/component/binding.dart';
import '../pages/notification/notifications.dart';
import '../pages/settings/settings.dart';
import '../services/constants/constant.dart';
import '../services/widgets/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/constants/color.dart';
import '../services/utils/helpers.dart';

class TopBar extends StatelessWidget {
  final String title;
  final Widget widget;
  const TopBar({super.key, required this.title, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(20),

        ///  bottomRight: Radius.circular(20),
      ),
      child: Container(
        color: primaryColor,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(
                  () => Utils.imageSet.value
                      ? CircleAvatar(
                          maxRadius: 20,
                          backgroundImage:
                              NetworkImage(fileUrl + Utils.userAvatar.value))
                      : Utils.isUrl(fileUrl + Utils.userAvatar.value)
                          ? CircleAvatar(
                              maxRadius: 20,
                              backgroundImage: NetworkImage(
                                  fileUrl + Utils.userAvatar.value))
                          : const CircleAvatar(
                              maxRadius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/profile.png'),
                            ),
                ),
                title.toLabel(bold: true, color: light),
                Row(
                  children: [
                    IconButton(
                        onPressed: () => Get.to(() => const Notifications(),
                            binding: NotBinding()),
                        icon: Obx(() => Utils.messageCount.value == 0
                            ? Icon(Icons.notifications, color: light, size: 20)
                            : Badge(
                                label: "${Utils.messageCount.value}"
                                    .toLabel(color: light),
                                child: Icon(Icons.notifications,
                                    color: light, size: 20)))),
                    IconButton(
                      onPressed: () => Get.to(() => const Settings()),
                      icon: Icon(
                        Icons.settings,
                        color: light,
                      ),
                    ),
                  ],
                )
              ],
            ).hPadding9.padding9.padding3,
            const SizedBox(
              height: 5,
            ),
            widget
          ],
        ),
      ),
    );
  }
}

class SliverTopBar extends StatelessWidget {
  final Widget child;
  final String title;
  final List<Widget> appActions;
  const SliverTopBar(
      {super.key,
      required this.child,
      required this.title,
      required this.appActions});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          pinned: false,
          snap: false,
          floating: true,
          expandedHeight: 160.0,
          title: Text(
            title,
            style: TextStyle(color: light),
          ),
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              title,
              style: TextStyle(color: light),
            ),
          ),
          actions: appActions),
      child
    ]);
  }
}

/// Flutter code sample for [SliverAppBar].

class SliverAppBarExample extends StatefulWidget {
  const SliverAppBarExample({super.key});

  @override
  State<SliverAppBarExample> createState() => _SliverAppBarExampleState();
}

class _SliverAppBarExampleState extends State<SliverAppBarExample> {
  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

// [SliverAppBar]s are typically used in [CustomScrollView.slivers], which in
// turn can be placed in a [Scaffold.body].
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
              pinned: _pinned,
              snap: _snap,
              floating: _floating,
              expandedHeight: 160.0,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text('SliverAppBar'),
                background: FlutterLogo(),
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  tooltip: 'Add new entry',
                  onPressed: () {/* ... */},
                ),
              ]),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
              child: Center(
                child: Text('Scroll to see the SliverAppBar in effect.'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  color: index.isOdd ? Colors.white : Colors.black12,
                  height: 100.0,
                  child: Center(
                    child: Text('$index', textScaleFactor: 5),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: OverflowBar(
            overflowAlignment: OverflowBarAlignment.center,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('pinned'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _pinned = val;
                      });
                    },
                    value: _pinned,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('snap'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _snap = val;
                        // Snapping only applies when the app bar is floating.
                        _floating = _floating || _snap;
                      });
                    },
                    value: _snap,
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('floating'),
                  Switch(
                    onChanged: (bool val) {
                      setState(() {
                        _floating = val;
                        _snap = _snap && _floating;
                      });
                    },
                    value: _floating,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
