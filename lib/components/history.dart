import 'package:flutter/material.dart';
import '../model/detail.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../components/song-item.dart';
import '../pages/player.dart';
import '../components/nosult.dart';
class HistoryItem extends StatefulWidget {
  final List<DescDetailItem> listItem;
  final bool isAdd;
  final Function addSongTap;
  HistoryItem({Key key, this.listItem,this.isAdd=false,this.addSongTap}) : super();

  @override
  HistoryItemState createState() => HistoryItemState();
}

class HistoryItemState extends State<HistoryItem> {
  @override
  Widget build(BuildContext context) {
    final _player = Provider.of<PlayProvider>(context);
    return  NoSult(
      isNoSult: widget.listItem.isEmpty,
      child: ListView.builder(
        itemCount: widget.listItem.length,
        itemBuilder: (BuildContext context, int index) {
          return SongItem(
            listIndex: index,
            detailItem: widget.listItem[index],
            onTap: (val) {
              if(widget.isAdd){
                widget.addSongTap(widget.listItem[index]);
              }else{
                _showOverlay(_player);
                _player.selectPlay(widget.listItem, index);
              }
            },
          );
        },
      )
    );


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
