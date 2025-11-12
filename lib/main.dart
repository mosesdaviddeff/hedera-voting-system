import 'package:flutter/material.dart';
import 'package:voting_system/screens/login_screen.dart';
import 'package:voting_system/screens/result_screen.dart';
import 'package:voting_system/screens/voting_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hedera Voting DApp',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF121212),
        inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder()),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        VotingScreen.routeName: (context) => const VotingScreen(),
        ResultScreen.routeName: (context) => const ResultScreen(),
      },
    );
  }
}
