import 'package:flutter/material.dart';
import 'package:music/model/detail.dart';
import '../dao/rankDao.dart';
import '../components/music-list.dart';

class RankDetail extends StatefulWidget {
  Map arguments;

  RankDetail({Key key, this.arguments}) : super(key: key);

  @override
  _RankDetailState createState() => _RankDetailState();
}

class _RankDetailState extends State<RankDetail> {
  List<DescDetailItem> descList = [];
  @override
  void initState() {
    initload();
    super.initState();
  }

  void initload() async {
    var res = await RankDao.rankDetailAjax(widget.arguments['id']);
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
      musicList: descList,
      rank: true,
    );
  }
}
