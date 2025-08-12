// example/main.dart

import 'package:flutter/material.dart';
import 'package:ladder_game/ladder_game.dart';

void main() {
  runApp(const LadderGameExampleApp());
}

class LadderGameExampleApp extends StatelessWidget {
  const LadderGameExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 초기 참가자 리스트 (예시)
    final participants = List.generate(
      4,
      (index) => Participant(
        name: '참가자 ${index + 1}',
        result: '결과 ${index + 1}',
        image: ['🏆', '🎁', '🍕', '☕'][index],
      ),
    );

    final controller = LadderGameController(
      initialParticipants: participants,
      ladderRows: 5,
    );

    return MaterialApp(
      title: 'Ladder Game Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LadderGameScreen(controller: controller),
    );
  }
}
