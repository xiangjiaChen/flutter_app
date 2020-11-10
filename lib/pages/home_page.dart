import 'dart:convert';

import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('百姓生活+')),
      // 完美解决异步请求后渲染，并且不用setstate
      body: FutureBuilder(
        future: getHomePageContent(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List<Map> swiper = (data['data']['slides'] as List).cast();
            List<Map> navgatorList = (data['data']['category'] as List).cast();
            String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
            String leaderImage = data['data']['shopInfo']['leaderImage'];
            String leaderPhone = data['data']['shopInfo']['leaderPhone'];

            return Column(
              children: <Widget>[
                SwiperDiy(swiperDateList: swiper),
                TopNavigator(navgatorList:navgatorList),
                AdBannner(adPicture: adPicture),
                LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
              ]
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
    print(url);
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw "url不能访问";
    }
  }
}