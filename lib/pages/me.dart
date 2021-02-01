import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/model/detail.dart';
import '../components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../pages/player.dart';
import '../components/history.dart';
import '../util/cache.dart';

class Me extends StatefulWidget {
  @override
  _MeState createState() => _MeState();
}

class _MeState extends State<Me> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  @override
  void initState(){
    new Cache();
    PlayProvider _player= Provider.of<PlayProvider>(context,listen: false);
    Future.delayed(Duration(milliseconds: 20),(){
      _player.getPlayHistory();
      _player.getFavoriteList();
    });
    super.initState();

  }
  @override
  void dispose(){
    super.dispose();
    _pageController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    PlayProvider _player = Provider.of<PlayProvider>(context);
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
                padding: EdgeInsets.only(right: 50),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 50,
                        height: 30,
                        alignment: Alignment.topCenter,
                        child: Icon(
                          IconData(0xe607, fontFamily: 'iconfont'),
                          color: MyColors.textColor,
                          size: 22,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _activeNav(0),
                          _activeNav(1),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 110,
                child: GestureDetector(
                  onTap: () {
                    List<DescDetailItem> _list =
                    _currentIndex == 0 ? _player.favoriteList : _player.playHistory;
                    _showOverlay(_player);
                    _player.randomPlay(_list);
                  },
                  child: Container(
                    width: 135,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: MyColors.textD),
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            IconData(0xe78d, fontFamily: 'iconfont'),
                            color: MyColors.textI,
                            size: 15,
                          ),
                        ),
                        Text(
                          '随机播放全部',
                          style: TextStyle(
                              color: MyColors.textI,
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              letterSpacing: 1),
                        )
                      ],
                    ),
                  ),
                )),
            Positioned(
                left: 0,
                right: 0,
                top: 160,
                bottom: _player.playList.isEmpty ? 0 : 60,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (int index){
                    setState(() {
                      _currentIndex=index;
                    });
                  },
                  children: <Widget>[
                    HistoryItem(
                        listItem: _player.favoriteList
                    ),
                    HistoryItem(
                        listItem: _player.playHistory
                    ),
                  ],
                )),
          ],
        ),
      ),
      onWillPop: () async{
        if(_player.playList.isNotEmpty&&_player.fullScreen){
          _player.setFullScreen(false);
          _player.setLyricCurrentIndex(0);
          return Future.value(false);
        }else if(_player.overlayAlert!=null){
          _player.overlayAlert?.remove();
          _player.overlayAlert=null;
          return Future.value(false);
        }
        else{
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
          _pageController.animateToPage(_num,duration: Duration(milliseconds: 400),curve: Curves.ease);
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
            _num == 0 ? '我的收藏' : '最近播放',
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
}
