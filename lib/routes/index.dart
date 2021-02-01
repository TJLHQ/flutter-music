import 'package:flutter/material.dart';
import 'package:music/pages/tabs.dart';
import '../pages/lead.dart';
import 'package:music/base/recommentDetail.dart';
import '../base/singerDetail.dart';
import 'package:music/base/rankDetail.dart';
import '../pages/player.dart';
import '../pages/project.dart';
import '../pages/photo.dart';
import '../pages/me.dart';
import '../pages/addSong.dart';
import '../components/other.dart';
//配置路由
final routes={
  '/':(context)=>Lead(),
  '/tabs':(context)=>Tabs(),
  '/recommentDetail':(context,{arguments})=>RecommentDetail(arguments:arguments),
  '/singerDetail':(context,{arguments})=>SingerDetail(arguments:arguments),
  '/rankDetail':(context,{arguments})=>RankDetail(arguments:arguments),
  '/player':(context)=>Player(),
  '/project':(context)=>Project(),
  '/photo':(context)=>Photo(),
  '/me':(context)=>Me(),
  '/addSong':(context)=>AddSong(),
  '/other':(context)=>Others()
};

//固定写法
var onGenerateRoute=(RouteSettings settings) {
  // 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    }else{
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context));
      return route;
    }
  }
};