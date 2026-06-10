import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils{
  static showMsg(BuildContext context, String msg)=> ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  static getFormattedDate(DateTime dt, {String pattern = 'dd/MM/yyyy'}) =>
      DateFormat(pattern).format(dt);

  static get generateOrderId => 'ABC_${getFormattedDate(DateTime.now(), pattern: 'yyyyMMdd_HH:mm:ss')}';

  static num priceAfterDiscount(num price, num discount)=> price - (price * discount / 100);
}