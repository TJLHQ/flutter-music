import 'package:flutter/material.dart';
import 'package:music/components/color.dart';
import '../model/detail.dart';

class LyricItemPage extends StatefulWidget {
  List<LyricItem> lyrics;
  int lineNum;

  LyricItemPage({Key key, this.lyrics, this.lineNum}) : super(key: key);

  @override
  LyricItemPageState createState() => LyricItemPageState();
}

class LyricItemPageState extends State<LyricItemPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController _lyricController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  bool get wantKeepAlive => true;


  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 32,
                padding: EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: Text(
                  widget.lyrics[index].txt,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                      fontSize: 14,
                      color: index == widget.lineNum
                          ? Color(0xffffffff)
                          : MyColors.textI),
                ));
          },
          itemCount: widget.lyrics.length,
          controller: _lyricController,
        ));
  }

//  设置播放进度
  void setControllerLyric(int index) {
    if (_lyricController.hasClients) {
      _lyricController?.animateTo((index - 5) * 32.toDouble(),
          duration: Duration(seconds: 1), curve: Curves.ease);
    }
  }
  //  设置播放进度
  void setControllerStop() {
    if (_lyricController.hasClients) {
      _lyricController?.jumpTo(0);
    }
  }
  void disposeController(){
    _lyricController.dispose();
  }
}
