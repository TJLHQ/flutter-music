import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/banner.dart';
import '../model/desc.dart';
import '../dao/recomment.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:music/components/color.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
import '../components/loading.dart';
class Recomment extends StatefulWidget {
  @override
  _RecommentState createState() => _RecommentState();
}

class _RecommentState extends State<Recomment> with AutomaticKeepAliveClientMixin
     {
  List<BannerItem> bannerList = [];
  List<DescItem> descList = [];
  bool isLoading=true;
  @override
  void initState() {
    bannerResult();
    descResult();
    super.initState();
  }
  @override
  void dispose(){
    super.dispose();
  }
@override
bool get wantKeepAlive=>true;
  void bannerResult() async {
    var res = await RecommentDao.bannerAjax();
    if (res.code == 0) {
      setState(() {
        bannerList = res.result;
      });
    }
    setState(() {
      isLoading=false;
    });
  }

  void descResult() async {
    var res = await RecommentDao.descAjax();
    if (res.code == 0) {
      setState(() {
        descList = res.result;
      });
    }
  }

  List<Widget> descListItem() {
    var list = descList.map((item) {
      return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/recommentDetail', arguments: {
              "dissid": item.dissid,
              "title": item.dissname,
              "bgImage": item.imgurl
            });
          },
          child: Container(
            color: Colors.transparent,
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: CachedNetworkImage(
                          imageUrl: item.imgurl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                                backgroundColor: MyColors.textD,
                              ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error)
                      )
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.name,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            item.dissname,
                            style:
                                TextStyle(fontSize: 14, color: MyColors.textD),
                          ))
                    ],
                  ))
                ],
              )));
    });
    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _player = Provider.of<PlayProvider>(context);
    return
      LoadingContainer(
      isLoading: isLoading,
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 6),
            height: 150,
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return CachedNetworkImage(
                    imageUrl: bannerList[index].picUrl,
                    fit: BoxFit.fill
                );
              },
              itemCount: bannerList?.length??0,
              pagination: new SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    activeColor: Color.fromRGBO(255, 255, 255, 0.8),
                  )
              ),
              autoplay:bannerList?.isNotEmpty??false,
              loop: true,
              onTap: (index){
                Navigator.pushNamed(context, '/other');
              },
            ),
          ),
          Container(
            height: 65,
            alignment: Alignment.center,
            child: Text(
              '热门歌单推荐',
              style: TextStyle(color: MyColors.textColor, fontSize: 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(children: <Widget>[
              ...descListItem(),
              Offstage(
                  offstage:_player.playList.isEmpty ,
                  child: SizedBox(
                    height: 60,
                  )
              )

            ],),
          )
        ],
      )
    );
  }
}
