import 'component/controller.dart';
import '../../services/constants/color.dart';
import '../../services/widgets/button.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/textbox.dart';
import '../../services/widgets/waiting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/utils/helpers.dart';
import '../../services/utils/themes.dart';
import 'component/model.dart';

class CommentsScreen extends GetView<HoodController> {
  final String title;
  final int id;
  final int hoodID;
  const CommentsScreen({
    super.key,
    required this.title,
    required this.id,
    required this.hoodID,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: dark,
            )),
        backgroundColor: Colors.blue[200],
        title: title.toLabel(color: dark),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.getComment(hoodID);
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              Column(
                children: [
                  Align(
                          alignment: Alignment.topLeft,
                          child: "Enter your comment here".toLabel())
                      .padding9,
                  MEdit(
                    controller: controller.replyText,
                    hint: "Reply here",
                    maxLines: null,
                  ).padding9,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Obx(() => MButton(
                            isLoading: controller.saveReply.value,
                            onTap: () {
                              controller.replyComment(
                                  controller.replyText.text, hoodID);
                            },
                            title: "Send",
                          )),
                    ],
                  ).padding9
                ],
              ).card,
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Obx(() => controller.commentLoad.value
                    ? Container(
                        alignment: Alignment.center,
                        child: const MWaiting(),
                      )
                    : ListView.builder(
                        itemCount: controller.commentList.length,
                        itemBuilder: (context, index) {
                          return CommentWidget(
                            hoodID: hoodID,
                            comment: controller.commentList[index],
                            replyComments:
                                controller.commentList[index].subComment,
                          );
                        })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommentWidget extends StatelessWidget {
  final CommentList comment;
  final List<Comment>? replyComments;
  final int hoodID;
  const CommentWidget(
      {super.key,
      required this.comment,
      required this.replyComments,
      required this.hoodID});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: Utils.isUrl(comment.avatar)
              ? CircleAvatar(
                  maxRadius: 20, backgroundImage: NetworkImage(comment.avatar))
              : const CircleAvatar(
                  maxRadius: 20,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
          title: Text(
            comment.username,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.comment,
                style: TextStyle(
                    color: ThemeService().isSavedDarkMode() ? lightGrey : dark),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                    onTap: () {
                      sendReply(comment.id, hoodID);
                    },
                    child: Row(
                      children: [
                        "Reply".toLabel(color: Colors.blue),
                        const Icon(
                          Icons.reply,
                          size: 15,
                        )
                      ],
                    )),
              )
            ],
          ),
          trailing: Utils.formatTimeAgo(comment.date).toLabel(),
        ),
        //const SizedBox(height: 10),
        if (replyComments!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              children: replyComments!
                  .map((replyComment) => ListTile(
                        leading: Utils.isUrl(replyComment.avatar)
                            ? CircleAvatar(
                                maxRadius: 20,
                                backgroundImage:
                                    NetworkImage(replyComment.avatar))
                            : const CircleAvatar(
                                maxRadius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/profile.png'),
                              ),
                        title: Text(
                          replyComment.username,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        subtitle: Text(
                          replyComment.comment,
                          style: TextStyle(
                              color: ThemeService().isSavedDarkMode()
                                  ? lightGrey
                                  : dark),
                        ),
                        trailing: Column(
                          children: [
                            Utils.formatTimeAgo(replyComment.date).toLabel(),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
      ],
    ).card;
  }

  sendReply(int comment, int hood) {
    final con = Get.find<HoodController>();
    return Get.defaultDialog(
        title: "Reply comment",
        content: Column(
          children: [
            MEdit(
              controller: con.subReplyText,
              hint: "Reply here",
              maxLines: null,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => MButton(
                      isLoading: con.saveReply.value,
                      onTap: () {
                        con.subReplyComment(
                            comment, con.subReplyText.text, hood);
                      },
                      title: "Send",
                    )),
                MButton(
                  onTap: () => Get.back(),
                  type: ButtonType.close,
                ),
              ],
            )
          ],
        ));
  }
}
