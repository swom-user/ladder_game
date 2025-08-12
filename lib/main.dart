import 'package:flutter/material.dart';

import 'src/ui/ladder_game_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '사다리게임',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LadderGameScreen(),
    );
  }
}
