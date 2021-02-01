import 'dart:async';
import 'package:dio/dio.dart';
 Future getHttp(String url,{Map<String,dynamic> data}) async{
    try{
      Response response;
      var dio = Dio(BaseOptions(
    baseUrl: "http://music.mmys.fun/api",
//    connectTimeout: 5000,
    receiveTimeout: 100000,
  ));
      response = await dio.get(url,queryParameters: data??{});
      if(response.statusCode==200){
        return response;
      }
    }catch(e){
      return print('catch.............$e');
    }
  }