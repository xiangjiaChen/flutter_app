import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController typeController = TextEditingController();
  String showText = '欢迎您来到美好人家';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('美好人家'),),
        body: SingleChildScrollView(
          child:Container(
            child: Column(
            children: [
              TextField(
                controller: typeController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  labelText: '美女类型',
                  helperText: '请输入你喜欢的类型'
                ),
                autofocus: false,
              ),
              RaisedButton(
                onPressed: _choiceAction,
                child: Text('选择完毕'),
              ),
              Text(
                showText,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              )
            ],
          ),
        ),
        )
      ),
    );
  }

  // 内部方法下划线_

  void _choiceAction(){
    print('开始选择您的类型..........');
    if(typeController.text.toString() == ''){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(title: Text('美女类型不能为空'))
      );
    }else{
      getHttp(typeController.text.toString()).then((value){
        setState(() {
          showText = value['data']['name'].toString();
        });
      });
    }
  }

  Future getHttp(String typeText) async{
    try {
      Response response;
      var data = {'name': typeText};

      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
      };
      response = await dio.post("https://www.fastmock.site/mock/bb4a6d7a76122b30e2b8974f0e4b286d/shop/api/post_dabaojian",
        queryParameters: data
      );
      return response.data;
    } catch (e) {
      return print(e);
    }
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     getHttp();
//     return Scaffold(
//       body: Center(
//         child: Text('商城首页'),
//       ),
//     );
//   }

//   void getHttp() async {
//     try {
//       // 处理证书异常的，无法进行请求的问题, 强行信任
//       Dio dio = Dio();
//       (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//           (client) {
//         client.badCertificateCallback = (cert, host, port) {
//           return true;
//         };
//       };

//       Response response;
//       response = await dio.get(
//           'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=长腿小姐姐');
//       print(response);
//     } catch (e) {
//       return print(e);
//     }
//   }

// }
