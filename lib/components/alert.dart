import 'package:flutter/material.dart';
import 'package:music/components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';

class AlertItem extends StatelessWidget {
  final Function success;
  final String title;
  AlertItem({Key key, this.success,this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _player = Provider.of<PlayProvider>(context);
    return GestureDetector(
        onTap: () {
          _player.overlayAlert?.remove();
          _player.overlayAlert = null;
        },
        child: Container(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            child: GestureDetector(
                onTap: () {},
                child: Center(
                  child: Container(
                      width: 270,
                      height: 104,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff333333)),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: MyColors.bgColor))),
                            child: Text(
                              '$title',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: MyColors.textD,
                                  fontWeight: FontWeight.w200,
                                  decoration: TextDecoration.none),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Center(
                                      child: FlatButton(
                                        onPressed: () {
                                          _player.overlayAlert?.remove();
                                          _player.overlayAlert = null;
                                        },
                                        child: Text(
                                          '取消',
                                          style: TextStyle(
                                              color: MyColors.textD,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    color: MyColors.bgColor,
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: FlatButton(
                                        onPressed: success,
                                        child: Text(
                                          '确定',
                                          style: TextStyle(
                                              color: MyColors.textD,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ))));
  }
}
