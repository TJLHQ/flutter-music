import 'package:flutter/material.dart';
import '../model/rank.dart';
import '../dao/rankDao.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:music/components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../components/loading.dart';
class Rank extends StatefulWidget {
  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> with AutomaticKeepAliveClientMixin {
  List<RankItem> rankList = [];
  bool isLoading=true;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    initLoad();
    super.initState();
  }

  void initLoad() async {
    var res = await RankDao.rankAjax();
    if (res.code == 0) {
      setState(() {
        rankList = res.result;
      });
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _player = Provider.of<PlayProvider>(context);
    return LoadingContainer(
        isLoading: isLoading,
        child:ListView(
          padding: EdgeInsets.only(bottom: 20),
          children: <Widget>[
            ...rankList.map((item) {
              return Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/rankDetail',arguments: {
                          "bgImage":item.picUrl,
                          "title":item.topTitle,
                          "id":item.id
                        });
                      },
                      child: Container(
                        height: 100,
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              child: CachedNetworkImage(
                                  imageUrl: item.picUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(backgroundColor: MyColors.textD,),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error)),
                            ),
                            Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  color: Color(0xff333333),
                                  child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: item.songList.asMap().keys.map((f) {
                                        return Container(
                                            alignment: Alignment.centerLeft,
                                            height: 26,
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  '${f + 1}、',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: MyColors.textD),
                                                ),
                                                Expanded(
                                                    child: Text(
                                                      '${item.songList[f].songname}',
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: MyColors.textD),
                                                    ))
                                              ],
                                            ));
                                      }).toList())),
                            )
                          ],
                        ),
                      )));
            }).toList(),
            Offstage(
                offstage:_player.playList.isEmpty ,
                child: SizedBox(
                  height: 60,
                )
            )
          ],

        )
    );
  }
}
