import 'dart:async';

import 'package:flutter/material.dart';
class Lead extends StatefulWidget {
  @override
  _LeadState createState() => _LeadState();
}

class _LeadState extends State<Lead> {
  int _currentIndex=3;
  Timer _timer;
  @override
  void initState(){
    startTimer();
    super.initState();
  }
  @override
  void dispose(){
    _timer?.cancel();
    super.dispose();
  }
  void startTimer(){
    _timer=Timer.periodic(Duration(seconds: 1), (Timer){
      if(_currentIndex<2){
        Navigator.pushReplacementNamed(context, '/tabs');
      }else{
        setState(() {
          _currentIndex--;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
     children: <Widget>[
       Positioned(
         left: 0,
         top: 0,
         right: 0,
         bottom: 0,
         child: Image.asset('images/lead.jpg',scale: 1,fit: BoxFit.cover,),
         ),
       
       Positioned(
         right: 20,
         top: 50,
         child: Container(
           alignment: Alignment.center,
           width: 40,
           height: 30,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(20),
             color: Colors.white10
           ),
           child: Text('$_currentIndex',style: TextStyle(
             color: Colors.white,
             fontSize: 14,
             decoration: TextDecoration.none
             ),),
         ),
       )
     ],
    );
  }
}