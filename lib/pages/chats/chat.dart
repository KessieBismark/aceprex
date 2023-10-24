import '../../services/constants/constant.dart';
import 'component/model.dart';
import 'image_viewer.dart';
import '../../services/utils/helpers.dart';
import '../../services/widgets/extension.dart';
import '../../services/widgets/waiting.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import '../../services/constants/color.dart';
import 'component/chat_controller.dart';

class ChatUI extends GetView<ChatPlaceController> {
  final String? avatar;
  final String name;
  final int to;
  final int isOnline;
  const ChatUI({
    super.key,
    required this.to,
    required this.name,
    required this.isOnline,
    this.avatar,
  });

  @override
  Widget build(BuildContext context) {
    // controller.chsa?.cancel();
    controller.getUserChat(to);
    controller.setSeen(to);
    controller.startChatTimer(to);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    controller.chatTimer?.cancel();
                    controller.onClose();
                    controller.setSeen(to);
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: light,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                Utils.isUrl(avatar!)
                    ? InkWell(
                        onTap: () => ImageViewer(imageUrl: avatar!, tag: name),
                        child: CircleAvatar(
                            maxRadius: 20,
                            backgroundImage: NetworkImage(avatar!)),
                      )
                    : const CircleAvatar(
                        maxRadius: 20,
                        backgroundImage:
                            AssetImage('assets/images/profile.png'),
                      ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            color: light,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        isOnline == 1 ? 'Online' : 'Offline',
                        style: TextStyle(
                            color: Colors.grey.shade400, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            Expanded(
                child: Obx(
              () => controller.chatBool.value ? chatSpace() : chatSpace(),
            )),
            //  Expanded(
            //     child: Obx(
            //   () => chatSpace(controller.chatLength.value) ,
            // )),
            const SizedBox(
              height: 10,
            ),
            bottomWidgets(),
          ],
        ),
      ),
    );
  }

  chatSpace() {
    return GroupedListView<ChatMessage, DateTime>(
      reverse: true,
      order: GroupedListOrder.DESC,
      floatingHeader: true,
      elements: controller.chatData,
      groupBy: (data) =>
          DateTime(data.date.year, data.date.month, data.date.day),
      groupHeaderBuilder: (data) => Align(
        alignment: Alignment.topCenter,
        child: data.date.day == DateTime.now().day &&
                data.date.month == DateTime.now().month &&
                data.date.year == DateTime.now().year
            ? "Today".toLabel(color: lightGrey)
            : "${controller.weekdayLabels[data.date.weekday]}  ${data.date.day} ${Utils.myMonth(data.date.month)}, ${data.date.year}"
                .toLabel(color: lightGrey),
      ),
      itemBuilder: (context, data) => Align(
        alignment: data.from.toString() != Utils.userID
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: data.attachment!.isNotEmpty && data.message!.isEmpty
            ? showAttachment(data)
            : BubbleSpecialThree(
                text: data.message!,
                sent: data.from.toString() == Utils.userID,
                isSender: data.from.toString() == Utils.userID,
                seen: data.from.toString() == Utils.userID && data.seen == 1,
                color:
                    data.from.toString() != Utils.userID ? grey : primaryLight,
                tail: true,
                textStyle: const TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }

  Hero showAttachment(ChatMessage data) {
    return Hero(
      transitionOnUserGestures: true,
      tag: data.id,
      child: InkWell(
        onTap: () => Get.to(() =>
            ImageViewer(imageUrl: data.attachment!, tag: data.id.toString())),
        child: Container(
          height: 170,
          width: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(fileUrl + data.attachment!)),
            borderRadius: BorderRadius.circular(20),
            color: (data.from.toString() != Utils.userID ? grey : primaryLight),
          ),
        ),
      ).hMargin3.vPadding9,
    );
  }

  Container bottomWidgets() {
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: lightGrey,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              controller.handleImageSelection(to);
            },
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: primaryLight,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: TextField(
              maxLines: null,
              onSubmitted: (text) {
                controller.sendMessage(text, to);
              },
              controller: controller.messageController,
              decoration: const InputDecoration(
                  hintText: "Type your message here...",
                  //hintStyle: TextStyle(color: Colors.black54),
                  border: InputBorder.none),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Obx(() => controller.isSendMessage.value
              ? const MWaiting().padding9
              : SizedBox(
                  height: 30,
                  width: 30,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (controller.messageController.text.trim().isNotEmpty) {
                        controller.sendMessage(
                            controller.messageController.text, to);
                      }
                    },
                    backgroundColor: primaryLight,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ).hMargin6),
        ],
      ),
    );
  }
}
