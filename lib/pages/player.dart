import 'dart:ui' as prefix0;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/components/color.dart';
import 'package:music/model/detail.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../util/index.dart';
import '../dao/singerDao.dart';
import '../model/detail.dart';
import '../util/lyric.dart';
import '../components/alert.dart';
class Player extends StatefulWidget {
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  AudioPlayer _audioPlayer;
  double _sliderValue = 0.0;
  bool isPlaySeek = true;
  String _lineTxt = '';
  int _lineNum = 0;
  List<LyricItem> _lyrics = [];
  LyricClass _lyricClass;
  ScrollController _lyricController =
      ScrollController(initialScrollOffset: 0.0);
  ScrollController _musicListScroll =
  ScrollController();
  bool _bottomSheet = false;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 8));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    PlayProvider _player = Provider.of<PlayProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      _setPlayAudio(_player.currentSong.mid);
      _audioPlayer
        ..onAudioPositionChanged.listen((p) async {
          if (isPlaySeek) {
            setState(() {
              _sliderValue = p.inSeconds.toDouble();
            });
          }
        })
        ..onPlayerStateChanged.listen((AudioPlayerState s) {
          if (s == AudioPlayerState.COMPLETED) {
            if (_player.mode == PlayMode.loop) {
              _loop(_player);
            } else if(_player.playList.length==1) {
              _playBefore(_player);
              _lyricClass.complete();
            }else{
              onNext(_player, _player.currentSong);
            }
          } else if (s == AudioPlayerState.PLAYING) {
            setState(() {
              _sliderValue = 0.0;
            });
            _player?.setPlaying(true);
            _controller?.forward();
            _player.savePlayHistory(_player.currentSong);
          }
        });
    });
  }

  @override
  void deactivate() async {
    await _audioPlayer.stop();
    await _audioPlayer.release();
    super.deactivate();
  }

  @override
  void dispose() async {
    _controller.dispose();
    _lyricController.dispose();
    _lyricClass.stop();
    _musicListScroll.dispose();
    super.dispose();
  }

//歌曲展开列表
  _getPlayList(BuildContext context,PlayProvider _player,DescDetailItem _currentSong) {
    if (!_bottomSheet) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          final _player = Provider.of<PlayProvider>(context);
          return Container(
              height: 800.0,
              color: MyColors.bgColor,
              padding: EdgeInsets.only(left: 20),
              child: Column(
                children: <Widget>[
                  _getPlayListHeader(_player),
                  Expanded(
                    child: ListView.builder(
                        itemCount: _player.sequenceList.length,
                        controller: _musicListScroll,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            height: 40,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: GestureDetector(
                                  child: Container(
                                      color: Colors.transparent,
                                      child: Text(
                                          _player.sequenceList[index].name,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: _player.currentSong.id ==
                                                     _player
                                                          .sequenceList[index]
                                                          .id
                                                  ? MyColors.textE
                                                  : MyColors.textD))),
                                  onTap: () {
                                    _changListSong(
                                        _player, _player.sequenceList[index]);
                                  },
                                )),
                                GestureDetector(
                                    onTap: () {
                                      _setFavoriteClick(
                                          _player, _player.sequenceList[index]);
                                    },
                                    child: Container(
                                        width: 40,
                                        height: 40,
                                        alignment: Alignment.center,
                                        color:Colors.transparent,
                                        child: _getCheckChange(_player,
                                                _player.sequenceList[index])
                                            ? Icon(
                                                IconData(0xe601,
                                                    fontFamily: 'iconfont'),
                                                color: MyColors.red,
                                                size: 15,
                                              )
                                            : Icon(
                                                IconData(0xe604,
                                                    fontFamily: 'iconfont'),
                                                color: MyColors.textColor,
                                                size: 15,
                                              ))),
                                GestureDetector(
                                  onTap: () {
                                    if(_player.sequenceList[index].id==_player.currentSong.id){
                                      _playBefore(_player);
                                      _player.deleteSong(_player.sequenceList[index]);
                                      _setPlayAudio(_player.currentSong.mid,_player);
                                    }else{
                                      _player.deleteSong(_player.sequenceList[index]);
                                    }

                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 50,
                                    height: 40,
                                    color:Colors.transparent,
                                    child: Icon(
                                      IconData(0xe600, fontFamily: 'iconfont'),
                                      color: MyColors.textColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Offstage(
                    offstage: !_player.isShowAddSong,
                    child: GestureDetector(
                      child: Container(
                        width: 140,
                        height: 30,
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.center,
                        child: Text(
                          '添加歌曲到队列',
                          style: TextStyle(fontSize: 12, color: MyColors.textD),
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.5, color: MyColors.textD),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/addSong');
                        _player.setIsShowAddSong(false);
                      },
                    )
                  ),
                  SizedBox(
                    height: 70,
                  )
                ],
              ));
        },
      ).then((val) {
        _bottomSheet = false;
      });
      _bottomSheet = true;
      int _index=_player.sequenceList.indexWhere((item)=>item.id==_currentSong.id);
      Future.delayed(Duration(milliseconds: 20),(){
        _musicListScroll.jumpTo(_index*40.toDouble());
      });
    } else {
      Navigator.of(context).pop();
      _bottomSheet = false;
    }
  }

