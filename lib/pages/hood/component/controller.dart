import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import '../../library/component/controller.dart';
import 'model.dart';

class HoodController extends GetxController
    with GetSingleTickerProviderStateMixin {
  List<UnsubscribedHood> unSubscribed = <UnsubscribedHood>[];
  List<UnsubscribedHood> unSubscribedList = <UnsubscribedHood>[];
  List<SubscribedHood> subscribed = <SubscribedHood>[];
  List<SubscribedHood> subscribedList = <SubscribedHood>[];
  final searchController = TextEditingController();
  var loadData = false.obs;
  var loadSub = false.obs;
  final isSearching = false.obs;
  var subBool = false.obs;
  PdfViewerController? pdfViewerController;
  final GlobalKey<SfPdfViewerState> pdfViewerKey = GlobalKey();
  List<CommentList> commentList = <CommentList>[];
  List<Comment> comments = <Comment>[];
  List<Comment> subComments = <Comment>[];
  var saveReply = false.obs;
  var commentLoad = false.obs;
  final subReplyText = TextEditingController();
  final replyText = TextEditingController();
  var likeType = ''.obs;
  var likesLoad = false.obs;
  var likes = 0.obs;
  var isLibrary = false.obs;
  var dislikes = 0.obs;
  var inLibrary = false.obs;
  Animation<double>? animation;
  AnimationController? animationController;
  bool isSaveLocal = false;
  var isInternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    pdfViewerController = PdfViewerController();
    reload();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));

    final curvedAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController!);
    animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  reload() {
    Utils.checkInternet().then((value) {
      if (!value) {
        // Utils().showError("There's no internet connection");
        isInternet.value = false;
        return;
      }
    });
     isInternet.value = true;
    getUnSubscribed();
    getSubscribed();
  }

  checkSaved(String fileID) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    try {
      var query = {
        "action": "check_library",
        "userID": Utils.userID,
        "attachment": fileID,
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        inLibrary.value = true;
      } else {
        inLibrary.value = false;
      }
    } catch (e) {
      // ignore: avoid_print
      inLibrary.value = false;
      print(e);
      return false;
    }
  }

  getUnSubscribed() {
    loadSub.value = true;
    fetchUnsubscribed().then((value) {
      unSubscribed = [];
      unSubscribed.addAll(value);
      unSubscribedList = [];
      unSubscribedList = unSubscribed;
      loadSub.value = false;
    });
  }

  saveToLibrary(int id, int fileID, String title, String imagePath,
      String author, String description, String pdfPath) async {
    // Utils.checkInternet().then((value) {
    //   if (!value) {
    //     Utils().showError("There's no internet connection");
    //     return;
    //   }
    // });
    try {
      isLibrary.value = true;
      var query = {
        "action": "save_library",
        "userID": Utils.userID.toString(),
        "attachment": fileID.toString(),
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        if (isSaveLocal) {
          LibraryController().savePDF(
              id.toString(), title, author, description, pdfPath, imagePath);
        }
        Utils().showInfo('Hood has been saved into your library');
        checkSaved(id.toString());
        isLibrary.value = false;
      } else {
        Utils().showError("Sorry, something went wrong!");
        isLibrary.value = false;
      }
    } catch (e) {
      // ignore: avoid_print
      isLibrary.value = false;
      print(e);
    }
  }

  Future<void> getComment(int hood) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    commentLoad.value = true;
    commentList = [];
    final comments = await fetchComment(hood);
    for (int i = 0; i < comments.length; i++) {
      final subComments = await fetchSubComment(comments[i].id);
      commentList.add(
        CommentList(
          id: comments[i].id,
          avatar: comments[i].avatar,
          date: comments[i].date,
          username: comments[i].username,
          comment: comments[i].comment,
          subComment: subComments,
        ),
      );
    }
    commentLoad.value = false;
  }

  setLikeDislike(String feedback, int hood) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });

    try {
      var query = {
        "action": "like_dislike",
        "feedback": feedback,
        "userID": Utils.userID,
        "hood_id": hood.toString(),
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        getLikesDislike(hood);
      } else {
        Utils().showError("Sorry, something went wrong!");
        saveReply.value = false;
      }
    } catch (e) {
      // ignore: avoid_print
      saveReply.value = false;
      print(e);
    }
  }

  getLikesDislike(int hoodID) async {
    try {
      var query = {
        "action": "get_feedback",
        "hoodID": hoodID.toString(),
        "userID": Utils.userID,
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'false') {
      } else {
        likesLoad.value = true;
        var data = jsonDecode(result);
        likes.value = data[0]['likes'];
        dislikes.value = data[0]['dislikes'];
        likeType.value = data[0]['type'] ?? '';
      }
    } catch (e) {
      likesLoad.value = false;
      // ignore: avoid_print
      saveReply.value = false;
      print(e);
    }
  }

  getSubscribed() {
    loadData.value = true;
    fetchSubscribed().then((value) {
      subscribed = [];
      subscribed.addAll(value);
      subscribedList = [];
      subscribedList = subscribed;
      loadData.value = false;
    });
  }

  replyComment(String reply, int hood) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    if (reply.isEmpty) {
      Utils().showError("Reply cannot be empty!");
      return;
    }
    try {
      saveReply.value = true;
      var query = {
        "action": "reply",
        "userID": Utils.userID,
        "hood_id": hood.toString(),
        "reply": reply
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        saveReply.value = false;

        replyText.clear();
        getComment(hood);
      } else {
        Utils().showError("Sorry, something went wrong!");
        saveReply.value = false;
      }
      saveReply.value = false;
    } catch (e) {
      // ignore: avoid_print
      saveReply.value = false;
      print(e);
    }
  }

  subReplyComment(int commentID, String reply, int hood) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    if (reply.isEmpty) {
      Utils().showError("Reply cannot be empty!");
      return;
    }
    try {
      saveReply.value = true;
      var query = {
        "action": "sub_reply",
        "comment": commentID.toString(),
        "userID": Utils.userID,
        "reply": reply
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        subReplyText.clear();
        getComment(hood);
        Get.back();
      } else {
        Utils().showError("Sorry, something went wrong!");
        saveReply.value = false;
      }
      saveReply.value = false;
    } catch (e) {
      // ignore: avoid_print
      saveReply.value = false;
      print(e);
    }
  }

  subscribe(int id, String title, int principal) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    try {
      subBool.value = false;
      var query = {
        "action": "subscribe",
        "userID": Utils.userID,
        "principal": principal.toString(),
        "hood_id": id.toString(),
        "userName": Utils.userName,
        "hood": title
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        subBool.value = false;
        Utils().showInfo("You have subscribed to $title.");
        reload();
      } else {
        subBool.value = false;
        Utils().showError("Sorry, something went wrong");
      }
      subBool.value = false;
    } catch (e) {
      // ignore: avoid_print
      subBool.value = false;
      print(e);
    }
  }

  unSubscribe(int id, String title, int principal) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    try {
      subBool.value = false;
      var query = {
        "action": "unsubscribe",
        "userID": Utils.userID,
        "principal": principal.toString(),
        "hood_id": id.toString(),
        "userName": Utils.userName,
        "hood": title
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        subBool.value = false;
        // Utils().showInfo("You have unsubscribed from $title.");
        reload();
        Get.back();
      } else {
        subBool.value = false;
        Utils().showError("Sorry, something went wrong");
      }
      subBool.value = false;
    } catch (e) {
      // ignore: avoid_print
      subBool.value = false;
      print(e);
    }
  }

  read(int id) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    try {
      subBool.value = false;
      var query = {
        "action": "read",
        "userID": Utils.userID,
        "hood_id": id.toString(),
      };
      var result = await Query.queryData(query);
      if (jsonDecode(result) == 'true') {
        subBool.value = false;
      } else {
        subBool.value = false;
      }
      subBool.value = false;
    } catch (e) {
      // ignore: avoid_print
      subBool.value = false;
      print(e);
    }
  }

  Future<List<UnsubscribedHood>> fetchUnsubscribed() async {
    var permission = <UnsubscribedHood>[];
    try {
      var data = {"action": "get_unsubscribed_hoods", "userID": Utils.userID};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(UnsubscribedHood.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  Future<List<Comment>> fetchComment(int hoodID) async {
    var permission = <Comment>[];
    try {
      var data = {"action": "get_comment", "hood_id": hoodID.toString()};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(Comment.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  Future<List<Comment>> fetchSubComment(int comment) async {
    var permission = <Comment>[];
    try {
      var data = {"action": "get_sub_comment", "comment": comment.toString()};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(Comment.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  Future<List<SubscribedHood>> fetchSubscribed() async {
    var permission = <SubscribedHood>[];
    try {
      var data = {"action": "get_subscribed_hoods", "userID": Utils.userID};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(SubscribedHood.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }
}
