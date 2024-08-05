import 'package:client/screens/game_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Logger.level = Level.fatal;

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),      
      routes: <String, WidgetBuilder> {
        "splash": (context) => const SplashScreen(),
        "login":(context) => const LoginScreen(),
        "game":(context) => const GameScreen(),
      },      
      initialRoute: "splash",
    );
  }
}