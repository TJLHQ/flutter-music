import 'dart:async';
import 'dart:convert';
import 'package:music/model/detail.dart';

import '../model/banner.dart';
import '../model/desc.dart';
import './http.dart';
class RecommentDao{
  static Future<Banner> bannerAjax() async{
    var data= await getHttp('/banner');
    return Banner.fromJson(json.decode(data.toString()));
  }
  static Future<Desc> descAjax() async{
    var data= await getHttp('/desclist');
    return Desc.fromJson(json.decode(data.toString()));
  }
  static Future<DescDetail> descDetailAjax(String dissid) async{
    var data= await getHttp('/descSong',data: {"dissid":dissid});
    return DescDetail.fromJson(json.decode(data.toString()));
  }
}