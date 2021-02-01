import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/model/detail.dart';
import '../dao/recomment.dart';
import '../components/music-list.dart';

class RecommentDetail extends StatefulWidget {
  Map arguments;

  RecommentDetail({Key key, this.arguments}) : super(key: key);

  @override
  _RecommentDetailState createState() => _RecommentDetailState();
}

class _RecommentDetailState extends State<RecommentDetail> {
  List<DescDetailItem> descList = [];
  @override
  void initState() {
    initload();
    super.initState();
  }

  void initload() async {
    var res = await RecommentDao.descDetailAjax(widget.arguments['dissid']);
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
