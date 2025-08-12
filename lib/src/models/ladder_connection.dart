// lib/src/models/ladder_connection.dart

import 'dart:math';

/// 사다리의 가로줄 연결 상태를 관리하는 모델
class LadderConnection {
  /// [rows]는 각 행(row)의 가로줄 연결 상태를 담고 있음.
  /// 예: participantCount = 4 이면 col = 3
  /// rows[rowIndex][colIndex] == true → 해당 위치에 가로줄 있음
  final List<List<bool>> rows;

  LadderConnection(this.rows);

  /// 랜덤으로 가로줄 연결 상태를 생성하는 팩토리 메서드
  factory LadderConnection.generate({
    required int participantCount,
    required int ladderRows,
    double connectionProbability = 0.4,
  }) {
    final random = Random();
    final List<List<bool>> generatedRows = [];

    for (int row = 0; row < ladderRows; row++) {
      List<bool> rowConnections = List.filled(participantCount - 1, false);

      for (int col = 0; col < participantCount - 1; col++) {
        if (random.nextDouble() < connectionProbability) {
          // 인접한 col에 연속 가로줄 방지
          if (col == 0 || !rowConnections[col - 1]) {
            rowConnections[col] = true;
          }
        }
      }

      generatedRows.add(rowConnections);
    }

    return LadderConnection(generatedRows);
  }

  /// 현재 연결 상태를 복제
  LadderConnection copy() {
    return LadderConnection(rows.map((row) => List<bool>.from(row)).toList());
  }

  /// 특정 위치의 가로줄 여부 반환
  bool hasConnection(int row, int col) {
    if (row < 0 || row >= rows.length) return false;
    if (col < 0 || col >= rows[row].length) return false;
    return rows[row][col];
  }

  /// 연결 상태를 문자열로 디버그 출력
  @override
  String toString() {
    final buffer = StringBuffer();
    for (var row in rows) {
      buffer.writeln(row.map((c) => c ? '—' : '·').join(' '));
    }
    return buffer.toString();
  }
}
