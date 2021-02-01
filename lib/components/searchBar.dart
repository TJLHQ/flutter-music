import 'package:flutter/material.dart';
import 'dart:async';

class SearchBar extends StatefulWidget {
  final bool autofocus;
  final String hint; //默认提示文案
  final void Function() speakClick;
  final ValueChanged<String> onChanged;
  final Function clearText;
  final bool isAdd;
  const SearchBar({
    Key key,
    this.autofocus = false,
    this.hint,
    this.speakClick,
    this.onChanged,
    this.clearText,
    this.isAdd=false
  }) : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  bool showClear = false;
  Timer _timer;
  TextEditingController _controller;
  FocusNode _contentFocusNode = FocusNode();
  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }
@override
  void dispose(){
  _controller?.dispose();
  _timer?.cancel();
    super.dispose();
}
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: Color(0xff333333), borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.search, size: 20, color: Colors.grey),
          Expanded(
              flex: 1,
              child: Container(
               alignment: Alignment.center,
                child: TextField(
                  controller: _controller,
                  focusNode: _contentFocusNode,
                  onChanged: _onChanged,
                  autofocus: widget.autofocus,
                  style: TextStyle(
                      textBaseline: TextBaseline.alphabetic,
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300),
                  decoration: InputDecoration(
                     contentPadding:!widget.isAdd?EdgeInsets.fromLTRB(5,0,5,10):EdgeInsets.fromLTRB(5,0,5,13),
                      border: InputBorder.none,
                      hintText: widget.hint ?? '',
                      hintStyle:
                      TextStyle(fontSize: 15, color: Color(0xff999999))),
                )),
              ),

          !showClear
              ? _wrapTap(Icon(Icons.mic, size: 22, color: Colors.grey), () {
                  setValItem('haha');
                  widget.speakClick();
                })
              : _wrapTap(
                  Icon(
                    Icons.clear,
                    size: 22,
                    color: Colors.grey,
                  ), () {
                  clearText();
                })
        ],
      ),
    );
  }

  Widget _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) callback();
      },
      child: child,
    );
  }

  //输入框内容改变
  void _onChanged(String text) {
    _timer?.cancel();
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
      setState(() {
        _timer = Timer(Duration(seconds: 1), () {
          widget.onChanged(text);
        });
      });
  }
  void clearText(){
    setState(() {
      showClear = false;
      _controller.clear();
    });
    widget.clearText();
    blurFocus();
  }
  void blurFocus(){
    _contentFocusNode.unfocus();
  }
  void setValItem(String text) {
    _controller.text = text;
    widget.onChanged(text);
    setState(() {
      showClear = true;
    });
  }
}
