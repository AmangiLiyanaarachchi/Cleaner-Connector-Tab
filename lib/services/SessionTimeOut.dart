import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimeOutListner extends StatefulWidget {
  Widget child;
  Duration duration;
  VoidCallback onTimeOut;
   SessionTimeOutListner({super.key, required this.child, required this.duration, required this.onTimeOut});

  @override
  State<SessionTimeOutListner> createState() => _SessionTimeOutListnerState();
}

class _SessionTimeOutListnerState extends State<SessionTimeOutListner> {
  @override

  Timer? _timer;
  _startTimer() {
    print("Timer reset");
    if (_timer != null)
    {
      print(_timer);
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer(widget.duration, (){
      print("aaaaaa");
      widget.onTimeOut();
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null)
    {
      print(_timer);
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_){
        _startTimer();
      },
        child: widget.child);
  }
}