//歌曲展开列表头部
  Widget _getPlayListHeader(PlayProvider _player) {
    return Container(
      height: 30,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            child: _setIconVal(_player, 20),
            onTap: () {
              _randowm(_player);
            },
          ),
          Expanded(child: _getModText(_player)),
          GestureDetector(
              onTap: () {
                _showOverlayAlert(_player);
              },
              child: Container(
                width: 50,
                height: 30,
                alignment: Alignment.center,
                child: Icon(
                  IconData(0xe600, fontFamily: 'iconfont'),
                  color: MyColors.textColor,
                  size: 20,
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _player = Provider.of<PlayProvider>(context);
    final _currentSong = _player.currentSong;
    return _player.playList.length > 0
        ? _player.fullScreen
            ? Scaffold(
                body: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Image.network(
                      _currentSong.image,
                      fit: BoxFit.cover,
                      color: MyColors.bgColor,
                      colorBlendMode: BlendMode.color,
                    ),
                  ),
                  Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: BackdropFilter(
                          filter:
                              prefix0.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child:
                              Container(color: Color.fromRGBO(0, 0, 0, 0.6)))),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 40,
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.only(right: 50),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                _player.setFullScreen(false);
                                _player.setLyricCurrentIndex(0);
                                _pageController.jumpToPage(0);
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.topCenter,
                                child: Icon(
                                  IconData(0xe78e, fontFamily: 'iconfont'),
                                  color: MyColors.textColor,
                                  size: 22,
                                ),
                              )),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(_currentSong.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.8),
                                              decoration: TextDecoration.none)),
                                      Text(_currentSong.singer,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.8),
                                              decoration: TextDecoration.none))
                                    ],
                                  )))
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 120,
                      left: 0,
                      right: 0,
                      bottom: 180,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _pageController,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: <Widget>[
                                RotationTransition(
                                    alignment: Alignment.center,
                                    turns: _animation,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Align(
                                          child: Container(
                                            width: 300,
                                            height: 300,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(200),
                                              border: Border.all(
                                                  width: 10,
                                                  color:
                                                  MyColors.borderColor),
                                            ),
                                          ),
                                        ),
                                        Align(
                                          child: Container(
                                            width: 280,
                                            height: 280,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    200),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      _currentSong.image),
                                                  fit: BoxFit.cover,
                                                )),
                                          ),
                                        ),
                                      ],
                                    )),
                                Container(
                                  height: 20,
                                  margin: EdgeInsets.only(top: 30),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _lineTxt,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14, color: MyColors.textI),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Container(
                                      height: 32,
                                      padding: EdgeInsets.only(
                                          left: 20, right: 20),
                                      alignment: Alignment.center,
                                      child: Text(
                                        _lyrics[index].txt,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: index == _lineNum
                                                ? Color(0xffffffff)
                                                : MyColors.textI),
                                      ));
                                },
                                itemCount: _lyrics.length,
                                controller: _lyricController,
                              ))
                        ],
                        onPageChanged: (int index) {
                          _player.setLyricCurrentIndex(index);
                          if (index == 1) {
                            if (_lineNum > 5) {
                              if (_lyricController.hasClients) {
                                _lyricController
                                    ?.jumpTo((_lineNum - 5) * 32.toDouble());
                              }
                            }
                          }
                        },
                      ),
                  ),
                  Positioned(
                      left: 20,
                      right: 20,
                      bottom: 100,
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 8,
                            margin: EdgeInsets.only(bottom: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: _player.lyricCurrentIndex==0 ? 20 : 8,
                                  height: 8,
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: MyColors.textI),
                                ),
                                Container(
                                  width: _player.lyricCurrentIndex==1 ? 20 : 8,
                                  height: 8,
                                  margin: EdgeInsets.only(left: 4, right: 4),
                                  decoration: BoxDecoration(
                                      color: MyColors.textE,
                                      borderRadius: BorderRadius.circular(5)),
                                )
                              ],
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(right: 3),
                                child: Text(
                                  _dateTime(_sliderValue.floor()),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    height: 20,
                                    child: Slider(
                                      value: _sliderValue,
                                      onChanged: (data) {
                                        setState(() {
                                          _sliderValue =
                                              data.floor().toDouble();
                                        });
                                      },
                                      onChangeStart: (data) {
                                        setState(() {
                                          isPlaySeek = false;
                                        });
                                        _lyricClass.togglePlay();
                                      },
                                      onChangeEnd: (data) {
                                        _audioPlayer.seek(
                                            Duration(seconds: data.floor()));
                                        _lyricClass.seek((data * 1000).toInt());
                                        setState(() {
                                          isPlaySeek = true;
                                        });
                                      },
                                      min: 0.0,
                                      max: _sliderValue >
                                              _currentSong.duration.toDouble()
                                          ? _sliderValue
                                          : _currentSong.duration.toDouble(),
                                      label: '$_sliderValue',
                                      activeColor: MyColors.textColor,
                                      inactiveColor: MyColors.textD,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Text(
                                  _dateTime(_currentSong.duration),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                  Positioned(
                    bottom: 40,
                    left: 40,
                    right: 40,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                              onTap: () {
                                _randowm(_player);
                              },
                              child: _setIconVal(_player)),
                          GestureDetector(
                            onTap: () {
                              if (_player.playList.length == 1) return;
                              _playBefore(_player);
                              int _currentIndex = _player.currentIndex;
                              if (_player.mode == PlayMode.random) {
                                _currentIndex = _player.playList.indexWhere(
                                    (item) => item.id == _currentSong.id);
                              }
                              if (_player.playList.length > 1) {
                                --_currentIndex;
                              }

                              if (_currentIndex < 0) {
                                _currentIndex = _player.playList.length - 1;
                              }
                              _player.setCurrentIndex(_currentIndex);
                              _setPlayAudio(
                                  _player.playList[_currentIndex].mid, _player);
                            },
                            child: Icon(
                              IconData(0xe620, fontFamily: 'iconfont'),
                              color: MyColors.textColor,
                              size: 30,
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              bool _playing = !_player.playing;
                              _setPlayingAudio(_player, _playing);
                            },
                            child: Icon(
                              IconData(
                                  _player.playing == true ? 0xe605 : 0xe78d,
                                  fontFamily: 'iconfont'),
                              color: MyColors.textColor,
                              size: 40,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                onNext(_player, _currentSong);
                              },
                              child: Icon(
                                IconData(0xe663, fontFamily: 'iconfont'),
                                color: MyColors.textColor,
                                size: 30,
                              )),
                          GestureDetector(
                              onTap: () {
                                _setFavoriteClick(_player, _currentSong);
                              },
                              child: _getCheckChange(_player, _currentSong)
                                  ? Icon(
                                      IconData(0xe601, fontFamily: 'iconfont'),
                                      color: MyColors.textColor,
                                      size: 30,
                                    )
                                  : Icon(
                                      IconData(0xe604, fontFamily: 'iconfont'),
                                      color: MyColors.textColor,
                                      size: 30,
                                    )),
                        ],
                      ),
                    ),
                  )
                ],
              ))
            : Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 60,
                      alignment: Alignment.centerLeft,
                      color: Color(0xff333333),
                      padding: EdgeInsets.only(left: 20, top: 5, bottom: 5),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: GestureDetector(
                            child: Row(
                              children: <Widget>[
                                RotationTransition(
                                    alignment: Alignment.center,
                                    turns: _animation,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(_currentSong.image),
                                      radius: 20,
                                    )),
                                Expanded(
                                    child: Container(
                                  color: Colors.transparent,
                                  padding: EdgeInsets.only(left: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _currentSong.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w100,
                                            color: Color(0xffffffff),
                                            decoration: TextDecoration.none),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: Text(
                                            _currentSong.singer,
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: MyColors.textI,
                                                fontWeight: FontWeight.w100,
                                                decoration:
                                                    TextDecoration.none),
                                          ))
                                    ],
                                  ),
                                )),
                                Container(
                                  width: 32,
                                  height: 32,
//                  color: Colors.yellow,
                                  margin: EdgeInsets.only(left: 10),
                                  child: GestureDetector(
                                      onTap: () async {
                                        bool _playing = !_player.playing;
                                        _setPlayingAudio(_player, _playing);
                                      },
                                      child: Stack(
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              IconData(
                                                  _player.playing == true
                                                      ? 0xe664
                                                      : 0xe789,
                                                  fontFamily: 'iconfont'),
                                              color: MyColors.textColor,
                                              size: 15,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator(
                                              value: _sliderValue /
                                                  _currentSong.duration,
                                              strokeWidth: 3,
                                              backgroundColor:
                                                  Color(0xff987f32),
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                          Color>(
                                                      MyColors.textColor),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ],
                            ),
                            onTap: () {
                              if (_bottomSheet) {
                                Navigator.of(context).pop();
                                _bottomSheet = false;
                                return;
                              }
                              _player.setFullScreen(true);
                            },
                          )),
                          GestureDetector(
                            child: Container(
                              width: 70,
                              height: 60,
                              color: Colors.transparent,
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Icon(
                                IconData(0xe603, fontFamily: 'iconfont'),
                                color: Color(0xff987f32),
                                size: 40,
                              ),
                            ),
                            onTap: () {
                              _getPlayList(context,_player,_currentSong);
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
        : null;
  }

//  模式图标设置
  Icon _setIconVal(PlayProvider _player, [double _size = 30]) {
    if (_player.mode == PlayMode.sequence) {
      return Icon(
        IconData(0xe662, fontFamily: 'iconfont'),
        color: MyColors.textColor,
        size: _size,
      );
    } else if (_player.mode == PlayMode.loop) {
      return Icon(
        IconData(0xe643, fontFamily: 'iconfont'),
        color: MyColors.textColor,
        size: _size,
      );
    } else if (_player.mode == PlayMode.random) {
      return Icon(
        IconData(0xe69a, fontFamily: 'iconfont'),
        color: MyColors.textColor,
        size: _size,
      );
    }
  }

//  模式文字设置
  Widget _getModText(PlayProvider _player) {
    String _text = '';
    if (_player.mode == PlayMode.sequence) {
      _text = '顺序播放';
    } else if (_player.mode == PlayMode.loop) {
      _text = '循环播放';
    } else if (_player.mode == PlayMode.random) {
      _text = '随机播放';
    }
    return Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          _text,
          style: TextStyle(fontSize: 14, color: MyColors.textD),
        ));
  }

