import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/utils/helpers.dart';
import '../../../services/utils/query.dart';
import 'model.dart';

class TechNewsController extends GetxController {
  final searchController = TextEditingController();
  var loadData = false.obs;
  final isSearching = false.obs;
  List<TechModel> techNews = <TechModel>[];
  List<TechModel> techNewsList = <TechModel>[];
  var isInternet = true.obs;

  @override
  void onInit() {
    super.onInit();
    reload();
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
    getData();
  }

  getData() {
    loadData.value = true;
    fetchData().then((value) {
      techNews = [];
      techNews.addAll(value);
      techNewsList = [];
      techNewsList = techNews;
      loadData.value = false;
    });
  }

  Future<List<TechModel>> fetchData() async {
    var permission = <TechModel>[];
    try {
      var data = {"action": "get_tech_news"};
      var result = await Query.queryData(data);
      print(result);
      var empJson = json.decode(result);
      if (empJson == 'false') {
      } else {
        for (var empJson in empJson) {
          permission.add(TechModel.fromJson(empJson));
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
