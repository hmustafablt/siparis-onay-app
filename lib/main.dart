import 'package:flutter/material.dart';
import 'screens/order_list_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Sipariş Onay',
    theme: ThemeData(primarySwatch: Colors.indigo),
    home: OrderListScreen(),
  ));
}
