import 'dart:async';
import 'dart:convert';
import 'package:music/model/hotSearch.dart';
import './http.dart';
import 'package:music/model/searchList.dart';
class SearchDao{
  static Future<HotSearch> hotSearchAjax() async{
    var data= await getHttp('/hotSearch');
    return HotSearch.fromJson(json.decode(data.toString()));
  }
  static Future<SearchList> searchListAjax(String keyword,int page,int zhida,int perpage) async{
    var data= await getHttp('/inputList',data: {"keyword":keyword,"page":page,"zhida":zhida,"perpage":perpage});
    return SearchList.fromJson(json.decode(data.toString()));
  }
}