import 'package:flutter/material.dart';

import 'IRTCLoginPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = true;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'IRTC Railway Portal',

      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),

      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),

      home: IRTCLoginPage(isDarkMode: isDarkMode, onToggleTheme: toggleTheme),
    );
  }
}
