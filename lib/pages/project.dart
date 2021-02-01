import 'package:flutter/material.dart';
import '../components/color.dart';
import 'photo.dart';
class Project extends StatelessWidget {
  List<String> _arrItem=['首页轮播图、自动轮播','歌曲列表','歌手列表、右边字母点击左边跟随、以及滑动体验','排行榜列表','搜索列表、输入歌手和歌曲名称、上拉加载更多、热门搜索','歌曲列表、随机播放、点击播放','播放列表、上一首、下一首、列表播放、随机播放、循环播放、以及歌词解析滚动'];
  List<String> _jsTitle=['完全flutter开发','状态管理provider','命名路由','dio接口请求','flutter_swiper轮播图插件','cached_network_image图片缓存','flutter_easyrefresh下拉加载','audioplayers音频播放器'];
  List<String> _sm=['学习flutter也有半年多时间一直都处于练习阶段，最近项目不忙就想用flutter写个真实项目，思来想去不知道写什么好，就看到网上有个vue开发的音乐播放器，该项目我之前用vue也写过，不仅界面好看，功能也强大，所以就决定开发这个音乐播放器;',
  '该项目用时接近二个月时间吧，牺牲了我所有的晚上时间和周末时间，全都是我一个人独立开发，遇到了很多难题，问别人也没人给我解答，然后各种百度和谷歌最后实在没法还是付费让别人给我解答结果还是不满意',
  '该项目不算是一个小型demo可以算是一个中型项目吧，总体来说flutter开发的APP算是比较满意的',
  '该项目值得学习的地方是歌手页面的左右联动、搜索页面的输入框以及上拉加载、歌曲页面的下拉放大图片、以及播放页面、播放页面的播放等功能、以及歌词滚动和联动等地方',
  '该项目完成95%，后面的语音输入以及其他功能只能慢慢完善'];
  List<String> _aa=['该项目是我个人项目的第二个完整项目','第一个是一个基于聊天和发布文章的APP有兴趣的可以去看下','该项目的思路讲解以及部分代码发布在掘金上面','我恩恩北京是我掘金账号','该项目APP不会发布在安卓市场上，要获取最新的可以重新下载'];
  List<String> lists = [
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212557760&di=2c0ccc64ab23eb9baa5f6582e0e4f52d&imgtype=0&src=http%3A%2F%2Fpic.feizl.com%2Fupload%2Fallimg%2F170725%2F43998m3qcnyxwxck.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212557760&di=37d5107e6f7277bc4bfd323845a2ef32&imgtype=0&src=http%3A%2F%2Fn1.itc.cn%2Fimg8%2Fwb%2Fsmccloud%2Ffetch%2F2015%2F06%2F05%2F79697840747611479.JPEG",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212557760&di=95860b0fd501110885cf6e191f7403f0&imgtype=0&src=http%3A%2F%2Fuploads.5068.com%2Fallimg%2F1712%2F144-1G2011I420.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212636935&di=110a278fe4fb22f07d183a049f36cba3&imgtype=jpg&src=http%3A%2F%2Fimg2.imgtn.bdimg.com%2Fit%2Fu%3D3695896267%2C3833204074%26fm%3D214%26gp%3D0.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212557759&di=3730dccf46e4b4f35bcb882148b973ee&imgtype=0&src=http%3A%2F%2Fpic1.win4000.com%2Fpic%2F3%2F71%2F4c5b0d26ad.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212557759&di=4f53fa8e1699def18e976deaee5558bf&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201707%2F07%2F20170707151851_r34Se.jpeg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212557758&di=ea77e663ac012b8ce7eb921454528cb8&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201707%2F07%2F20170707151853_Xr2UP.jpeg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686377&di=513a2deeb0b9f66ac9f7713c1f08e38c&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201809%2F20180926104109132.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686377&di=d895baef0710a780cbff871b68fbabba&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201810%2F20181015170515909.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686376&di=6c670e61692a4b8a8c97fc8d751df6e9&imgtype=0&src=http%3A%2F%2Fpic.qqtn.com%2Fup%2F2018-8%2F2018082209071335857.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686375&di=5772b73b9349682e9883d57394655c5e&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201809%2F20180926104109561.jpg",
    "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1919562808,974781852&fm=11&gp=0.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686375&di=6646871a196763dad8bfb7d0b74f4fad&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201809%2F20180925112416520.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686375&di=07280c585f18cac3c1f251e7a496e2f3&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201809%2F20180920095533914.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686374&di=e0d4e585e1bafcfc0534f793091fbd03&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201809%2F20180918142250630.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686374&di=734df4a0341928437473ffaf4103b04e&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201810%2F20181015170515157.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686374&di=da3b239ebf59f5baae05eea6c663e8e5&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201810%2F20181015111057142.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212686374&di=f1156ff86227ca20deeaf2251f9a4054&imgtype=0&src=http%3A%2F%2Fwmimg.sc115.com%2Fwm%2Fpic%2F1705%2F1705vzcqpmrsfxo.jpg",
    "https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=509143600,2831498304&fm=26&gp=0.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212767984&di=79e2286d0ecd5a944183eb319af5a07e&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201809%2F20180920104457446.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212767983&di=779e1f58291cb90d7635fb7575c14149&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201810%2F20181015134233184.jpg",
    "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1542212833549&di=6f022bf302e786643fb43b9ba9c5a75e&imgtype=0&src=http%3A%2F%2Flife.southmoney.com%2Ftuwen%2FUploadFiles_6871%2F201809%2F20180926110752933.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('项目介绍',),
          backgroundColor: MyColors.bgColor,
        ),
        body: Container(
          padding: EdgeInsets.only(left: 20,right: 10),
          child: ListView(
            padding: EdgeInsets.only(bottom: 70),
            children: <Widget>[
              _title('一、功能介绍'),
              ..._arrItem.asMap().keys.map((int _index){
                return _subtitle(_arrItem,_index);
              }).toList(),
              _title('二、所用技术'),
              ..._jsTitle.asMap().keys.map((int _index){
                  return _subtitle(_jsTitle,_index);
              }).toList(),
              _title('三、项目说明'),
              ..._sm.asMap().keys.map((_index){
                return _subtitle(_sm,_index);
              }).toList(),
              _title('四、项目展示'),
              ..._aa.asMap().keys.map((_index){
                return _subtitle(_aa,_index);
              }).toList(),
            ],
          ),
        )
    );
  }
  Widget _title(String title){
    return Padding(
      padding: EdgeInsets.only(top: 10,bottom: 10),
      child: Text(title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xffeeeeee)
      ),
      ),
    );
  }
  Widget _subtitle(List _list,int index){
    return  Text('${index+1}、${_list[index]}',
          strutStyle: StrutStyle(forceStrutHeight: true, height: 2),
          style: TextStyle(
          fontSize: 14,
          color: MyColors.textD,
        ),
    );
  }
}
