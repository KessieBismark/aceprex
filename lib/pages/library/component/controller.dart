import 'dart:convert';
import 'dart:io';
import '../../../services/isolate_services/notification.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../services/utils/helpers.dart';
import '../../../services/utils/notify.dart';
import '../../../services/utils/query.dart';
import '../../startup/startup.dart';
import '../../../services/database/local_db.dart';
import 'model.dart';

class LibraryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final searchController = TextEditingController();
  var loadData = false.obs;
  final isSearching = false.obs;
  var loadLocal = false.obs;
  var saveLocal = false.obs;
  List<PDFModel> pdfs = <PDFModel>[];
  List<PDFModel> pdfsData = <PDFModel>[];
  AnimationController? animateController;
  Animation<double>? animate;
  PdfViewerController? pdfController;
  List<LibraryModel> library = <LibraryModel>[];
  List<LibraryModel> libraryList = <LibraryModel>[];
  final GlobalKey<SfPdfViewerState> pdfKey = GlobalKey();
  int? deleteID;
  var isDelete = false.obs;
  var libExist = false.obs;
  var isInternet = true.obs;
  var checkLdb = false.obs;
  String? saveID;
  var isDeleteOnline = false.obs;
  int? deleteOnline;

  @override
  void onInit() {
    super.onInit();
    if (Utils.userID.isEmpty) {
      Get.to(() => const StartUp());
    }
    pdfController = PdfViewerController();
    animateController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));
    final curveAnimation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animateController!);
    animate = Tween<double>(begin: 0, end: 1).animate(curveAnimation);
    reload();
    fetchPDFs();
  }

  reload() {
    Utils.checkInternet().then((value) {
      if (!value) {
        //  Utils().showError("There's no internet connection");
        isInternet.value = false;
        return;
      }
    });
    isInternet.value = true;
    getLibrary();
  }

  getLibrary() {
    loadData.value = true;
    fetchLibrary().then((value) {
      library = [];
      library.addAll(value);
      libraryList = [];
      libraryList = library;
      loadData.value = false;
    });
  }

  isLibraryIdExists(int libraryId) async {
    checkLdb.value = true;
    if (libraryId == 0) {
      libExist.value = false;
      Utils().showError("File not found");
    } else {
      final db = DatabaseHelper.instance;
      libExist.value = await db.isLibraryIdExists(libraryId);
    }

    checkLdb.value = false;
  }

  checkLocalDB(int id) {
    bool exist = false;
    for (int i = 0; i < pdfs.length; i++) {
      if (pdfs[i].libraryId == id) {
        exist = true;
      }
    }
    // checkLdb.value = true;
    // checkLdb.value = false;
    return exist;
  }

  Future<void> fetchPDFs() async {
    loadLocal.value = true;
    final db = DatabaseHelper.instance;
    final pdfList = await db.getPDFs();
    pdfs.assignAll(pdfList);
    pdfsData = pdfs;
    loadLocal.value = false;
  }

  Future<bool> requestPermissions() async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> savePDF(
    String dataId,
    String title,
    String author,
    String description,
    String pdfPath,
    String imagePath,
  ) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });
    saveID = dataId;
    try {
      NotificationService.showNotification(
          id: createUniqueId(),
          title: title,
          body: 'Downloading Publication',
          channelKey: 'library download',
          notificationLayout: NotificationLayout.ProgressBar,
          payload: ({"type": "library"}));
      saveLocal.value = true;
      final directory = await getApplicationDocumentsDirectory();
      final pdfDirectory =
          await Directory('${directory.path}/pdf').create(recursive: true);
      final imageDirectory = await Directory('${directory.path}/pdfimages')
          .create(recursive: true);

      final pdfFileName = path.basename(pdfPath);
      final imageFileName = generateValidFileName(imagePath);

      final pdfFile = File('${pdfDirectory.path}/$pdfFileName');
      final imageFile = File('${imageDirectory.path}/$imageFileName');

      final dio = Dio();
      await dio.download(pdfPath, pdfFile.path);

      final response = await http.get(Uri.parse(imagePath));
      await imageFile.writeAsBytes(response.bodyBytes);

      final pdf = PDFModel(
        libraryId: int.parse(dataId),
        title: title,
        author: author,
        description: description,
        pdfPath: pdfFile.path,
        imagePath: imageFile.path,
      );

      final db = DatabaseHelper.instance;
      final id = await db.insertPDF(pdf);
      pdfs.add(pdf.copyWith(id: id));
      saveLocal.value = false;
      AwesomeNotifications()
          .cancelNotificationsByChannelKey('library download');
      NotificationService.showNotification(
        id: id,
        title: title,
        body:
            '$title research has been saved to your local library successfully',
        channelKey: 'library',
        payload: ({
          "type": "library",
          "title": title,
          "fileLink": pdfFile.path,
          "id": dataId,
          "author": author,
          "image": imageFile.path,
          "description": description
        }),
      );
      fetchPDFs();
      checkLocalDB(int.parse(dataId));
      loadData.value = true;
      loadData.value = false;
      checkLdb.value = checkLdb.value;
    } catch (e) {
      saveLocal.value = false;
      debugPrint(e.toString());
    }
  }

  deleteOnlineLib(int id, int attachment) async {
    Utils.checkInternet().then((value) {
      if (!value) {
        Utils().showError("There's no internet connection");
        return;
      }
    });

    try {
      deleteOnline = id;
      isDeleteOnline.value = true;
      var query = {
        "action": "delete_library",
        "id": id.toString(),
      };
      var response = await Query.queryData(query);
      if (jsonDecode(response) == 'true') {
        isDeleteOnline.value = false;
        getLibrary();
        Utils().showInfo('Data has been deleted from library');
      } else {
        Utils().showError("Sorry, something went wrong!");
      }
      isDeleteOnline.value = false;
    } catch (e) {
      isDeleteOnline.value = false;
      // ignore: avoid_print
      print(e);
    }
  }

  String generateValidFileName(String url) {
    final fileName = path.basename(url);
    final validFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.-]'), '_');
    return validFileName;
  }

  Future<void> deletePDF(int id, String pdfPath, String imagePath) async {
    deleteID = id;
    isDelete.value = true;
    final db = DatabaseHelper.instance;
    await db.deletePDF(id);
    pdfs.removeWhere((pdf) => pdf.id == id);
    pdfsData = pdfs;
    loadLocal.value = true;
    loadLocal.value = false;
    await File(pdfPath).delete();
    await File(imagePath).delete();
    isDelete.value = false;
  }

  Future<List<LibraryModel>> fetchLibrary() async {
    var permission = <LibraryModel>[];
    try {
      var data = {"action": "get_library", "userID": Utils.userID};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(LibraryModel.fromJson(empJson));
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
