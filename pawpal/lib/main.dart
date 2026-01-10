import 'package:flutter/material.dart';
import 'package:pawpal/views/splashScreen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade50),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.pinkAccent.shade100,
          foregroundColor: Colors.white,
        ),
      ),
      home: SplashScreen(),
    );
  }
}
