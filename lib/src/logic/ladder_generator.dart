// lib/src/logic/ladder_generator.dart

import 'dart:math';

import '../models/ladder_connection.dart';

/// 사다리 가로줄 연결 생성기
class LadderGenerator {
  /// 랜덤 가로줄 생성
  static LadderConnection generate({
    required int participantCount,
    required int ladderRows,
    double connectionProbability = 0.4,
  }) {
    final random = Random();
    final List<List<bool>> connections = [];

    for (int row = 0; row < ladderRows; row++) {
      List<bool> rowConnections = List.filled(participantCount - 1, false);

      for (int col = 0; col < participantCount - 1; col++) {
        if (random.nextDouble() < connectionProbability) {
          // 연속 가로줄 방지
          if (col == 0 || !rowConnections[col - 1]) {
            rowConnections[col] = true;
          }
        }
      }

      connections.add(rowConnections);
    }

    return LadderConnection(connections);
  }
}
