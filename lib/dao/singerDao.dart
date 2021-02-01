import 'dart:async';
import 'dart:convert';
import 'package:music/model/singer.dart';
import './http.dart';
import 'package:music/model/detail.dart';
class SingerDao{
  static Future<Singer> singerAjax() async{
    var data= await getHttp('/singerlist');
    return Singer.fromJson(json.decode(data.toString()));
  }
  static Future<DescDetail> singerDetailAjax(String id) async{
    var data= await getHttp('/singerdetail',data: {"singerId":id});
    return DescDetail.fromJson(json.decode(data.toString()));
  }
  static Future<SongUrl> songUrlAjax(String mid) async{
    var data= await getHttp('/songUrl',data: {"mid":mid});
    return SongUrl.fromJson(json.decode(data.toString()));
  }
  static Future<Lyric> songLyric(String mid) async{
    var data= await getHttp('/songLyrics',data: {"mid":mid});
    return Lyric.fromJson(json.decode(data.toString()));
  }
}