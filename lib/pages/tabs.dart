import 'package:flutter/material.dart';
import 'package:music/components/color.dart';
import './recomment.dart';
import './singer.dart';
import './rank.dart';
import './search.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
class Tabs extends StatefulWidget {
  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState(){
    _tabController=TabController(length: 4,vsync: this);
    _tabController.addListener((){
    });
    super.initState();
  }
  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final _player = Provider.of<PlayProvider>(context);
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: Builder(
            builder: (context)=>IconButton(
              icon: Icon(IconData(0xe61c,fontFamily:'iconfont'),color:MyColors.textColor,size: 20,),
              onPressed: (){
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          centerTitle: true,
          backgroundColor:MyColors.bgColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(IconData(0xe6e0,fontFamily: 'iconfont'),color: MyColors.textColor,size: 20,),
              onPressed: (){
                Navigator.pushNamed(context, '/me');
              },
            )
          ],
          title: Text('MyMusic',style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w300,
              color:MyColors.textColor
          ),
          ),
          bottom: TabBar(
            isScrollable: false,
            controller: _tabController,
            indicatorColor: MyColors.textColor,
            indicatorWeight: 2,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: MyColors.textColor,
            labelStyle: TextStyle(
              fontSize: 16,
            ),
            unselectedLabelColor: Color.fromRGBO(255, 255, 255, 0.5),
            unselectedLabelStyle: TextStyle(
                fontSize: 14
            ),
            tabs: <Widget>[
              Tab(
                  text: '推荐'
              ),
              Tab(
                text: '歌手',
              ),
              Tab(
                  text: '排行'
              ),
              Tab(
                text: '搜索',
              )
            ],
          ),
        ),
        drawer: Drawer(
            elevation: 0,
            child: Column(
              children: <Widget>[
                Container(
                    height: 150,
                    padding: EdgeInsets.only(left: 40,bottom: 35,top: 60),
                    alignment: Alignment.center,
                    color: MyColors.bgColor,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 40),
                          child: Icon(IconData(0xe60a,fontFamily: 'iconfont'),size: 25,color: MyColors.textColor,),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('田先生',style: TextStyle(
                                    color: MyColors.textE,
                                    fontSize: 16
                                ),),
                                Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child:Text('qq:384434682',style: TextStyle(
                                        color: MyColors.textD,
                                        fontSize: 14
                                    ),)
                                )

                              ],
                            )
                        )

                      ],
                    )
                ),
                Expanded(
                  child: Container(
                    color: MyColors.black,
                    padding: EdgeInsets.only(left: 40,right: 40),
                    child: Column(
                    children: <Widget>[
                        SizedBox(height: 10,),
                        setNavTitle(IconData(0xe71c,fontFamily: 'iconfont'),'项目介绍',url: '/project'),
                        setNavTitle(IconData(0xe604,fontFamily: 'iconfont'),'我的收藏'),
                        setNavTitle(IconData(0xe6e0,fontFamily: 'iconfont'),'访问记录'),
                        setNavTitle(IconData(0xe608,fontFamily: 'iconfont'),'M聊项目',isBool: true,url: '/other'),
                        setNavTitle(IconData(0xe609,fontFamily: 'iconfont'),'我的好友'),
                        setNavTitle(IconData(0xe64f,fontFamily: 'iconfont'),'听歌识曲'),
                      ],
                    ),
                  ),
                )
              ],
            )
        ),
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Recomment(),
            Singer(),
            Rank(),
            Search()
          ],
        ),
      ),
      onWillPop: () async{
        if(_player.playList.isNotEmpty&&_player.fullScreen){
          _player.setFullScreen(false);
          _player.setLyricCurrentIndex(0);
          return Future.value(false);
        }else if(_player.overlayAlert!=null){
          _player.overlayAlert?.remove();
          _player.overlayAlert=null;
          return Future.value(false);
        }else if(_player.playList.isNotEmpty){
          _player.overlay?.remove();
          _player.clearPlayList();
          return Future.value(false);
        }else{
        return Future.value(true);
        }

      },
    );

  }
  Widget setNavTitle(IconData icon,String title,{String url,bool isBool=false}){
    return GestureDetector(
      onTap: (){
      Navigator.pop(context);
      Navigator.pushNamed(context, url);
      },
      child:  Container(
        height: 65,
        alignment: Alignment.center,
        decoration: BoxDecoration(
//            color: Colors.red,
          border: Border(
            bottom: BorderSide(width: 0.2,color: MyColors.textI)
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(icon,color: isBool?MyColors.textColor:MyColors.textI,size: 20,),
            Padding(
                padding: EdgeInsets.only(left: 18),
                child: Text(title,style: TextStyle(
                    color:isBool?MyColors.textColor:MyColors.textI,
                    fontSize: 14
                ),
                )
            )
          ],
        ),
      )
    );
  }
}