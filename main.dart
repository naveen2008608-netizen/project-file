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
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IRTC Railway Portal',

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),

      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),

      home: IRTCLoginPage(isDarkMode: _isDarkMode, onToggleTheme: _toggleTheme),
    );
  }
}
