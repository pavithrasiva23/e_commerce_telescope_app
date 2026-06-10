import 'package:flutter/cupertino.dart';
import 'package:shop_a_to_z_user/db/db_helper.dart';
import 'package:shop_a_to_z_user/models/order_model.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orderList = [];

  Future<void> saveOrder(OrderModel order) async {
    return DbHelper.saveOrder(order);
  }
}