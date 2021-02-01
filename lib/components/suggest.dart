import 'package:flutter/material.dart';
import '../model/searchList.dart';
import '../dao/searchDao.dart';
import '../components/color.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/ball_pulse_footer.dart';
import 'package:provider/provider.dart';
import '../providers/playProvider.dart';
class Suggest extends StatefulWidget {
  bool showSinger;
  final Function beforeScroll;
  final Function(SearchListItem) onTap;
  Suggest({Key key,this.showSinger,this.beforeScroll,this.onTap}):super(key:key);
  @override
  SuggestState createState() => SuggestState();
}

class SuggestState extends State<Suggest> {
  final String TYPE_SINGER = 'type_singer';
  final int perpage = 20;
  int page=1;
  bool hasMore=true;
  String searchQuery='';
  List<SearchListItem> result=[];
  ScrollController _scrollController=ScrollController();
  PlayProvider _player;
  @override
  void initState(){
    _player = Provider.of<PlayProvider>(context,listen: false);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotification){
          if(scrollNotification.runtimeType==ScrollStartNotification){
            widget.beforeScroll();
          }
          return true;
        },
        child: Container(
          color: MyColors.bgColor,
            child: EasyRefresh(
              onLoad: () async{
                if(hasMore==false){
                  return;
                }
                page++;
                SearchList res=await SearchDao.searchListAjax(searchQuery, page, 1, perpage);
                if(res.code==0){
                  result.addAll(res.result);
                  setState(() {
                    result=result;
                  });
                }
                _checkMore(res.result);
              },
              footer: BallPulseFooter(
                  color: MyColors.textD
              ),
              child:ListView.builder(
                  itemCount: result.length,
                  controller: _scrollController,
                  itemBuilder: (context,int index){
                    return GestureDetector(
                        onTap: (){
                          widget.onTap(result[index]);
                        },
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child:  Row(
                              children: <Widget>[
                                getIconCls(result[index]),
                                Expanded(
                                    child: getTextCls(result[index])
                                )

                              ],
                            )
                        )
                    );
                  }
              ),
            )
        )
    );
  }
  void search(String query) async{
    result.clear();
    setState(() {
      page=1;
      hasMore=true;
      searchQuery=query;
    });
    SearchList res=await SearchDao.searchListAjax(query, page, 1, perpage);
    if(res.code==0){
      setState(() {
        result=res.result;
      });

    }
    _checkMore(res.result);
    _scrollController.animateTo(0.0,duration: Duration(milliseconds: 1),curve: Curves.ease);
    if(res.result.isNotEmpty) _player?.saveSearchHistory(query);
  }
  void _checkMore(data){
    if(data==null||data.length==0){
      setState(() {
        hasMore=false;
      });
    }
  }
  Widget getIconCls(SearchListItem item){
    if(item.type==TYPE_SINGER){
      return Icon(IconData(0xe6e0,fontFamily: 'iconfont'),size: 14,color: MyColors.textD,);
    }else{
      return Icon(IconData(0xe680,fontFamily: 'iconfont'),size: 14,color: MyColors.textD,);
    }
  }
  Widget getTextCls(SearchListItem item){
    if(item.type==TYPE_SINGER){
      return setText('${item.singername}');
    }else{
      return setText('${item.name}-${item.singer}');
    }
  }
  Widget setText(String text){
    return  Padding(
        padding: EdgeInsets.only(left: 15),
        child:  Text('$text',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 14,
              color: MyColors.textD
          ),)
    );
  }
}
