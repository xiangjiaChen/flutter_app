import 'dart:convert';

import 'package:flutter/material.dart';
import '../service/service_method.dart';
import '../model/category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    _getCategory();
    return Container(
      child: Center(
        child: Text('分类页面'),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((value){
      var data = json.decode(value.toString());
      CategoryBigListModel list = CategoryBigListModel.formJson(data['data']);
      list.data.forEach((item) => { 
        print(item.mallCategoryName)
      });
    });
  }
}