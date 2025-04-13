import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(GSafeApp());
}

class GSafeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'G-Safe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeScreen(),
    );
  }
}
