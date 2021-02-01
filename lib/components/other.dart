import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:music/components/color.dart';
import 'package:music/components/wrap.dart';
List<String> _list=['http://mall.mmys.fun/%E7%BE%A41.jpg','http://mall.mmys.fun/%E4%B8%BB%E5%9B%BE.jpg',
'http://mall.mmys.fun/%E7%BE%A43-4%E5%90%88.jpg','http://mall.mmys.fun/%E7%BE%A42.jpg',
'http://mall.mmys.fun/%E5%8A%A8%E6%80%811.jpg','http://mall.mmys.fun/%E6%B6%88%E6%81%AF.jpg',
  'http://mall.mmys.fun/%E4%BA%BA%E5%91%98.jpg','http://mall.mmys.fun/%E6%90%9C%E7%B4%A2%E5%90%88%E9%9B%86.jpg',
  'http://mall.mmys.fun/%E6%88%91%E7%9A%84%E5%90%88%E9%9B%86.jpg'
];
List<String> _textList=['在线离线','私聊','好友资料','群聊','创建群','邀请人','提出房间','清空群聊天记录','删除群','创建文章','修改文章','删除文章','评论','个人中心','搜索'];
class Others extends StatefulWidget {
  @override
  _OthersState createState() => _OthersState();
}

class _OthersState extends State<Others> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('M聊'),
          backgroundColor: MyColors.bgColor,
          elevation: 0,
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 50,
              alignment: Alignment.center,
              child: Text('聊天交友我用M聊',style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 20
              ),),
            ),
            Container(
              margin: EdgeInsets.only(top: 6),
              height: 268,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return CachedNetworkImage(
                      imageUrl: _list[index],
                      fit: BoxFit.fill
                  );
                },
                itemCount: _list.length,
                pagination: new SwiperPagination(
                    builder: DotSwiperPaginationBuilder(
                      color: Color.fromRGBO(255, 255, 255, 0.5),
                      activeColor: Color.fromRGBO(255, 255, 255, 0.8),
                    )
                ),
                autoplay:true,
                loop: true,
                onTap: (int){
                  Navigator.pushNamed(context, '/photo');
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(bottom: 20, top: 20,left: 20),
                    child: Text(
                      '项目亮点',
                      style: TextStyle(
                          fontSize: 14, color: MyColors.textI),
                    ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: _searchWraps()
                  )
                )

              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              margin:EdgeInsets.only(bottom: 70),
              alignment: Alignment.center,
              child: Text('获取源码+QQ',style: TextStyle(
                fontSize: 20,
                color: MyColors.textColor
              ),),
            )
          ],
        )
    );

  }
  //  获取历史单个数据
  List<Widget> _searchWraps() {
    return _textList.map((item) {
      return MyWrap(
        text: item,
        onWrap: (val) {
          Navigator.pushNamed(context, '/photo');
        },
      );
    }).toList();
  }
}
