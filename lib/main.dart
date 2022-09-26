import 'package:computerstatussocketmobile/Screen/initial_screen.dart';
import 'package:flutter/material.dart';
import 'Screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComputerStatus Socket Mobile',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/initialscreen',
      routes: {
        '/initialscreen': (context) => const InitialScreen(),
        '/homescreen': (context) => const HomePage(),
      },
    );
  }
}

