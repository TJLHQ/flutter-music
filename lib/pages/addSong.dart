import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/model/detail.dart';
import '../components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../pages/player.dart';
import '../components/history.dart';
import 'package:music/components/searchBar.dart';
import '../components/suggest.dart';
import '../components/searList.dart';

GlobalKey<SearchBarState> globalAddKey = GlobalKey();
GlobalKey<SuggestState> globalAddSuggest = GlobalKey();

class AddSong extends StatefulWidget {
  @override
  _AddSongState createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  int _currentIndex = 0;
  String query = '';
  final String TYPE_SINGER = 'type_singer';
  PageController _pageController = PageController();
  @override
  void initState(){
    super.initState();
    final _player = Provider.of<PlayProvider>(context,listen: false);
    Future.delayed(Duration(milliseconds: 20),(){
      _player.getPlayHistory();
      _player.getSearchHistory();
    });
  }
  @override
  void deactivate() {
    super.deactivate();
    Provider.of<PlayProvider>(context).setIsShowAddSong(true);
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _player = Provider.of<PlayProvider>(context);
    return WillPopScope(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              left: 0,
              top: 40,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(right: 20),
//                color: Colors.red,
                height: 30,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 30,
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        child: Icon(
                          IconData(0xe607, fontFamily: 'iconfont'),
                          color: MyColors.textColor,
                          size: 22,
                        ),
                      ),
                    ),
                    Expanded(
                        child: SearchBar(
                            key: globalAddKey,
                            isAdd: true,
                            hint: '搜索歌曲、歌手',
                            speakClick: () {},
                            onChanged: (val) {
                              setState(() {
                                query = val;
                              });
                              if (val.isNotEmpty) {
                                globalAddSuggest.currentState.search(val);
                              }
                            },
                            clearText: () {
                              setState(() {
                                query = '';
                              });
                            }))
                  ],
                ),
              ),
            ),
            Positioned(
                top: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _activeNav(0),
                    _activeNav(1),
                  ],
                )),
            Positioned(
                left: 0,
                right: 0,
                top: 160,
                bottom: _player.playList.isEmpty ? 0 : 60,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  children: <Widget>[
                    HistoryItem(
                      listItem: _player.playHistory,
                      isAdd: true,
                      addSongTap: (DescDetailItem val) {
                        _player.insertSong(val);
                        _showOverlay(_player);
                      },
                    ),
                    SearchListItem(
                      listItem: _player.searchHistory,
                      onTap: (val) {
                        setSearchVal(val);
                      },
                    ),
                  ],
                )),
            Positioned(
                left: 20,
                right: 20,
                top: 90,
                bottom: 0,
                child: Offstage(
                    offstage: query.isEmpty,
                    child: Suggest(
                      key: globalAddSuggest,
                      showSinger: true,
                      beforeScroll: () {
                        globalAddKey.currentState.blurFocus();
                      },
                      onTap: (item) {
                        if (item.type == TYPE_SINGER) {
                          Navigator.pushNamed(context, '/singerDetail',
                              arguments: {
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
                        }
                      },
                    )))
          ],
        ),
      ),
      onWillPop: () async {
        if (_player.playList.isNotEmpty && _player.fullScreen) {
          _player.setFullScreen(false);
          _player.setLyricCurrentIndex(0);
          return Future.value(false);
        } else if(_player.overlayAlert!=null){
          _player.overlayAlert?.remove();
          _player.overlayAlert=null;
          return Future.value(false);
        }
        else {
          return Future.value(true);
        }
      },
    );
  }

  Widget _activeNav(int _num) {
    bool _active = _currentIndex == _num;
    return GestureDetector(
        onTap: () {
          setState(() {
            _currentIndex = _num;
          });
          _pageController.animateToPage(_num,
              duration: Duration(milliseconds: 400), curve: Curves.ease);
        },
        child: Container(
          width: 120,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _active ? Color(0xff333333) : Colors.transparent,
              border: Border.all(width: 1, color: Color(0xff333333)),
              borderRadius: _num == 0
                  ? (BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20)))
                  : (BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20)))),
          child: Text(
            _num == 0 ? '最近播放' : '搜索历史',
            style: TextStyle(
                fontSize: 14,
                color: _active ? Color(0xffffffff) : MyColors.textD),
          ),
        ));
  }

  //现实显示具体方法 在需要的地方掉用即可
  _showOverlay(_player) {
    _player.overlay?.remove();
    OverlayEntry _overlay = OverlayEntry(
        builder: (context) =>
            Positioned(top: 0, left: 0, right: 0, bottom: 0, child: Player()));
    Overlay.of(context).insert(_overlay);
    _player.setOverlay(_overlay);
  }

  //设置搜索数据到input
  void setSearchVal(String val) {
    globalAddKey.currentState.setValItem(val);
  }
}
