import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import './config/httpHeader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String showText = "还没有请求数据";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('请求远程数据')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              RaisedButton(
                onPressed: _jike,
                child: Text('请求数据'),
              ),
              Text(showText)
            ],
          )
        )
      )
    );
  }

  void _jike(){
    print('开始请求数据...');
    getHttp().then((value){
      setState(() {
        showText = value['data'].toString();
      });
    });
  }

  Future getHttp() async {
    try {
      Response response;
      Dio dio = Dio();
      dio.options.headers = httpHeaders;
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
      };
      print(dio);
      response = await dio.post("https://time.geekbang.org/serv/v3/lecture/list",
        queryParameters: {
          'label_id': 0, 
          'type': 0
        }
      );
      print(response);

      return response.data;
    } catch (e) {
      print(e);
    }
  }
}