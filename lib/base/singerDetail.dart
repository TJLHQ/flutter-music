import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/model/detail.dart';
import '../dao/singerDao.dart';
import '../components/music-list.dart';

class SingerDetail extends StatefulWidget {
  Map arguments;

  SingerDetail({Key key, this.arguments}) : super(key: key);

  @override
  _SingerDetailState createState() => _SingerDetailState();
}

class _SingerDetailState extends State<SingerDetail> {
  List<DescDetailItem> descList = [];
  @override
  void initState() {
    initload();
    super.initState();
  }

  void initload() async {
    var res = await SingerDao.singerDetailAjax(widget.arguments['id']);
    if (res.code == 0) {
      setState(() {
        descList = res.result;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return MusicList(
      bgImage: widget.arguments['bgImage'],
      title: widget.arguments['title'],
      musicList: descList,);
  }
}
