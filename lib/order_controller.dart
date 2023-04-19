import 'package:flutter/cupertino.dart';
import 'package:mc_donald_app/enum/order_status.dart';
import 'package:mc_donald_app/models/cooking_bot.dart';
import 'package:mc_donald_app/models/order.dart';
import 'package:mc_donald_app/timer_service.dart';

class OrderController{
  final List<Order> _orderList = [];
  final List<CookingBot> _botList = [];

  OrderController();

  void createOrder(Order order, {required Function() completedCallback}) {
    _orderList.add(order);
    order.timer = TimerService(callback: completedCallback);
    CookingBot? bot = readIdleBot();
    if(bot!= null){
      assignBot(bot, order);
      startProcessing(order);
    }
  }
  List<Order> readPendingOrders() {
    List<Order> pendingList = _orderList.where((element) => element.orderStatus == OrderStatus.pending).toList();
    List<Order> vipList = pendingList.where((element) => element.isVip).toList();
    List<Order> normalList = pendingList.where((element) => !element.isVip).toList();
    return vipList + normalList;
  }
  List<Order> readCompletedOrders() => _orderList.where((element) => element.orderStatus == OrderStatus.completed).toList();
  void createBot(CookingBot bot){
    try {
      _botList.add(bot);
      Order? idleOrder = readIdleOrder();
      if(idleOrder != null){
        assignBot(bot, idleOrder);
      }
    } on Exception catch (e,s) {
      print(e);
      print(s);
    }
  }

  List<CookingBot> readBots() => _botList;
  void deleteBot() {
    if(_botList.isNotEmpty) {
      CookingBot bot = _botList.removeLast();
      if (bot.processingOrder != null) {
        bot.processingOrder?.assignedBot = null;
        stopProcessing(bot.processingOrder!);
      }
    }
  }
  Order? readIdleOrder(){
    List<Order> idleOrderList = _orderList.where((element) => element.orderStatus == OrderStatus.pending && element.assignedBot == null).toList();
    List<Order> idleVipOrderList = idleOrderList.where((element) => element.isVip).toList();
    if(idleVipOrderList.isEmpty){
      if(idleOrderList.isEmpty) {
        return null;
      }else{
        return idleOrderList.first;
      }
    }else{
      return idleVipOrderList.first;
    }
  }
  CookingBot? readIdleBot(){
    List<CookingBot> idleBotList = _botList.where((element) => element.processingOrder == null).toList();
    if(idleBotList.isEmpty){
      return null;
    }else{
      return idleBotList.first;
    }
  }
  void assignBot(CookingBot bot, Order order){
    bot.processingOrder = order;
    order.assignedBot = bot;
    startProcessing(order);
  }

  void startProcessing(Order order) => order.timer.start();

  void stopProcessing(Order order) => order.timer.pause();
}