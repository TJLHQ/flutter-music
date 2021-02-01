import 'package:flutter/material.dart';
import 'package:music/components/color.dart';
class MyWrap extends StatelessWidget {
  String text;
  final void Function(String) onWrap;
  MyWrap({Key key,this.text,this.onWrap}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onWrap(text);
      },
      child:  Container(
        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
//      alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xff333333),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          this.text,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style:
        TextStyle(
            decoration: TextDecoration.none,
            color: MyColors.textD
        ),),
      )
    );

  }
}