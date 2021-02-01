import 'package:flutter/material.dart';
import '../model/detail.dart';
import '../util/index.dart';
import '../util/cache.dart';

class PlayProvider with ChangeNotifier {
  DescDetailItem singer = DescDetailItem();
  bool playing = false;
  bool fullScreen = false;
  List<DescDetailItem> playList = [];
  List<DescDetailItem> sequenceList = [];
  int mode = PlayMode.sequence;
  int currentIndex = -1;
  DescDetailItem get currentSong => playList[currentIndex];
  OverlayEntry overlay;
  OverlayEntry overlayAlert;
  bool isShowAddSong=true;
  int lyricCurrentIndex=0;
  List<String> searchHistory =[];
  List<DescDetailItem> playHistory =[];
  List<DescDetailItem> favoriteList = [];

//    获取历史记录数据
  void getSearchHistory(){
    searchHistory=new Cache().loadSearch();
    notifyListeners();
  }
  //    获取收藏记录数据
  void getFavoriteList(){
    favoriteList = new Cache().loadFavorite();
    notifyListeners();
  }
  //    获取播放记录数据
  void getPlayHistory(){
    playHistory=new Cache().loadPlay();
    notifyListeners();
  }
//  设置歌词CurrentIndex
  void setLyricCurrentIndex(int val){
    lyricCurrentIndex=val;
    notifyListeners();
  }
//  设置overlay
  void setOverlay(OverlayEntry val) {
    overlay = val;
    notifyListeners();
  }
  //  设置overlayAlert
  void setOverlayAlert(OverlayEntry val) {
    overlayAlert = val;
    notifyListeners();
  }
//设置歌手信息
  void setSinger(DescDetailItem singer) {
    singer = singer;
    notifyListeners();
  }
//设置播放状态
  void setPlaying(bool flag) {
    playing = flag;
    notifyListeners();
  }
  void setIsShowAddSong(bool flag){
    isShowAddSong=flag;
  }
//设置页面隐藏显示状态
  void setFullScreen(bool flag) {
    fullScreen = flag;
    notifyListeners();
  }
//设置播放列表信息
  void setPlayList(List<DescDetailItem> list) {
    playList = list;
    notifyListeners();
  }
//设置歌曲列表信息
  void setSequenceList(List<DescDetailItem> list) {
    sequenceList = list;
    notifyListeners();
  }
//设置播放模式
  void setMode(int i) {
    mode = i;
    notifyListeners();
  }
//设置播放位置
  void setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }
//选择播放
  void selectPlay(List<DescDetailItem> list, int index) {
    sequenceList = list;
    if (mode == PlayMode.random) {
      List<DescDetailItem> _list = list.sublist(0);
      _list.shuffle();
      playList = _list;
      index = _list.indexWhere((item) => item.id == list[index].id);
    } else {
      playList = list;
    }
    currentIndex = index;
    fullScreen = true;
    notifyListeners();
  }
//随机播放
  void randomPlay(List<DescDetailItem> list) {
    mode = PlayMode.random;
    sequenceList = list;
    List<DescDetailItem> _list = list.sublist(0);
    _list.shuffle();
    playList = _list;
    currentIndex = 0;
    fullScreen = true;
    notifyListeners();
  }
//插入歌曲
  void insertSong(DescDetailItem song) {
    List<DescDetailItem> _playList = playList.sublist(0);
    List<DescDetailItem> _sequenceList = sequenceList.sublist(0);
    int _currentIndex = currentIndex;
    if (_playList.isEmpty || _sequenceList.isEmpty) {
      _sequenceList.add(song);
      _playList.add(song);
      _currentIndex = 0;
    } else {
      DescDetailItem _currentSong = _playList[currentIndex];
      int _fpIndex = _playList.indexWhere((item) => item.id == song.id);
      _currentIndex++;
      _playList.insert(_currentIndex, song);
      if (_fpIndex > -1) {
        if (_currentIndex > _fpIndex) {
          _playList.removeAt(_fpIndex);
          _currentIndex--;
        } else {
          _playList.removeAt(_fpIndex + 1);
        }
      }
      int _currentSIndex =
          _sequenceList.indexWhere((item) => item.id == _currentSong.id) + 1;
      int _fsIndex = _sequenceList.indexWhere((item) => item.id == song.id);
      _sequenceList.insert(_currentSIndex, song);
      if (_fsIndex > -1) {
        if (_currentSIndex > -_fsIndex) {
          _sequenceList.removeAt(_fsIndex);
        } else {
          _sequenceList.removeAt(_fsIndex + 1);
        }
      }
    }
    playList = _playList;
    sequenceList = _sequenceList;
    currentIndex = _currentIndex;
    fullScreen = true;
    notifyListeners();
  }
//  删除歌曲
  deleteSong(DescDetailItem song) {
  List<DescDetailItem> _playList = playList.sublist(0);
  List<DescDetailItem> _sequenceList = sequenceList.sublist(0);
  int _currentIndex = currentIndex;
  int _pIndex = _playList.indexWhere((item) => item.id == song.id);
  _playList.removeAt(_pIndex);
  int _sIndex = _sequenceList.indexWhere((item) => item.id == song.id);
  _sequenceList.removeAt(_sIndex);
  if (_currentIndex > _pIndex || _currentIndex == _playList.length) {
    _currentIndex--;
  }
  playList = _playList;
  sequenceList = _sequenceList;
  currentIndex = _currentIndex;
  if (_playList.isEmpty) {
    playing=false;
  }
  notifyListeners();
}
//清空播放列表
  void clearPlayList() {
    playing = false;
    fullScreen = false;
    playList = [];
    sequenceList = [];
    mode = PlayMode.sequence;
    currentIndex = -1;
    overlay = null;
    notifyListeners();
  }
//  添加收藏
  void saveFavoriteList(DescDetailItem song) {
     this.favoriteList=new Cache().saveFavorite(song);
     notifyListeners();
}
//删除收藏
void deleteFavoriteList(DescDetailItem song) {
  favoriteList=new Cache().deleteFavorite(song);
  notifyListeners();
}
//保存搜索记录
 saveSearchHistory(String query) {
  searchHistory=new Cache().saveSearch(query);
  notifyListeners();
}
//删除搜索记录
deleteSearchHistory (query) {
searchHistory=new Cache().deleteSearch(query);
notifyListeners();
}
//清空搜索记录
clearSearchHistory () {
searchHistory=new Cache().clearSearch();
notifyListeners();
}
//保存播放记录
  savePlayHistory(DescDetailItem song){
    playHistory=new Cache().savePlay(song);
    notifyListeners();
  }
}
