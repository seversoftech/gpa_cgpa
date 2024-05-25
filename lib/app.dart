import 'package:flutter/material.dart';

import 'screens/splash.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(context) {
    return MaterialApp(
      title: "CGPA Calculator",
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.purple.shade800),
        
        primaryColor: Colors.purple[300],
        hintColor: Colors.purple[600],
        textTheme: const TextTheme(
          titleMedium: TextStyle(fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