//播放暂停
  void _setPlayingAudio(_player, bool _playing) async {
    if (_playing == true) {
      _controller.forward();
      await _audioPlayer.resume();
    } else {
      _controller.stop();
      await _audioPlayer.pause();
    }
    _player.setPlaying(_playing);
    _lyricClass.togglePlay();
  }

//设置播放
  void _setPlayAudio(String mid, [_player]) async {
    SongUrl res = await SingerDao.songUrlAjax(mid);
    if (res.code == 0) {
      int result = await _audioPlayer.play(res.result);
      if (result != 1) {
        print('onPlaying..err');
      }
    }
    var data = await SingerDao.songLyric(mid);
    if (data.code == 0) {
      setState(() {
        _lyrics = data.result;
      });
      _lyricClass = new LyricClass(
          lines: data.result,
          hanlder: (item) {
            int _num = item['lineNum'];
            if (_num > 5 && data.result.length - _num > 6) {
              if (_lyricController.hasClients) {
                _lyricController?.animateTo((_num - 5) * 32.toDouble(),
                    duration: Duration(seconds: 1), curve: Curves.ease);
              }
            }
            setState(() {
              _lineTxt = item['txt'];
              _lineNum = _num;
            });
          });
      _lyricClass.play();
    }
  }

//播放前
  void _playBefore(_player) async {
    _player.setPlaying(false);
    _controller?.stop();
    _lyricClass?.stop();
    await _audioPlayer.stop();
    if (_lyricController.hasClients) {
      _lyricController?.jumpTo(0);
    }
  }

