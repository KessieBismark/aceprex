import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class ArticleController extends GetxController {
  List<CatModel> category = <CatModel>[];
  List<ArticleModel> article = <ArticleModel>[];
  List<ArticleModel> articleList = <ArticleModel>[];
  var loadData = false.obs;
  var loadCat = false.obs;
  var curIndex = 0.obs;
  var cIndex = false.obs;
  var isInternet = true.obs;
  Timer? timer;
  bool dataLoaded = false;
  bool shouldContinueTimer = true;
  @override
  void onInit() {
    super.onInit();
    reload();
  }

  reload() {
    curIndex.value = -1;
    Utils.checkInternet().then((value) {
      if (!value) {
        // Utils().showError("There's no internet connection");
        isInternet.value = false;
        return;
      }
    });
    isInternet.value = true;
    getCategory();
    getData();
  }

  getCategory() {
    loadCat.value = true;
    fetchCategory().then((value) {
      category = [];
      category.addAll(value);
      loadCat.value = false;
      dataLoaded = true;
      timer?.cancel();
    });
  }

  getData({int id = 0}) {
    loadData.value = true;
    fetchData(id).then((value) {
      article = [];
      article.addAll(value);
      articleList = [];
      articleList = article;
      loadData.value = false;
    });
  }

  Future<List<CatModel>> fetchCategory() async {
    var permission = <CatModel>[];
    try {
      var data = {
        "action": "get_articles_category",
      };
      var result = await Query.queryData(data);

      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(CatModel.fromJson(empJson));
        }
      }
      return permission;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return permission;
    }
  }

  Future<List<ArticleModel>> fetchData(int id) async {
    var permission = <ArticleModel>[];
    try {
      var data = {"action": "get_articles", "catID": id.toString()};
      var result = await Query.queryData(data);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(ArticleModel.fromJson(empJson));
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
