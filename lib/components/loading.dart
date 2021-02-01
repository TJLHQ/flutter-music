import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/color.dart';
///进度条组件
class LoadingContainer extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const LoadingContainer(
      {Key key,
        @required this.isLoading,
        @required this.child})
      : super(key: key);
  @override
  _LoadingContainerState createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadingContainer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState(){
    super.initState();
    _controller=AnimationController(vsync: this,duration: Duration(seconds: 1));
  }
  @override
  Widget build(BuildContext context) {
    return !widget.isLoading ? widget.child : _loadingView;
  }
  Widget get _loadingView {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Center(
            child: SpinKitSquareCircle(
              color: MyColors.textColor,
              size: 30.0,
              controller: _controller,
            ) //进度条
          ),
        ),
      ],
    );

  }
}