//下一首
  void onNext(_player, _currentSong) {
    if (_player.playList.length == 1) return;
    _playBefore(_player);
    int _currentIndex = _player.currentIndex;
    if (_player.mode == PlayMode.random) {
      _currentIndex =
          _player.playList.indexWhere((item) => item.id == _currentSong.id);
    }
    if (_player.playList.length > 1) {
      ++_currentIndex;
    }

    if (_currentIndex >= _player.playList.length) {
      _currentIndex = 0;
    }
    _player.setCurrentIndex(_currentIndex);
    _setPlayAudio(_player.playList[_currentIndex].mid, _player);
  }

//  列表选中歌曲
  void _changListSong(PlayProvider _player, DescDetailItem _song) {
    _playBefore(_player);
    int _currentIndex =
        _player.playList.indexWhere((item) => item.id == _song.id);
    _player.setCurrentIndex(_currentIndex);
    _setPlayAudio(_player.playList[_currentIndex].mid, _player);
  }

//  循环播放
  void _loop(_player) {
    _audioPlayer.seek(Duration(seconds: 0));
    _setPlayAudio(_player.currentSong.mid, _player);
  }

//  分秒处理
  String _dateTime(int time) {
    int m = (time / 60).floor();
    dynamic mm = m > 9 ? m : '0$m';
    int s = time % 60;
    dynamic ss = s > 9 ? s : '0$s';
    return '$mm:$ss';
  }

