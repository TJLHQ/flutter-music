import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/searchBar.dart';
import 'package:music/components/color.dart';
import 'package:music/components/wrap.dart';
import '../dao/searchDao.dart';
import '../model/hotSearch.dart';
import '../components/suggest.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../pages/player.dart';
import '../model/detail.dart';
import '../components/alert.dart';
import '../util/cache.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
GlobalKey<SearchBarState> globalKey = GlobalKey();
GlobalKey<SuggestState> globalSuggest = GlobalKey();

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin{
  final String TYPE_SINGER = 'type_singer';
  List<HotSearchItem> hotSearchList = [];
  String query = '';
  @override
  void initState() {
    hotSearch();
    PlayProvider _player = Provider.of<PlayProvider>(context,listen: false);
    new Cache();
    Future.delayed(Duration(milliseconds: 20),(){
      _player.getSearchHistory();
    });
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if(!visible){
          globalKey.currentState.blurFocus();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

//获取热门搜索
  void hotSearch() async {
    var res = await SearchDao.hotSearchAjax();
    if (res.code == 0) {
      setState(() {
        hotSearchList = res.result;
      });
    }
  }

//设置搜索数据到input
  void setSearchVal(String val) {
    globalKey.currentState.setValItem(val);
  }

//  热门单个数据
  List<Widget> _hotWraps() {
    if (hotSearchList.length >= 10) {
      return hotSearchList.sublist(0, 10).map((item) {
        return MyWrap(
          text: item.k,
          onWrap: (val) {
            setSearchVal(val);
          },
        );

      }).toList();
    } else {
      return hotSearchList.map((item) {
        return MyWrap(
          text: item.k,
          onWrap: (val) {
            setSearchVal(val);
          },
        );
      }).toList();
    }
  }

//  获取历史单个数据
  List<Widget> _searchWraps(PlayProvider _player) {
    return _player.searchHistory.map((item) {
      return MyWrap(
        text: item,
        onWrap: (val) {
          setSearchVal(val);
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
   super.build(context);
   PlayProvider _player = Provider.of<PlayProvider>(context);
    return Stack(
      children: <Widget>[
        Positioned(
            left: 30,
            right: 30,
            top: 20,
            child: SearchBar(
                key: globalKey,
                hint: '搜索歌曲、歌手',
                speakClick: () {},
                onChanged: (val) {
                  setState(() {
                    query = val;
                  });
                  if (val.isNotEmpty) {
                    globalSuggest.currentState.search(val);
                  }
                },
                clearText: () {
                  setState(() {
                    query = '';
                  });
                })),
        Positioned(
            top: 80,
            bottom: 0,
            left: 30,
            right: 30,
            child: ListView(
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                Offstage(
                  offstage: hotSearchList.isEmpty || query.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: Text(
                            '热门搜索',
                            style:
                                TextStyle(fontSize: 14, color: MyColors.textI),
                          )),
                      Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: _hotWraps())
                    ],
                  ),
                ),
                Offstage(
                  offstage: _player.searchHistory.isEmpty || query.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '搜索历史',
                                style: TextStyle(
                                    fontSize: 14, color: MyColors.textI),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    _showOverlayAlert(_player);
                                  },
                                  child: Icon(
                                    IconData(0xe600, fontFamily: 'iconfont'),
                                    size: 18,
                                    color: MyColors.textI,
                                  ))
                            ],
                          )),
                      Wrap(
                          spacing: 8,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: _searchWraps(_player))
                    ],
                  ),
                ),
              ],
            )),
        Positioned(
            left: 30,
            right: 30,
            top: 78,
            bottom: 0,
            child: Offstage(
                offstage: query.isEmpty,
                child: Suggest(
                  key: globalSuggest,
                  showSinger: true,
                  beforeScroll: () {
                    globalKey.currentState.blurFocus();
                  },
                  onTap: (item) {
                    if (item.type == TYPE_SINGER) {
                      Navigator.pushNamed(context, '/singerDetail', arguments: {
                        "id": item.singermid,
                        "title": item.singername,
                        "bgImage":
                            "http://y.gtimg.cn/music/photo_new/T001R150x150M000${item.singermid}.webp"
                      });
                    } else {
                      DescDetailItem _item = DescDetailItem();
                      _item.id = item.id;
                      _item.mid = item.mid;
                      _item.singer = item.singer;
                      _item.name = item.name;
                      _item.album = item.album;
                      _item.duration = item.duration;
                      _item.image = item.image;
                      _item.url = item.url;
                      _player.insertSong(_item);
                      _player.overlay?.remove();
                      OverlayEntry _overlay = OverlayEntry(
                          builder: (context) => Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Player()));
                      Overlay.of(context).insert(_overlay);
                      _player.setOverlay(_overlay);
                      globalKey.currentState.clearText();
                    }
                  },
                )))
      ],
    );
  }
  //现实显示具体方法 在需要的地方掉用即可
  void _showOverlayAlert(_player) {
    _player.overlayAlert?.remove();
    OverlayEntry _overlay = OverlayEntry(
        builder: (context) => Positioned (
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child:AlertItem(
            title: '是否清空所有搜索历史',
              success: (){
                _player.clearSearchHistory();
                _player.overlayAlert?.remove();
                _player.overlayAlert = null;
              },
            )
        ));
    Overlay.of(context).insert(_overlay);
    _player.setOverlayAlert(_overlay);
  }
}
