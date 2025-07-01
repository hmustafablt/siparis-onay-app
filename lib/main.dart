import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(MaterialApp(
    title: 'Sipariş Takip',
    theme: ThemeData(primarySwatch: Colors.indigo),
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}
