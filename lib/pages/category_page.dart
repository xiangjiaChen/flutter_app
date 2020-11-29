import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/model/category%20copy.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body: Container(
        child: Row(
          children: [
            LeftCategoryNav(),
            Column(
              children: [
                RightCategoryNav(),
                CategoryGoodsList()
              ],
            )
          ]
        ),
      ),
    );
  }

}

// 左侧大类导航 
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {

  List list = [];
  var listIndex = 0;

  @override
  void initState() {
    _getCategory();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return  _leftInkWell(index);
        }
      ),
    );
  }

  Widget _leftInkWell(int index){
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap:(){
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        Provide.value<ChildCategory>(context).getchildCategory(childList);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 15),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          ) 
        ),
        child: Text(list[index].mallCategoryName,style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((value){
      var data = json.decode(value.toString());
      CategoryModel category = CategoryModel.fromJson(data) ;
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getchildCategory(list[0].bxMallSubDto);
      // list.data.forEach((item) => { 
      //   print(item.mallCategoryName)
      // });
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context,child,childCategory){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setHeight(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border:Border(
              bottom: BorderSide(width: 1, color: Colors.black12)
            )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index){
              return _rightInkWell(childCategory.childCategoryList[index]);
            }
          ),
        );
      },
    );
  }

  Widget _rightInkWell(BxMallSubDto item){
    return InkWell(
      onTap:(){},
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0,),
        child: Text(
          item.mallSubName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28))
        )
      )
    );
  }
}

// 商品列表
class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {

  List list = [];

  @override
  void initState() { 
    _getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        width: ScreenUtil().setWidth(570),
        height: ScreenUtil().setHeight(970),
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context,index){
            return _ListWidget(index);
          }
        ),
      ),
    );
  }

  void _getGoodsList() async{
    var data = {
      'categoryId': '4',
      'CategorySubId': "",
      'page': 1
    };
    await request('getMallGoods', formData: data).then((value){
      var data = json.decode(value.toString());
      CategoryGoodsListModel goodList = CategoryGoodsListModel.fromJson(data);
      setState(() {
        list = goodList.data;
      });
    });
  }

  Widget _goodsImage(index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  Widget _goodsName(index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      )
    );
  }

  Widget _goodPrice(index){
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: [
          Text(
            '价格：￥${list[index].presentPrice}',
            style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '￥${list[index].oriPrice}',
            style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
          ),
        ],
      )
    );
  }

  Widget _ListWidget(int index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: Colors.black12
            ),
          )
        ),
        child:Row(
          children: <Widget>[
            _goodsImage(index),
            Column(
              children: [
                _goodsName(index),
                _goodPrice(index)
              ],
            )
          ],
        )
      )
    );
  }
}