import 'package:flutter/material.dart';
import 'package:mc_donald_app/enum/order_status.dart';
import 'package:mc_donald_app/models/cooking_bot.dart';
import 'package:mc_donald_app/models/order.dart';
import 'package:mc_donald_app/order_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  OrderController orderController = OrderController();
  List<CookingBot> cookingBots = [];
  List<Order> pendingOrders = [];
  List<Order> completedOrders = [];
  @override
  Widget build(BuildContext context) {
    cookingBots = orderController.readBots();
    pendingOrders = orderController.readPendingOrders();
    completedOrders = orderController.readCompletedOrders();
    return Scaffold(
      body: SafeArea(child:
        Column(
          children: [
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      color: Colors.lightBlueAccent,
                      child: Column(
                        children: [
                          Text(OrderStatus.pending.toTitle()),
                          Flexible(
                            child: ListView.builder(itemCount: pendingOrders.length ,itemBuilder: (BuildContext context, int index){
                              return Text("${pendingOrders[index].id}", style: TextStyle(color: pendingOrders[index].isVip ? Colors.amber: Colors.black,),textAlign: TextAlign.center,);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                      color: Colors.grey,
                      child: Column(
                        children: [
                          Text(OrderStatus.completed.toTitle()),
                          Flexible(
                            child: ListView.builder(itemCount: completedOrders.length ,itemBuilder: (BuildContext context, int index){
                              return Text("${completedOrders[index].id}", style: TextStyle(color: completedOrders[index].isVip ? Colors.amber: Colors.black, ), textAlign: TextAlign.center,);
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Cooking Bots:"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("Cooking Bot No."),
                        Text("Processing Order No.")
                      ],
                    ),
                    Column(
                      children: List<Widget>.generate(cookingBots.length, (index) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("${cookingBots[index].id}", ),
                          Text(cookingBots[index].processingOrder != null ? "${cookingBots[index].processingOrder!.id}" : "Idle", style: TextStyle(color: cookingBots[index].processingOrder?.isVip ?? false ? Colors.amber: Colors.black),),
                        ],
                      )),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              child: Wrap(
                spacing: 5.0,
                children: [
                  ElevatedButton(onPressed: () {
                    Order newOrder = Order(isVip: false);
                    setState(() => orderController.createOrder(newOrder, completedCallback: () => completeOrder(newOrder)));
                  }, child: Text("Add normal order")),
                  ElevatedButton(onPressed: (){
                    Order newOrder = Order(isVip: true);
                    setState(() => orderController.createOrder(newOrder, completedCallback: () => completeOrder(newOrder)));
                  }, child: Text("Add VIP order")),
                  ElevatedButton(onPressed: (){
                    CookingBot bot = CookingBot();
                    print("tapped");
                    setState(() {
                      orderController.createBot(bot);
                    });
                  }, child: Text("Add cooking bot")),
                  ElevatedButton(onPressed: (){
                    setState(() {
                      orderController.deleteBot();
                    });
                  }, child: Text("Remove cooking bot")),
                ],
              )
            )
          ],
        )
      ),
    );
  }

  void completeOrder(Order order){
    setState(() {
      order.orderStatus = OrderStatus.completed;
      order.assignedBot?.processingOrder = null;
      CookingBot? bot = order.assignedBot;
      order.assignedBot = null;
      if(bot!= null){
        Order? idleOrder = orderController.readIdleOrder();
        if(idleOrder != null){
          setState(() {
            orderController.assignBot(bot, idleOrder);
          });
        }
      }
    });
  }
}
