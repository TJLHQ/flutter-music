import 'dart:async';
import 'dart:convert';
import 'package:music/model/detail.dart';
import 'package:music/model/rank.dart';
import './http.dart';
class RankDao{
  static Future<Rank> rankAjax() async{
    var data= await getHttp('/rank');
    return Rank.fromJson(json.decode(data.toString()));
  }
  static Future<DescDetail> rankDetailAjax(int id) async{
    var data= await getHttp('/rankdetail',data: {"topid":id});
    return DescDetail.fromJson(json.decode(data.toString()));
  }
}