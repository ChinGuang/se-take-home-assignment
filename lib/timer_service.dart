import 'dart:async';

import 'package:flutter/foundation.dart';

class TimerService{
  late Stopwatch _watch;
  Timer? _timer;
  late Duration _processDuration ;
  Function() callback;
  TimerService({Duration processDuration = const Duration(seconds: 10), required this.callback}){
    _processDuration = processDuration;
    _watch = Stopwatch();
  }

  void start(){
    _timer = Timer(_processDuration - _watch.elapsed, callback);
    _watch.start();
  }

  void pause(){
    _timer?.cancel();
    _watch.stop();
  }

  String show(){
    Duration remainingDuration = _processDuration - _watch.elapsed;
    return "${remainingDuration.inMinutes}:${(remainingDuration.inSeconds % 60).toString() }";
  }
}