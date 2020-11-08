import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    dueCertificate();
    getHttp();
    return Scaffold(
      body: Center(
        child: Text('商城首页'),
      ),
    );
  }

  void getHttp() async {
    try {
      // 处理证书异常的，无法进行请求的问题, 强行信任
      Dio dio = Dio();
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          return true;
        };
      };

      Response response;
      response = await dio.get(
          'https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian?name=长腿小姐姐');
      print(response);
    } catch (e) {
      return print(e);
    }
  }

  
  void dueCertificate() {

  }
}
