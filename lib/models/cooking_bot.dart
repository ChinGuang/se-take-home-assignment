import 'package:mc_donald_app/models/order.dart';

class CookingBot{
  static int _nextId = 1;
  late int _id;
  int get id{
    return _id;
  }
  Order? processingOrder;
  CookingBot(){
    _id = _nextId++;
  }
}