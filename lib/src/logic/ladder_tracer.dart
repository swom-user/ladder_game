// lib/src/logic/ladder_tracer.dart

import '../models/ladder_connection.dart';
import '../models/ladder_path.dart';

/// 사다리 경로 계산기
class LadderTracer {
  /// 주어진 시작 열(startColumn)에서 내려가면서 경로를 계산
  static LadderPath tracePath({
    required LadderConnection connection,
    required int startColumn,
    required int participantCount,
  }) {
    List<int> steps = [startColumn];
    int currentColumn = startColumn;

    for (int row = 0; row < connection.rows.length; row++) {
      if (currentColumn > 0 &&
          connection.hasConnection(row, currentColumn - 1)) {
        // 왼쪽으로 이동
        currentColumn--;
      } else if (currentColumn < participantCount - 1 &&
          connection.hasConnection(row, currentColumn)) {
        // 오른쪽으로 이동
        currentColumn++;
      }
      steps.add(currentColumn);
    }

    return LadderPath(startIndex: startColumn, steps: steps);
  }

  /// 모든 참가자의 경로 계산
  static List<LadderPath> traceAllPaths({
    required LadderConnection connection,
    required int participantCount,
  }) {
    return List.generate(
      participantCount,
      (i) => tracePath(
        connection: connection,
        startColumn: i,
        participantCount: participantCount,
      ),
    );
  }

  /// 단순한 2차원 bool 배열로부터 경로 계산 (paste-2.txt 호환용)
  static List<int> traceSimplePath({
    required List<List<bool>> connections,
    required int startColumn,
    required int participantCount,
    required int ladderRows,
  }) {
    List<int> path = [startColumn];
    int currentColumn = startColumn;

    for (int row = 0; row < ladderRows; row++) {
      if (currentColumn > 0 && connections[row][currentColumn - 1]) {
        currentColumn--;
      } else if (currentColumn < participantCount - 1 &&
          connections[row][currentColumn]) {
        currentColumn++;
      }
      path.add(currentColumn);
    }

    return path;
  }

  /// 모든 참가자의 단순 경로 계산 (paste-2.txt 호환용)
  static List<List<int>> traceAllSimplePaths({
    required List<List<bool>> connections,
    required int participantCount,
    required int ladderRows,
  }) {
    return List.generate(
      participantCount,
      (i) => traceSimplePath(
        connections: connections,
        startColumn: i,
        participantCount: participantCount,
        ladderRows: ladderRows,
      ),
    );
  }
}
