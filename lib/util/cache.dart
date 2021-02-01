import 'package:flustars/flustars.dart';
import '../model/detail.dart';

class Cache {
  final String SEARCH_KEY = '__search__';
  final int SEARCH_MAX_LEN = 10;

  final String PLAY_KEY = '__play__';
  final int PLAY_MAX_LEN = 200;

  final String FAVORITE_KEY = '__favorite__';
  final int FAVORITE_MAX_LEN = 200;

  Cache() {
    _initAsync();
  }

  _initAsync() async {
    await SpUtil.getInstance();
  }

//  新增字符串类型的query
  void insertStringArray(
      List<String> list, String val, Function compare, int maxLen) {
    int _index = list.indexWhere(compare);
    if (_index == 0) {
      return;
    }
    if (_index > 0) {
      list.removeAt(_index);
    }
    list.insert(0, val);
    if (maxLen != null && list.length > maxLen) {
      list.removeLast();
    }
  }

  //  新增Map类型的query
  void insertMapArray(List<DescDetailItem> arr, DescDetailItem val,
      Function compare, int maxLen) {
    int _index = arr.indexWhere(compare);
    if (_index == 0) {
      return;
    }
    if (_index > 0) {
      arr.removeAt(_index);
    }
    arr.insert(0, val);
    if (maxLen != null && arr.length > maxLen) {
      arr.removeLast();
    }
  }

//  删除
  void deleteFromArray(List<dynamic> arr, Function compare) {
    final int _index = arr.indexWhere(compare);
    if (_index > -1) {
      arr.removeAt(_index);
    }
  }

//  新增搜索历史
  List<String> saveSearch(String query) {
    List<String> _searches = loadSearch();
    insertStringArray(_searches, query, (item) {
      return item == query;
    }, SEARCH_MAX_LEN);
    SpUtil.putStringList(SEARCH_KEY, _searches);
    return _searches;
  }

//  删除搜索历史
  List<String> deleteSearch(query) {
    List<String> _searches = loadSearch();
    deleteFromArray(_searches, (item) {
      return item == query;
    });
    SpUtil.putStringList(SEARCH_KEY, _searches);
    return _searches;
  }

//  清空搜索历史
  List<String> clearSearch() {
    SpUtil.remove(SEARCH_KEY);
    return List<String>();
  }

//  显示搜索历史
  List<String> loadSearch() {
    List _list=SpUtil.getStringList(SEARCH_KEY,defValue: List<String>());
    return _list??List<String>();
  }

//  保存我的收藏
  List<DescDetailItem> saveFavorite(DescDetailItem song) {
    List<DescDetailItem> _songs =loadFavorite();
    insertMapArray(_songs, song, (item) {
      return song.id == item.id;
    }, FAVORITE_MAX_LEN);
    SpUtil.putObjectList(FAVORITE_KEY, _songs);
    return _songs;
  }

//  删除我的收藏
  List<DescDetailItem> deleteFavorite(DescDetailItem song) {
    List<DescDetailItem> _songs =loadFavorite();
    deleteFromArray(_songs, (item) {
      return item.id == song.id;
    });
    SpUtil.putObjectList(FAVORITE_KEY, _songs);
    return _songs;
  }

//  显示我的收藏
  List<DescDetailItem> loadFavorite() {
    List<Map> _item=SpUtil.getObjectList(FAVORITE_KEY)??List<Map>();
    List<DescDetailItem> _list=_item.map((item)=>DescDetailItem.fromJson(item)).toList();
    return _list?? List<DescDetailItem>();
  }

//  保存播放记录
  List<DescDetailItem> savePlay(DescDetailItem song) {
    List<DescDetailItem> _songs =loadPlay();
    insertMapArray(_songs, song, (item) {
      return song.id == item.id;
    }, PLAY_MAX_LEN);
    SpUtil.putObjectList(PLAY_KEY, _songs);
    return _songs;
  }

//显示播放记录
  List<DescDetailItem> loadPlay() {
    List<Map> _items=SpUtil.getObjectList(PLAY_KEY)??List<Map>() ;
    List<DescDetailItem> _list=_items.map((item)=>DescDetailItem.fromJson(item)).toList();
    return _list??List<DescDetailItem>();
  }
}
