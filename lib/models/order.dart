import 'package:mc_donald_app/enum/order_status.dart';
import 'package:mc_donald_app/models/cooking_bot.dart';
import 'package:mc_donald_app/timer_service.dart';

class Order{
  static int _nextId = 1;
  late int _id;
  int get id{
    return _id;
  }

  late Duration _preparingTime;
  late TimerService timer;
  Duration get preparingTime{
    return _preparingTime;
  }

  late bool _isVip;
  bool get isVip{
    return _isVip;
  }

  late OrderStatus orderStatus;

  CookingBot? assignedBot;

  Order({preparingTime = const Duration(seconds: 10), isVip = false, this.orderStatus = OrderStatus.pending,}){
    _id = _nextId++;
    _preparingTime = preparingTime;
    _isVip = isVip;

  }

}