//  判断favorite是否收藏;
  bool _getCheckChange(PlayProvider _player, DescDetailItem _currentSong) {
    List<DescDetailItem> _list = _player.favoriteList;
    int _num = _list.indexWhere((item) => item.id == _currentSong.id);
    bool _bool = _num > -1 ? true : false;
    return _bool;
  }

  void _setFavoriteClick(PlayProvider _player, DescDetailItem _currentSong) {
    if (_getCheckChange(_player, _currentSong)) {
      _player.deleteFavoriteList(_currentSong);
    } else {
      _player.saveFavoriteList(_currentSong);
    }
  }

//随机播放
  void _randowm(PlayProvider _player) {
    DescDetailItem _currentSong = _player.currentSong;
    int _index = (_player.mode + 1) % 3;
    _player.setMode(_index);
    List<DescDetailItem> _list = _player.sequenceList.sublist(0);
    if (_index == PlayMode.random) {
      _list.shuffle();
    }
    int _num = _list.indexWhere((item) => item.id == _currentSong.id);
    _player.setPlayList(_list);
    _player.setCurrentIndex(_num);
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
              title: '是否清空所有播放列表',
              success: (){
                _player.overlayAlert?.remove();
                _player.overlayAlert = null;

                _player.overlay?.remove();
                _player.clearPlayList();
               Navigator.of(context).pop();
              },
            )
        ));
    Overlay.of(context).insert(_overlay);
    _player.setOverlayAlert(_overlay);
  }
}
