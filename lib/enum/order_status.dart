enum OrderStatus{
  pending, completed
}

extension OrderStatusExtension on OrderStatus{
  String toTitle(){
    switch(this){
      case OrderStatus.pending: return "Pending";
      case OrderStatus.completed: return "Completed";
    }
  }
}