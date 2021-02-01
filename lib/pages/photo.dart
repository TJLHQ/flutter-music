import 'package:flutter/material.dart';
import '../components/color.dart';
import 'package:cached_network_image/cached_network_image.dart';
class Photo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GridAnimationState();
  }
}

class GridAnimationState extends State<Photo> {
  List<String> lists = ['http://mall.mmys.fun/%E7%BE%A41.jpg','http://mall.mmys.fun/%E4%B8%BB%E5%9B%BE.jpg',
    'http://mall.mmys.fun/%E7%BE%A43-4%E5%90%88.jpg','http://mall.mmys.fun/%E7%BE%A42.jpg',
    'http://mall.mmys.fun/%E5%8A%A8%E6%80%811.jpg','http://mall.mmys.fun/%E6%B6%88%E6%81%AF.jpg',
    'http://mall.mmys.fun/%E4%BA%BA%E5%91%98.jpg','http://mall.mmys.fun/%E6%90%9C%E7%B4%A2%E5%90%88%E9%9B%86.jpg',
    'http://mall.mmys.fun/%E6%88%91%E7%9A%84%E5%90%88%E9%9B%86.jpg'
  ];
  void showPhoto(BuildContext context,f,index) {
    Navigator.push(context, MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
                title: Text('图片${index+1}'),
              backgroundColor: Color(0xff000000),
            ),
            body: SizedBox.expand(
              child: Hero(
                tag: index,
                child: new PhotoImage(url:f),
              ),
            ),
          );
        }
    ));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.bgColor,
          title: Text('photo'),
        ),
        body: new Column(
          children: <Widget>[
            new Expanded(
              child: new SafeArea(
                top: false,
                bottom: false,
                child: new GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 4.0,
                  padding: const EdgeInsets.all(4.0),
                  childAspectRatio: 1.5,
                  children: lists.map((f) {
                    return new GestureDetector(
                      onTap: () {
                        var index;
                        if(lists.contains(f)){
                          index = lists.indexOf(f);
                        }
                        showPhoto(context,f,index);
                      },
                      child: CachedNetworkImage(
                          imageUrl: f,
                          fit: BoxFit.fill
                      )
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ));
  }
}

class PhotoImage extends StatefulWidget {
  const PhotoImage({Key key, this.url}) : super(key: key);
  final url;
  @override
  State<StatefulWidget> createState() {
    return PhotoState();
  }
}

class PhotoState extends State<PhotoImage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;
  double _kMinFlingVelocity = 600.0;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _offset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    // widget的屏幕宽度
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    // 限制他的最小尺寸
    return Offset(
        offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));

  }

  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // 计算图片放大后的位置
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 3.0);
      // 限制放大倍数 1~3倍
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
      // 更新当前位置
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    // 计算当前的方向
    final double distance = (Offset.zero & context.size).shortestSide;
    // 计算放大倍速，并相应的放大宽和高，比如原来是600*480的图片，放大后倍数为1.25倍时，宽和高是同时变化的
    _animation = _controller.drive(Tween<Offset>(
        begin: _offset, end: _clampOffset(_offset + direction * distance)));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()..translate(_offset.dx, _offset.dy)
            ..scale(_scale),
          child: Image.network(widget.url,fit: BoxFit.cover,),
        ),
        // child: Image.network(widget.url,fit: BoxFit.cover,),
      ),
    );
  }
}