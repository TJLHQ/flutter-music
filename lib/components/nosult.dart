import 'package:flutter/material.dart';
import '../components/color.dart';
class NoSult extends StatelessWidget {
  final String title;
  final Widget child;
  bool isNoSult;
  NoSult({Key key,this.title='暂无内容',this.child,this.isNoSult}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return isNoSult?Center(
        child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(IconData(0xe64b,fontFamily: 'iconfont'),size: 80,color: MyColors.textD,),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(title,style: TextStyle(
                    fontSize: 14,
                    color: MyColors.textD
                ),),
              )
            ],
          )


    ):child;
  }
}
