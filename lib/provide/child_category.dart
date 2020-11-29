import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier{
  List<BxMallSubDto> childCategoryList = [];

  getchildCategory(List<BxMallSubDto> list){
    BxMallSubDto all = BxMallSubDto(
      mallSubId: '00',
      mallCategoryId: '00',
      comments: 'null',
      mallSubName: '全部',
    );
    // all.mallSubId = '00';
    // all.mallCategoryId = '00';
    // all.comments = 'null';
    // all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);

    notifyListeners();
  }
}