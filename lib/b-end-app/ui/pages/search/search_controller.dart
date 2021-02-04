/*
 * @Description: 搜索页面controller
 * @Author: iamsmiling
 * @Date: 2021-01-07 14:25:44
 * @LastEditTime: 2021-02-02 16:42:57
 */

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taoju5/b-end-app/domain/model/search/search_model.dart';
import 'package:taoju5/b-end-app/domain/repository/search/search_repository.dart';

enum SearchType { customer, order, product }

class SearchController extends GetxController {
  ///[记录搜索历史和用户信息
  SharedPreferences _sp;
  SearchModel result;
  Map<SearchType, List<String>> _searchHistory = {
    SearchType.customer: [],
    SearchType.order: [],
    SearchType.product: [],
  };

  Map<SearchType, String> _searchTip = {
    SearchType.customer: "搜索客户",
    SearchType.product: "搜索款号或关键词",
    SearchType.order: "搜索订单",
  };

  static const int MAX_LENGTH = 10;

  SearchType get type => Get.arguments;
  String get hintText => _searchTip[type];
  List<String> get historyList {
    return _searchHistory[type];
  }

  TextEditingController textEditingController;

  @override
  void onInit() {
    _init();
    textEditingController = TextEditingController()..addListener(() {});
    loadData();
    super.onInit();
  }

  @override
  void onClose() {
    textEditingController?.dispose();
    super.onClose();
  }

  void _init() async {
    _sp = await SharedPreferences.getInstance();
    _sync();
  }

  void addSearchItem(String data) {
    print(data);
    print(historyList);
    historyList.add(data);
    print("+++___");
    print(historyList);
    print("添加搜索记录");
    _persist();

    ///刷新搜索记录
    update(["history"]);
  }

  Future loadData() {
    SearchRepository repository = SearchRepository();
    return repository.search().then((SearchModel value) {
      result = value;
    });
  }

  void removeSearchItem(String data) {
    historyList.remove(data);
    _persist();

    ///刷新搜索记录
    update(["history"]);
  }

  ///同步数据到内存中
  void _sync() {
    _searchHistory[type] = _sp.getStringList(type.toString());
    print(_searchHistory[type]);

    ///刷新搜索记录
    update(["history"]);
  }

  ///数据持久化
  void _persist() {
    _sp.setStringList(type.toString(), historyList);
  }

  void clear() {
    print("+++___");
    historyList?.clear();
    _persist();
    update(["history"]);
    Get.back();
  }
}
