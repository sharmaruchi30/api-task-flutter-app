import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_app/screens/homepage.dart';
import 'package:task_app/provider/productListProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductListProvider(),
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Products task App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB( 255,18,39,39)
      ),
      themeMode: ThemeMode.dark,
      home: const HomePage()
    ),
       );
  }
}

