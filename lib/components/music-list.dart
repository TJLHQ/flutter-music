import 'package:flutter/material.dart';
import 'package:music/components/song-item.dart';
import 'package:music/model/detail.dart';
import 'package:music/components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../pages/player.dart';
import '../components/loading.dart';
class MusicList extends StatefulWidget {
  List<DescDetailItem> musicList = [];
  final String bgImage;
  final String title;
  final bool rank;
  MusicList({Key key, this.musicList, this.bgImage, this.title,this.rank=false})
      : super(key: key);
  @override
  _MusicListState createState() => _MusicListState();
}

class _MusicListState extends State<MusicList> {
  double scale=0;
  double isShowBtn=1.0;
  @override
  Widget build(BuildContext context) {
    final _player=Provider.of<PlayProvider>(context);
    return WillPopScope(
      child:  Scaffold(
        body:
        Container(
            color: MyColors.bgColor,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Transform.scale(scale: 1+scale,child:  Container(
                    height: 262,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.bgImage
                            ),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(Color.fromRGBO(7, 17, 27, .4), BlendMode.dstATop)
                        )
                    ),
                  ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 25,
                  child: Container(
                    height: 42,
                    padding: EdgeInsets.only(right: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              alignment: Alignment.center,
                              child: Icon(
                                IconData(0xe607, fontFamily: 'iconfont'),
                                color: MyColors.textColor,
                                size: 22,
                              ),
                            )),
                        Expanded(
                            child: Container(
                                alignment: Alignment.center,
                                child: Text(widget.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color:MyColors.textE,
                                        decoration: TextDecoration.none))))
                      ],
                    ),
                  ),
                ),
            LoadingContainer(
                isLoading: widget.musicList.isEmpty,
                child: Positioned(
                    top: 70,
                    left: 0,
                    right: 0,
                    bottom: _player!=null&&_player.playList.isNotEmpty?60:0,
                    child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification notification){
                          var bc=notification.metrics.pixels??0;
                          if(bc>30){
                            setState(() {
                              isShowBtn=0.0;
                            });
                          }else{
                            setState(() {
                              isShowBtn=1.0;
                            });

                          }
                          if(bc<1){
                            setState(() {
                              scale=(bc/262).abs();
                            });
                          }
                          return true;
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.only(top: 200),
                          itemCount: widget.musicList.length,
                          itemBuilder: (BuildContext context,int index){
                            return SongItem(
                              rank: widget.rank,
                              listIndex:index,
                              detailItem:widget.musicList[index],
                              onTap: (val) {
                                _showOverlay(_player);
                                _player.selectPlay(widget.musicList, index);
                              },
                            );
                          },
                        )
                    )
                ),
            ),
                Positioned(
                    top: 200,
                    child: AnimatedOpacity(
                        opacity: isShowBtn??1,
                        duration: Duration(milliseconds: 200),
                        child: GestureDetector(
                            onTap: (){
                              _showOverlay(_player);
                              _player.randomPlay(widget.musicList);
                            },
                            child: Container(
                              width: 130,
                              alignment: Alignment.center,
                              height: 32,
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: MyColors.textColor),
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      IconData(0xe78d, fontFamily: 'iconfont'),
                                      color: MyColors.textColor,
                                      size: 15,
                                    ),
                                  ),
                                  Text(
                                    '随机播放全部',
                                    style: TextStyle(
                                        color: MyColors.textColor,
                                        fontSize: 12,
                                        decoration: TextDecoration.none,
                                        letterSpacing: 1),
                                  )
                                ],
                              ),

                            )
                        )
                    )
                ),
              ],
            )
        ),
      ),
      onWillPop: () async{
        if(_player!=null&&_player.playList.isNotEmpty&&_player.fullScreen){
          _player.setFullScreen(false);
          _player.setLyricCurrentIndex(0);
          return Future.value(false);
        }else if(_player.overlayAlert!=null){
          _player.overlayAlert?.remove();
          _player.overlayAlert=null;
          return Future.value(false);
        }else{
          return Future.value(true);
        }
      },
    );
  }
  //现实显示具体方法 在需要的地方掉用即可
  _showOverlay(_player) {
      _player.overlay?.remove();
      OverlayEntry _overlay = OverlayEntry(
          builder: (context) => Positioned (
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child:Player()
          ));
      Overlay.of(context).insert(_overlay);
      _player.setOverlay(_overlay);
  }
}