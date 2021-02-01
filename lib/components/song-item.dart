import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/components/color.dart';
import '../model/detail.dart';

class SongItem extends StatelessWidget {
  final bool rank;
  final DescDetailItem detailItem;
  final Function(DescDetailItem) onTap;
  final int listIndex;

  SongItem(
      {Key key, this.rank = false, this.detailItem, this.onTap, this.listIndex})
      : super(key: key);

  Widget isShowIcon() {
    if (rank) {
      if (listIndex == 0) {
        return Container(
            height: 26,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 30),
            child: Image.asset(
              'images/first@3x.png',
              width: 25,
              height: 26,
              fit: BoxFit.cover,
            ));
      } else if (listIndex == 1) {
        return Container(
            height: 26,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 30),
            child: Image.asset(
              'images/second@3x.png',
              width: 25,
              height: 26,
              fit: BoxFit.cover,
            ));
      } else if (listIndex == 2) {
        return Container(
            height: 26,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 30),
            child: Image.asset(
              'images/third@3x.png',
              width: 25,
              height: 26,
              fit: BoxFit.cover,
            ));
      } else {
        return Container(
            height: 26,
            padding: EdgeInsets.only(left: 10),
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 30),
            child: Text(
              '${listIndex + 1}',
              style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.none,
                  color: MyColors.textColor),
            ));
      }
    }else{
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onTap(detailItem);
        },
        child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            height: 64,
            color: MyColors.bgColor,
            child: Row(
              children: <Widget>[
                isShowIcon(),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      detailItem.name.length > 5
                          ? detailItem.name.substring(0, 5)
                          : detailItem.name,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          decoration: TextDecoration.none),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          '${detailItem.singer}·${detailItem.album}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14,
                              color: MyColors.textD,
                              decoration: TextDecoration.none),
                        ))
                  ],
                ))
              ],
            )));
  }
}
