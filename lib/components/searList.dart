import 'package:flutter/material.dart';
import 'package:music/components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../components/nosult.dart';

class SearchListItem extends StatefulWidget {
  List<String> listItem;
  final Function onTap;
  SearchListItem({Key key, this.listItem,this.onTap}) : super();

  @override
  HistoryItemState createState() => HistoryItemState();
}

class HistoryItemState extends State<SearchListItem> {
  @override
  Widget build(BuildContext context) {
    final _player = Provider.of<PlayProvider>(context);
    return NoSult(
        isNoSult: widget.listItem.isEmpty,
        title: '暂无搜索记录',
        child: Container(
            child: ListView.builder(
              itemCount: widget.listItem.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                      height: 40,
                      padding: EdgeInsets.only(left: 20,right: 10),
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(widget.listItem[index],style: TextStyle(
                              fontSize: 14,
                              color: MyColors.textE
                          ),),
                          GestureDetector(
                            child:  Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              child: Icon(
                                IconData(0xe600, fontFamily: 'iconfont'),
                                color: MyColors.textE,
                                size: 15,
                              ),
                            ),
                            onTap: (){
                              _player.deleteSearchHistory(widget.listItem[index]);
                            },
                          )


                        ],
                      )

                  ),
                  onTap: (){
                    widget.onTap(widget.listItem[index]);
                  },
                );

              },
            )
        )
    );
  }
}
