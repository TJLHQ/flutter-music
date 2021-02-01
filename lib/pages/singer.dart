import 'package:flutter/material.dart';
import 'package:music/dao/singerDao.dart';
import 'package:music/model/singer.dart';
import 'package:music/components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../components/loading.dart';
class Singer extends StatefulWidget {
  @override
  _SingerState createState() => _SingerState();
}

class _SingerState extends State<Singer> with AutomaticKeepAliveClientMixin{
  List<SingerItem> singerList = [];
  List<SingerTitle> singerLetter = [];
  ScrollController _scrollController = ScrollController();
  int singerIndex = 0;
  int _singerCurrentIndex = 0;
  double _scrollUpdate = 0.0;
  bool isLoading=true;
  @override
  bool get wantKeepAlive=>true;
  @override
  void initState() {
    initLoad();
    super.initState();
  }

  void initLoad() async {
    var res = await SingerDao.singerAjax();
    if (res.code == 0) {
      setState(() {
        singerList = res.result;
      });
      setSingerLetter(res.result);
    }
    setState(() {
      isLoading=false;
    });
  }

  void setSingerLetter(List<SingerItem> arr) {
    List<SingerTitle> arrList = [];
    int index = 0;
    arr.forEach((item) {
      index += item.items.length;
      arrList.add(SingerTitle(item.title, index));
    });
    setState(() {
      singerLetter = arrList;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _player = Provider.of<PlayProvider>(context);
    return LoadingContainer(
        isLoading: isLoading,
        child:Stack(
          children: <Widget>[
            NotificationListener(
              onNotification: (ScrollNotification scrollNotification) {
                _setSingerIndex(scrollNotification.metrics.pixels);
              },
              child: ListView(
                controller: _scrollController,
                children: <Widget>[
                  ... singerList.map((item) {
                    return Column(
                      children: <Widget>[
                        Container(
                            alignment: Alignment.centerLeft,
                            height: 30,
                            color: Color(0xff333333),
                            child: Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Text(
                                item.title,
                                style:
                                TextStyle(fontSize: 14, color: MyColors.textD),
                              ),
                            )),
                        Container(
                          padding: EdgeInsets.only(left: 30, right: 30),
                          margin: EdgeInsets.only(bottom: 30),
                          child: Column(
                            children: item.items.map((k) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/singerDetail',
                                        arguments: {
                                          "id": k.id,
                                          "title": k.name,
                                          "bgImage": k.avatar
                                        });
                                  },
                                  child: Container(
                                    height: 70,
                                    padding: EdgeInsets.only(top: 20),
                                    alignment: Alignment.center,
                                    color: Colors.transparent,
                                    child: Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          backgroundImage: NetworkImage(k.avatar),
                                          radius: 25,
                                          backgroundColor: MyColors.textD,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                            k.name,
                                            style: TextStyle(
                                                decoration: TextDecoration.none,
                                                fontSize: 14,
                                                color: MyColors.textD),
                                          ),
                                        )
                                      ],
                                    ),
                                  ));
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  Offstage(
                      offstage:_player.playList.isEmpty ,
                      child: SizedBox(
                        height: 40,
                      )
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment(1,-0.5),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: 20,
                height: 490,
                decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.3),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: singerLetter.asMap().keys.map((int index) {
                      SingerTitle item = singerLetter[index];
                      return GestureDetector(
                          onTap: () {
                            if (index == 0) {
                              _scrollTo(0, index);
                            } else {
                              _scrollTo(
                                  (singerLetter[index - 1]).currentIndex, index);
                            }
                          },
                          onVerticalDragStart: (DragStartDetails e) {
                            _singerCurrentIndex = index;
                            _scrollUpdate = 0.0;
                          },
                          onVerticalDragUpdate: (DragUpdateDetails e) {
                            _scrollUpdate += e.delta.dy;
                            int _num =
                                _singerCurrentIndex + (_scrollUpdate / 20).ceil();
                            if (_num >= (singerLetter.length - 1)) {
                              _num = singerLetter.length - 1;
                            } else if (_num < 0) {
                              _num = 0;
                            }
                            if (_num == 0) {
                              _scrollTo(0, index,true);
                            } else {
                              _scrollTo(
                                  (singerLetter[_num - 1]).currentIndex, _num,true);
                            }
                          },
                          child: Container(
                            height: 20,
                            padding: EdgeInsets.all(3),
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Text(
                              item.title.length > 1
                                  ? item.title.substring(0, 1)
                                  : item.title,
                              style: TextStyle(
                                  color: index == singerIndex
                                      ? MyColors.textColor
                                      : MyColors.textD,
                                  fontSize: 12),
                            ),
                          ));
                    }).toList()),
              ),
            )
          ],
        )
    );
  }

  void _scrollTo(int currentIndex, int index,[bool jumTo=false]) {
    if (index == 0) {
      if(jumTo){
        _scrollController.jumpTo(0.0);
      }else{
        _scrollController.animateTo(0.0,
            duration: Duration(milliseconds: 200), curve: Curves.linear);
      }

    } else {
      if(jumTo){
        _scrollController.jumpTo((currentIndex.toDouble() * 70) + 60 * index.toDouble());
      }else{
        _scrollController.animateTo(
            (currentIndex.toDouble() * 70) + 60 * index.toDouble(),
            duration: Duration(milliseconds: 200),
            curve: Curves.linear);
      }
    }
  }

  void _setSingerIndex(double val) {
    if (val <= 0) {
      setState(() {
        singerIndex = 0;
      });
    }
    for (int i = 0; i < singerLetter.length; i++) {
      double pre;
      if (i - 1 < 0) {
        pre = 0.0;
      } else {
        pre = (singerLetter[i - 1].currentIndex * 70) + 60 * i.toDouble();
      }
      double next = (singerLetter[i].currentIndex * 70) + 60 * i.toDouble();
      if (pre <= val && val < next) {
        setState(() {
          singerIndex = i;
        });
        return;
      }
    }
  }
}
