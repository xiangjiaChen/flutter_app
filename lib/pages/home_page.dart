import 'dart:convert';

import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  // String homePageContent = '正在获取数据';
  // @override
  // void initState() {
  //   getHomePageContent().then((value){
  //     setState(() {
  //       homePageContent = value.toString();
  //     });
  //   });
  //   super.initState();
  // }

  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    print('重新加载');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      // 完美解决异步请求后渲染，并且不用setstate
      body: FutureBuilder(
        future: request('homePageContent',formData: {'lon': '115.02932', 'lat': '35.76189'}),
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navgatorList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];
            List<Map> recommendList = (data['data']['recommend'] as List).cast();
            String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];
            String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];
            String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];
            List<Map> floor1 = (data['data']['floor1'] as List).cast();
            List<Map> floor2 = (data['data']['floor2'] as List).cast();
            List<Map> floor3 = (data['data']['floor3'] as List).cast();

            return EasyRefresh(
              footer: ClassicalFooter(
                bgColor: Colors.white,
                textColor: Colors.pink,
                infoColor: Colors.pink,
                noMoreText: '',
                loadingText: 'Loading',
                loadReadyText: '上拉加载...'
              ),

              child:ListView(
                children: <Widget>[
                  SwiperDiy(swiperDateList: swiper),
                  TopNavigator(navgatorList:navgatorList),
                  AdBannner(adPicture: adPicture),
                  LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                  Recommend(recommendList:recommendList),
                  FloorTitle(pictureAddress: floor1Title),
                  FloorContent(floorGoodsList: floor1),
                  FloorTitle(pictureAddress: floor2Title),
                  FloorContent(floorGoodsList: floor2),
                  FloorTitle(pictureAddress: floor3Title),
                  FloorContent(floorGoodsList: floor3),
                  _hotGoods()
                ]
              ),
              onLoad:() async{
                var formData = {'page': page};
                await request('homePageBelowContent',formData:formData).then((value){
                  var data = json.decode(value.toString());
                  // bugfix: 长度为0不加载
                  if(data['data'] != null) {
                    List<Map> newGoodList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodList);
                      page++;
                    });
                  }else{
                    print('加载结束');
                  }
                });
              }
            );
          }else{
            return Center(
              child: Text('加载中')
            );
          }
        },
      ),
      // SingleChildScrollView与listview不要一起使用
      // body: SingleChildScrollView(
      //   child: Text(homePageContent),
      // ),
    );
  }


  Widget hotTitle = Container(
    margin: EdgeInsets.only(top:10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5.0),
    child: Text('火爆专区'),
  );

  Widget _wrapList(){
    if(hotGoodsList.length !=0 ){
      List<Widget> listWidget = hotGoodsList.map((value){
        return InkWell(
          onTap: (){},
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(value['image'], width: ScreenUtil().setWidth(370)),
                Text(
                  value['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('￥${value['mallPrice']}'),
                    Text(
                      '￥${value['price']}',
                      style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),
                    )
                  ]
                )
              ],
            ),
          )
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else{
      return Text('无火爆商品推荐');
    }
  }

  Widget _hotGoods(){
    return Container(
      child: Column(
        children: [
          hotTitle,
          _wrapList()
        ],
      ),
    );
  }

}

// 首页轮播组件
class SwiperDiy extends StatelessWidget {

  final List swiperDateList;
  // 构造函数
  SwiperDiy({Key key, this.swiperDateList}):super(key: key);

  @override
  Widget build(BuildContext context) {
    
    print('设备像素密度：${ScreenUtil().pixelRatio}');
    print('设备的高：${ScreenUtil().screenHeight}');
    print('设备的宽：${ScreenUtil().screenWidth}');
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(333),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network("${swiperDateList[index]['image']}",fit: BoxFit.fill,);
        },
        itemCount: 3,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

// 中间菜单组件
class TopNavigator extends StatelessWidget {
  final List navgatorList;

  TopNavigator({Key key, this.navgatorList}) : super(key: key); 

  Widget _gridViewItemUI(BuildContext context,item){
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: [
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(this.navgatorList.length > 10){
      this.navgatorList.removeRange(10, this.navgatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(340),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(), //禁止回弹
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navgatorList.map((item){
          return _gridViewItemUI(context,item);
        }).toList(),
      ),
    );
  }
}

// 广告组件
class AdBannner extends StatelessWidget {
  final String adPicture;

  AdBannner({Key key, this.adPicture}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}):super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
      
    );
  }

  // 拨打电话
  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    // String url = 'https://www.baidu.com';
    print(url);
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "url不能访问";
    }
  }
}

// 商品推介模块
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend({Key key, this.recommendList}):super(key: key);

  // 标题方法
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5,color: Colors.black12)
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品单独项方法
  Widget _item(index){
    return InkWell(
      onTap:(){},
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1,color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            ),
          ],
        ),
      )
    );
  }

  // 横向列表方法
  Widget _recommedList(){
    return Container(
      height: ScreenUtil().setHeight(380),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _item(index);
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(480),
      margin: EdgeInsets.only(top:10.0),
      child: Column(
        children: [
          _titleWidget(),
          _recommedList()
        ]
      ),
    );
  }
}

// 楼层标题
class FloorTitle extends StatelessWidget {
  final String pictureAddress;

  FloorTitle({Key key, this.pictureAddress}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(pictureAddress),
    );
  }
}

// 楼层商品列表
class FloorContent extends StatelessWidget {

  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _firstRow(),
          _otherGoods(),
        ],
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: [
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ],
        )
      ]
    );
  }

  Widget _otherGoods(){
    return Row(
      children: [
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){print('点击了楼层');},
        child: Image.network(goods['image']),
      ),
    );
  }
}


// 火爆专区-有上拉效果【页面变化：setstate，bloc，redux】
// class HotGoods extends StatefulWidget {
//   @override
//   _HotGoodsState createState() => _HotGoodsState();
// }

// class _HotGoodsState extends State<HotGoods> {
//   void initState() {
//     request('homePageBelowContent',formData: 1).then((value){
//       print(value);
//     });
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Text('dalien'),
//     );
//   }
// }