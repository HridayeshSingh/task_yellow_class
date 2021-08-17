import 'package:flutter/material.dart';
import 'package:task_yellow_class/screens/loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YC Task',
      home: LoadingScreen(),
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0XFF10101A),
        scaffoldBackgroundColor: Color(0XFF10101A),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
